defmodule TemporalSamples.Workflows.ErrorsRaised do
  use Temporal.Workflow

  @doc "Workflow that raises an exception"
  def exception_workflow(_ctx) do
    raise "Crash the workflow before it finishes"
    {:ok, "Finished!"}
  end

  @doc "Workflow that returns a string error"
  def error_workflow(_ctx) do
    {:error, "Error returned from function"}
  end

  @doc "Workflow that returns an error with specific info"
  def error_with_info_workflow(_ctx) do
    require TemporalEngine.Data.Failure
    alias TemporalEngine.Data.Failure

    {:error,
     Failure.application_from_opts!(
       failure_type: "MyExpectedType",
       non_retryable: true,
       next_retry_delay: [seconds: 10]
     )
     |> Failure.application(details: [TemporalEngine.Data.Payload.record_from_value("Some Info")])}
  end
end
