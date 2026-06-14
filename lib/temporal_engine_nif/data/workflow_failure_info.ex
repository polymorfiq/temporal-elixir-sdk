defmodule TemporalEngineNif.Data.WorkflowFailureInfo do
  import TemporalEngine.Data.Failure

  alias TemporalEngineNif.Data
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngine.Data.Failure, as: EngineFailure

  @type t ::
          {:application, Data.WorkflowApplicationFailureInfo.t()}
          | {:timeout, Data.WorkflowTimeoutFailureInfo.t()}
          | {:cancelled, Data.WorkflowCanceledFailureInfo.t()}
          | {:terminated, Data.WorkflowTerminatedFailureInfo.t()}
          | {:server, Data.WorkflowServerFailureInfo.t()}
          | {:reset_workflow, Data.WorkflowResetFailureInfo.t()}
          | {:activity, Data.WorkflowActivityFailureInfo.t()}
          | {:child_execution, Data.WorkflowChildExecutionFailureInfo.t()}
          | {:nexus_operation, Data.WorkflowNexusOperationFailureInfo.t()}
          | {:nexus_handler, Data.WorkflowNexusHandlerFailureInfo.t()}

  @spec to_record(t() | nil) :: EngineFailure.failure_info() | nil
  def to_record(nil), do: nil

  def to_record({:application, failure}) do
    application(
      failure_type: failure.failure_type,
      non_retryable: failure.non_retryable,
      details: Payload.to_record(failure.details),
      next_retry_delay: Duration.to_record(failure.next_retry_delay),
      category: failure.category
    )
  end

  def to_record({:timeout_reached, failure}) do
    timeout_reached(
      timeout_type: failure.timeout_type,
      last_heartbeat_details: Payload.to_record(failure.last_heartbeat_details)
    )
  end

  def to_record({:cancelled, failure}) do
    cancelled(
      identity: failure.identity,
      details: Payload.to_record(failure.details)
    )
  end

  def to_record({:terminated, failure}) do
    terminated(identity: failure.identity)
  end

  def to_record({:server, failure}) do
    server(non_retryable: failure.non_retryable)
  end

  def to_record({:reset_workflow, failure}) do
    reset_workflow(last_heartbeat_details: Payload.to_record(failure.last_heartbeat_details))
  end

  def to_record({:activity, failure}) do
    activity(
      scheduled_event_id: failure.scheduled_event_id,
      started_event_id: failure.started_event_id,
      identity: failure.identity,
      activity_type: if(a_type = failure.activity_type, do: activity_type(name: a_type.name)),
      activity_id: failure.activity_id,
      retry_state: failure.retry_state
    )
  end

  def to_record({:child_execution, failure}) do
    child_execution(
      namespace: failure.namespace,
      workflow_execution:
        if(exec = failure.workflow_execution,
          do: run(workflow_id: exec.workflow_id, run_id: exec.run_id)
        ),
      workflow_type: if(wf_type = failure.workflow_type, do: workflow_type(name: wf_type.name)),
      initiated_event_id: failure.initiated_event_id,
      started_event_id: failure.started_event_id,
      retry_state: failure.retry_state
    )
  end

  def to_record({:nexus_operation, failure}) do
    nexus_operation(
      scheduled_event_id: failure.scheduled_event_id,
      endpoint: failure.endpoint,
      service: failure.service,
      operation: failure.operation,
      operation_id: failure.operation_id,
      operation_token: failure.operation_token
    )
  end

  def to_record({:nexus_handler, failure}) do
    nexus_handler(
      failure_type: failure.failure_type,
      retry_behavior: failure.retry_behavior
    )
  end
end
