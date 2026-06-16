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
  require TemporalEngine.Data.Failure

  alias TemporalEngineNif.Data.WorkflowGetResultOptions
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngine.Data.Duration
  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Data.WorkflowFailure
  alias TemporalEngine.Data.Failure

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
        timeout |> Duration.to_milliseconds()
      else
        :infinity
      end

    receive do
      {^pid, {:ok, args}} ->
        result = List.first(args.args)
        {:ok, if(result, do: Payload.to_record(result))}

      {^pid, {:error, {:failed, failure}}} ->
        {:error, Failure.workflow_failed(failure: WorkflowFailure.to_record(failure))}

      {^pid, {:error, {:cancelled, details}}} ->
        {:error, Failure.workflow_cancelled(details: Enum.map(details, &Payload.to_record/1))}

      {^pid, {:error, {:terminated, details}}} ->
        {:error, Failure.workflow_terminated(details: Enum.map(details, &Payload.to_record/1))}

      {^pid, {:error, :timed_out}} ->
        {:error, Failure.workflow_timed_out()}

      {^pid, {:error, :continued_as_new}} ->
        {:error, Failure.workflow_continued_as_new()}

      {^pid, {:error, :not_found}} ->
        {:error, Failure.workflow_not_found()}

      {^pid, {:error, {:payload_conversion, message}}} ->
        {:error, Failure.workflow_payload_conversion(message)}

      {^pid, {:error, {:rpc, message}}} ->
        {:error, Failure.workflow_rpc_error(message)}

      {^pid, {:error, {:other, message}}} ->
        {:error, message}

      {^pid, {:error, err}} ->
        {:error, err}

      {:DOWN, ^ref, :process, ^pid, %RuntimeError{} = rt_err} ->
        {:error, rt_err}
    after
      timeout ->
        {:error, :timeout}
    end
  end
end
