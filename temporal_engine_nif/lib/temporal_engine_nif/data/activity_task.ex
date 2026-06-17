defmodule TemporalEngineNif.Data.ActivityTask do
  defstruct [
    :task_token,
    variant: nil
  ]

  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.Common

  alias TemporalEngine.Data.ActivityTask, as: EngineTask
  alias TemporalEngineNif.Data
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.Priority
  alias TemporalEngineNif.Data.RetryPolicy
  alias TemporalEngineNif.Data.Timestamp

  @type t :: %__MODULE__{task_token: [byte()], variant: Data.ActivityTaskVariant.t() | nil}

  @spec to_record(t()) :: EngineTask.activity_task()
  def to_record(%__MODULE__{task_token: token, variant: {:start, start}}) do
    activity_task(
      task_token: :binary.list_to_bin(token),
      variant:
        start_activity(
          workflow_namespace: start.workflow_namespace,
          activity_id: start.activity_id,
          activity_type: start.activity_type,
          run_id: start.run_id,
          workflow_type: start.workflow_type,
          workflow_execution:
            if(exec = start.workflow_execution,
              do: workflow_execution(workflow_id: exec.workflow_id, run_id: exec.run_id)
            ),
          header_fields: start.header_fields,
          input: Enum.map(start.input, &Payload.to_record/1),
          heartbeat_details: Enum.map(start.heartbeat_details, &Payload.to_record/1),
          scheduled_time: Timestamp.to_record(start.scheduled_time),
          current_attempt_scheduled_time:
            Timestamp.to_record(start.current_attempt_scheduled_time),
          started_time: Timestamp.to_record(start.started_time),
          attempt: start.attempt,
          schedule_to_close_timeout: Duration.to_record(start.schedule_to_close_timeout),
          start_to_close_timeout: Duration.to_record(start.start_to_close_timeout),
          heartbeat_timeout: Duration.to_record(start.heartbeat_timeout),
          retry_policy: RetryPolicy.to_record(start.retry_policy),
          priority: Priority.to_record(start.priority),
          is_local: start.is_local
        )
    )
  end

  def to_record(%__MODULE__{task_token: token, variant: {:cancel, cancel}}) do
    activity_task(
      task_token: :binary.list_to_bin(token),
      variant:
        cancel_activity(
          reason: cancel.reason,
          details:
            if(details = cancel.details,
              do:
                cancel_details(
                  is_not_found: details.is_not_found,
                  is_cancelled: details.is_cancelled,
                  is_paused: details.is_paused,
                  is_timed_out: details.is_timed_out,
                  is_worker_shutdown: details.is_worker_shutdown,
                  is_reset: details.is_reset
                )
            )
        )
    )
  end
end
