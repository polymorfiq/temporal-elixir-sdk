defmodule Temporal.WorkflowExecution do
  @moduledoc "Interactions with Workflow Executions that have been sent to the Temporal Server"

  import TemporalEngine.Opts.HandleOpts

  require TemporalEngine.Data.Failure

  alias TemporalEngine.Converter.DataConverter
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.WorkflowHandle

  @spec get(WorkflowHandle.t(), opts :: keyword()) :: {:ok, term()} | {:error, term()}
  def get(handle, opts \\ []) do
    client = WorkflowHandle.client(handle)
    conv = TemporalEngine.Client.data_converter(client)

    with {:ok, opts} <- get_workflow_result_from_opts(opts) do
      case WorkflowHandle.get_result(handle, opts) do
        {:ok, resp} ->
          DataConverter.from_payload(conv, resp)

        {:error,
         Failure.workflow_failed(
           failure:
             Failure.failure(
               failure_info:
                 Failure.application(failure_type: "ReturnedError", details: [resp_payload])
             )
         )} ->
          {:ok, resp} = DataConverter.from_payload(conv, resp_payload)
          {:error, resp}

        {:error, Failure.workflow_failed(failure: f)} ->
          {:error, Failure.to_map(conv, f) |> Map.put(:error_code, :workflow_failed)}

        {:error, Failure.workflow_cancelled(details: details)} ->
          {:ok, details} = DataConverter.from_payloads(conv, details)

          {:error,
           %{
             error_code: :workflow_cancelled,
             details: details
           }}

        {:error, Failure.workflow_terminated(details: details)} ->
          {:ok, details} = DataConverter.from_payloads(conv, details)

          {:error,
           %{
             error_code: :workflow_terminated,
             details: details
           }}

        {:error, Failure.workflow_timed_out()} ->
          {:error, %{error_code: :workflow_timed_out}}

        {:error, Failure.workflow_continued_as_new()} ->
          {:error, %{error_code: :workflow_continued_as_new}}

        {:error, Failure.workflow_not_found()} ->
          {:error, %{error_code: :workflow_not_found}}

        {:error, Failure.workflow_payload_conversion(message: message)} ->
          {:error, %{error_code: :workflow_payload_conversion, message: message}}

        {:error, Failure.workflow_rpc_error(message: message)} ->
          {:error, %{error_code: :workflow_rpc_error, message: message}}

        {:error, Failure.workflow_other_error(message: message)} ->
          {:error, %{error_code: :workflow_other_error, message: message}}

        {:error, err} ->
          {:error, err}
      end
    end
  end
end
