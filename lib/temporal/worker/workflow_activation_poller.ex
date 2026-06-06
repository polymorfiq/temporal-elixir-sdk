defmodule Temporal.Worker.WorkflowActivationPoller do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletion
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus
  alias Temporal.CoreSdk.Data.WorkflowFailure

  require Logger
  require Record
  Record.defrecordp(:poll_state, [:worker_id, :worker_pid, :core_worker, :core_runtime])

  def start_link({worker_id, server_opts}) do
    GenServer.start_link(__MODULE__, worker_id, server_opts)
  end

  @spec init({CoreRuntime.t(), CoreClient.t(), WorkerOpts.t()}) :: {:ok, pid()} | {:error, term()}
  def init(worker_id) do
    with {:ok, worker_pid} <- WorkerSupervisor.worker_pid(worker_id),
         {:ok, core_worker} <- CoreWorker.get_core(worker_pid),
         {:ok, core_runtime} <- CoreWorker.get_runtime(worker_pid) do
      {:ok,
       poll_state(
         worker_id: worker_id,
         worker_pid: worker_pid,
         core_worker: core_worker,
         core_runtime: core_runtime
       ), {:continue, :poll_for_activations}}
    end
  end

  @doc false
  def handle_continue(:poll_for_activations, state) do
    with {{:ok, _}, state} <- poll_and_inform_worker(state) do
      {:noreply, state, {:continue, :poll_for_activations}}
    else
      {{:error, error}, _} ->
        {:stop, {:poll_error, error}, state}
    end
  end

  defp poll_and_inform_worker(state) do
    runtime_core = poll_state(state, :core_runtime)
    worker_core = poll_state(state, :core_worker)
    worker_pid = poll_state(state, :worker_pid)

    parent = self()

    child =
      spawn_link(fn ->
        case CoreSdk._worker_poll_workflow_activation(runtime_core.core, worker_core.core, self()) do
          :ok ->
            receive do
              {:ok, activation} ->
                send(parent, {self(), {:ok, activation}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(
              parent,
              {self(), {:error, "Error polling workflow activations: #{inspect(resp)}"}}
            )
        end
      end)

    poll_resp =
      receive do
        {^child, {:ok, activation}} ->
          case CoreWorker.process_workflow_activation(worker_pid, activation) do
            {:ok, resp} ->
              :ok = send_complete_activation(activation.run_id, state, resp)
              {:ok, activation}

            {:error, err} ->
              :ok =
                send_complete_activation(
                  activation.run_id,
                  state,
                  %WorkflowActivationCompletionFailureStatus{
                    force_cause: 0,
                    failure: %WorkflowFailure{
                      message: "Error processing polled activation: #{inspect(err)}"
                    }
                  }
                )

              {:error, err}
          end

        {^child, {:error, err}} ->
          send(worker_pid, {:workflow_activation_error, err})
          {:error, err}
      end

    {poll_resp, state}
  end

  defp send_complete_activation(run_id, state, response) do
    runtime_core = poll_state(state, :core_runtime)
    worker_core = poll_state(state, :core_worker)

    resp_msg =
      case response do
        %WorkflowActivationCompletionSuccessStatus{} ->
          %WorkflowActivationCompletion{run_id: run_id, status: {:successful, response}}

        %WorkflowActivationCompletionFailureStatus{} ->
          %WorkflowActivationCompletion{run_id: run_id, status: {:failed, response}}
      end

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_workflow_activation(
          runtime_core.core,
          worker_core.core,
          resp_msg,
          self()
        )
        |> case do
          :ok ->
            receive do
              {:ok, _} ->
                send(parent, {self(), {:ok, true}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error completing activation: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, _}} ->
        :ok

      {^child, {:error, err}} ->
        {:error, err}
    end
  end
end
