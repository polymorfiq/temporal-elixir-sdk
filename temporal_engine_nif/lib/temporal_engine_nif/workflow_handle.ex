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
  require TemporalEngine.Data.Failure
  import TemporalEngine.Data.Queries
  import TemporalEngine.Data.Payload
  import TemporalEngine.Opts.HandleOpts

  alias TemporalEngine.Data.Duration
  alias TemporalEngineNif.Core
  alias TemporalEngine.Data.Failure

  @impl true
  def get_result(handle, opts \\ []) do
    with {:ok, opts} <- get_workflow_result_opts_from_opts(opts) do
      parent = self()

      {pid, ref} =
        spawn_monitor(fn ->
          Core._workflow_handle_get_result(
            handle.client.runtime.core,
            handle.core,
            opts,
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
        if timeout = get_workflow_result_opts(opts, :timeout) do
          timeout |> Duration.to_milliseconds()
        else
          :infinity
        end

      receive do
        {^pid, {:ok, args}} ->
          {:ok, workflow_arguments(args, :args) |> List.first()}

        {^pid, {:error, {:failed, failure}}} ->
          {:error, Failure.workflow_failed(failure: failure)}

        {^pid, {:error, {:cancelled, details}}} ->
          {:error, Failure.workflow_cancelled(details: details)}

        {^pid, {:error, {:terminated, details}}} ->
          {:error, Failure.workflow_terminated(details: details)}

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

  @impl true
  def query(handle, query_type, args, opts) do
    parent = self()

    query = workflow_query(query_type: query_type, query_args: args)

    {pid, ref} =
      spawn_monitor(fn ->
        Core._handle_query_workflow(
          handle.client.runtime.core,
          handle.core,
          query,
          query_options(opts, :reject_condition),
          self()
        )
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not start workflow via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, response} ->
            send(parent, {self(), {:ok, response}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end
end
