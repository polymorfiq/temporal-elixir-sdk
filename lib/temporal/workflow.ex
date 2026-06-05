defmodule Temporal.Workflow do
  alias Temporal.CoreSdk
  alias Temporal.Workflows.WorkflowExecHandle
  alias Temporal.CoreSdk.Data.WorkflowGetResultOptions

  @type workflow_exec_handle() :: WorkflowExecHandle.t()
  @type get_results_opts() :: [
          {:follow_runs, bool()},
          {:timeout, {pos_integer(), :second} | {pos_integer(), :ms}}
        ]

  @watch_result_msg :workflow_result

  defmacro __using__(_opts) do
    quote do
    end
  end

  @spec result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, WorkflowArguments.t()} | {:error, term()}
  def result(%WorkflowExecHandle{} = handle, opts \\ []) do
    with {:ok, opts} <- Keyword.validate(opts, [:follow_runs, :timeout]) do
      runtime = handle.client.runtime

      get_result_opts = %WorkflowGetResultOptions{
        follow_runs: Keyword.get(opts, :follow_runs, true)
      }

      parent = self()

      {pid, ref} =
        spawn_monitor(fn ->
          CoreSdk._workflow_handle_get_result(
            runtime.runtime,
            handle.handle,
            get_result_opts,
            self()
          )
          |> case do
            {:ok, _} -> :ok
            {:error, err} -> raise "Could not get workflow result from Core SDK: #{inspect(err)}"
          end

          receive do
            {:ok, result} ->
              send(parent, {self(), {:ok, result}})

            {:error, err} ->
              send(parent, {self(), {:error, err}})
          end
        end)

      timeout = Keyword.get(opts, :timeout, :infinity)

      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      after
        timeout ->
          {:error, :timeout}
      end
    end
  end

  @spec watch_result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, WorkflowArguments.t()} | {:error, term()}
  def watch_result(%WorkflowExecHandle{} = handle, opts \\ []) do
    parent = self()

    spawn_link(fn ->
      send(parent, {@watch_result_msg, handle, result(handle, opts)})
    end)
  end
end
