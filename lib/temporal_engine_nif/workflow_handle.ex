defmodule TemporalEngineNif.WorkflowHandle do
  defstruct [:core, :client, :workflow_name, :workflow_id, :task_queue]

  alias TemporalEngineNif.Client

  @type t :: %{
          core: term(),
          client: Client.t(),
          workflow_name: String.t(),
          workflow_id: String.t(),
          task_queue: String.t()
        }
end

defimpl TemporalEngine.WorkflowHandle, for: TemporalEngineNif.WorkflowHandle do
  import TemporalEngine.WorkflowHandle

  alias TemporalEngineNif.Data.WorkflowGetResultOptions
  alias TemporalEngine.Data.Duration
  alias TemporalEngineNif.Core

  @impl true
  def get_result(handle, opts) do
    get_opts = %WorkflowGetResultOptions{follow_runs: get_result_opts(opts, :follow_runs)}

    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._workflow_handle_get_result(
          handle.client.runtime.core,
          handle.core,
          get_opts,
          self()
        )
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not get workflow result from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, result} ->
            send(parent, {self(), {:ok, result}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    timeout =
      if timeout = get_result_opts(opts, :timeout) do
        Duration.from_tuple(timeout) |> Duration.to_milliseconds()
      else
        :infinity
      end

    receive do
      {^pid, {:ok, args}} ->
        args

      {:DOWN, ^ref, :process, ^pid, %RuntimeError{} = rt_err} ->
        {:error, rt_err}
    after
      timeout ->
        {:error, :timeout}
    end
  end
end
