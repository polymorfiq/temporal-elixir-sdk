defmodule TemporalEngineNif.Data.WorkflowFailureInfo do
  import TemporalEngine.Data.Failure

  alias TemporalEngineNif.Data
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.WorkflowActivityType, as: ActivityType
  alias TemporalEngineNif.Data.WorkflowType
  alias TemporalEngineNif.Data.WorkflowExecution, as: Execution
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
      details: Enum.map(failure.details || [], &Payload.to_record/1),
      next_retry_delay: Duration.to_record(failure.next_retry_delay),
      category: failure.category
    )
  end

  def to_record({:timeout, failure}) do
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
      activity_type: ActivityType.to_record(failure.activity_type),
      activity_id: failure.activity_id,
      retry_state: failure.retry_state
    )
  end

  def to_record({:child_execution, failure}) do
    child_execution(
      namespace: failure.namespace,
      workflow_execution: Execution.to_record(failure.workflow_execution),
      workflow_type: WorkflowType.to_record(failure.workflow_type),
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

  @spec from_record(t() | nil) :: EngineFailure.failure_info() | nil
  def from_record(nil), do: nil

  def from_record(application() = info) do
    {:application,
     %Data.WorkflowApplicationFailureInfo{
       failure_type: application(info, :failure_type),
       non_retryable: application(info, :non_retryable),
       details: application(info, :details) |> Enum.map(fn p -> Payload.from_record(p) end),
       next_retry_delay: Duration.from_record(application(info, :next_retry_delay)),
       category: application(info, :category)
     }}
  end

  def from_record(timeout_reached() = info) do
    {:timeout,
     %Data.WorkflowTimeoutFailureInfo{
       timeout_type: timeout_reached(info, :timeout_type),
       last_heartbeat_details: Payload.from_record(timeout_reached(info, :last_heartbeat_details))
     }}
  end

  def from_record(cancelled() = info) do
    {:cancelled,
     %Data.WorkflowCanceledFailureInfo{
       identity: cancelled(info, :identity),
       details: Payload.from_record(cancelled(info, :details))
     }}
  end

  def from_record(terminated() = info) do
    {:terminated, %Data.WorkflowTerminatedFailureInfo{identity: terminated(info, :identity)}}
  end

  def from_record(server() = info) do
    {:server, %Data.WorkflowServerFailureInfo{non_retryable: server(info, :non_retryable)}}
  end

  def from_record(reset_workflow() = info) do
    {:reset_workflow,
     %Data.WorkflowResetFailureInfo{
       last_heartbeat_details: Payload.from_record(reset_workflow(info, :last_heartbeat_details))
     }}
  end

  def from_record(activity() = info) do
    {:activity,
     %Data.WorkflowActivityFailureInfo{
       scheduled_event_id: activity(info, :scheduled_event_id),
       started_event_id: activity(info, :started_event_id),
       identity: activity(info, :identity),
       activity_type: ActivityType.from_record(activity(info, :activity_type)),
       activity_id: activity(info, :activity_id),
       retry_state: activity(info, :retry_state)
     }}
  end

  def from_record(child_execution() = info) do
    {:child_execution,
     %Data.WorkflowChildExecutionFailureInfo{
       namespace: child_execution(info, :namespace),
       workflow_execution: Execution.from_record(child_execution(info, :workflow_execution)),
       workflow_type: WorkflowType.from_record(child_execution(info, :workflow_type)),
       initiated_event_id: child_execution(info, :initiated_event_id),
       started_event_id: child_execution(info, :started_event_id),
       retry_state: child_execution(info, :retry_state)
     }}
  end

  def from_record(nexus_operation() = info) do
    {:nexus_operation,
     %Data.WorkflowNexusOperationFailureInfo{
       scheduled_event_id: nexus_operation(info, :scheduled_event_id),
       endpoint: nexus_operation(info, :endpoint),
       service: nexus_operation(info, :service),
       operation: nexus_operation(info, :operation),
       operation_id: nexus_operation(info, :operation_id),
       operation_token: nexus_operation(info, :operation_token)
     }}
  end

  def from_record(nexus_handler() = info) do
    {:nexus_handler,
     %Data.WorkflowNexusHandlerFailureInfo{
       failure_type: nexus_handler(info, :failure_type),
       retry_behavior: nexus_handler(info, :retry_behavior)
     }}
  end
end
