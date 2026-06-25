defmodule Temporal.WorkflowExecution do
  @moduledoc "Interactions with Workflow Executions that have been sent to the Temporal Server"

  require TemporalEngine.Data.Failure

  alias TemporalEngine.Data.Failure
  alias TemporalEngine.WorkflowHandle
  alias TemporalEngine.Data.Payload

  @spec get(WorkflowHandle.t(), opts :: keyword()) :: {:ok, term()} | {:error, term()}
  def get(handle, opts \\ []) do
    case WorkflowHandle.get_result(handle, opts) do
      {:ok, resp} ->
        {:ok, Payload.value_from_record(resp)}

      {:error,
        Failure.workflow_failed(
          failure:
            Failure.failure(
              failure_info:
                Failure.application(failure_type: "ReturnedError", details: [resp_payload])
            )
        )} ->
        {:error, Payload.value_from_record(resp_payload)}

      {:error, Failure.workflow_failed(failure: f)} ->
        {:error, Failure.to_map(f) |> Map.put(:error_code, :workflow_failed)}

      {:error, Failure.workflow_cancelled(details: details)} ->
        {:error,
          %{
            error_code: :workflow_cancelled,
            details: Enum.map(details, &Payload.value_from_record/1)
          }}

      {:error, Failure.workflow_terminated(details: details)} ->
        {:error,
          %{
            error_code: :workflow_terminated,
            details: Enum.map(details, &Payload.value_from_record/1)
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