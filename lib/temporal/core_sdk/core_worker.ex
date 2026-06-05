defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:worker]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias CoreSdk.Data.WorkflowActivation
  alias CoreSdk.Data.ActivityTask
  alias CoreSdk.Data.NexusTask

  @type t :: %__MODULE__{
          worker: term()
        }

  @spec new(runtime :: CoreRuntime.t(), client :: CoreClient.t(), opts :: WorkerOpts.t()) ::
          {:ok, t()} | {:error, term()}
  def new(runtime, client, opts) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_worker(runtime.core, client.client, opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize worker from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, worker} ->
            send(parent, {self(), {:ok, worker}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    worker_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    with {:ok, worker_ref} <- worker_resp,
         :ok <- validate(worker_ref, runtime) do
      {:ok, %__MODULE__{worker: worker_ref}}
    end
  end

  @spec validate(worker_ref :: term(), CoreRuntime.t()) :: :ok | {:error, term()}
  def validate(worker_ref, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._validate_worker(runtime.core, worker_ref, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not validate worker via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    validate_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case validate_resp do
      :ok -> :ok
      {:error, err} -> {:error, "Validation error: #{inspect(err)}"}
    end
  end

  @spec poll_workflow_activations(t(), CoreRuntime.t()) ::
          {:ok, WorkflowActivation.t() | nil} | {:error, term()}
  def poll_workflow_activations(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_workflow_activation(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could poll activations from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, activation} ->
            send(parent, {self(), {:ok, activation}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    activations_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case activations_resp do
      {:ok, activation} -> {:ok, activation}
      {:error, err} -> {:error, "Workflow activation poll error: #{inspect(err)}"}
    end
  end

  @spec poll_activity_tasks(t(), CoreRuntime.t()) ::
          {:ok, ActivityTask.t() | nil} | {:error, term()}
  def poll_activity_tasks(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_activity_task(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not poll activity tasks from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    task_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case task_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Activity task poll error: #{inspect(err)}"}
    end
  end

  @spec poll_nexus_tasks(t(), CoreRuntime.t()) :: {:ok, NexusTask.t() | nil} | {:error, term()}
  def poll_nexus_tasks(worker, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._worker_poll_nexus_task(runtime.core, worker.worker, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could not poll nexus tasks from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, task} ->
            send(parent, {self(), {:ok, task}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    task_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case task_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Nexus task poll error: #{inspect(err)}"}
    end
  end
end
