defmodule Temporal.Protos.Temporal.Api.History.V1.HistoryEvent do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:attributes, 0)

  field(:event_id, 1, type: :int64, json_name: "eventId")
  field(:event_time, 2, type: Google.Protobuf.Timestamp, json_name: "eventTime")

  field(:event_type, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EventType,
    json_name: "eventType",
    enum: true
  )

  field(:version, 4, type: :int64)
  field(:task_id, 5, type: :int64, json_name: "taskId")
  field(:worker_may_ignore, 300, type: :bool, json_name: "workerMayIgnore")

  field(:user_metadata, 301,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:links, 302, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
  field(:principal, 303, type: Temporal.Protos.Temporal.Api.Common.V1.Principal)

  field(:workflow_execution_started_event_attributes, 6,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionStartedEventAttributes,
    json_name: "workflowExecutionStartedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_completed_event_attributes, 7,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCompletedEventAttributes,
    json_name: "workflowExecutionCompletedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_failed_event_attributes, 8,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionFailedEventAttributes,
    json_name: "workflowExecutionFailedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_timed_out_event_attributes, 9,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTimedOutEventAttributes,
    json_name: "workflowExecutionTimedOutEventAttributes",
    oneof: 0
  )

  field(:workflow_task_scheduled_event_attributes, 10,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskScheduledEventAttributes,
    json_name: "workflowTaskScheduledEventAttributes",
    oneof: 0
  )

  field(:workflow_task_started_event_attributes, 11,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskStartedEventAttributes,
    json_name: "workflowTaskStartedEventAttributes",
    oneof: 0
  )

  field(:workflow_task_completed_event_attributes, 12,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskCompletedEventAttributes,
    json_name: "workflowTaskCompletedEventAttributes",
    oneof: 0
  )

  field(:workflow_task_timed_out_event_attributes, 13,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskTimedOutEventAttributes,
    json_name: "workflowTaskTimedOutEventAttributes",
    oneof: 0
  )

  field(:workflow_task_failed_event_attributes, 14,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskFailedEventAttributes,
    json_name: "workflowTaskFailedEventAttributes",
    oneof: 0
  )

  field(:activity_task_scheduled_event_attributes, 15,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskScheduledEventAttributes,
    json_name: "activityTaskScheduledEventAttributes",
    oneof: 0
  )

  field(:activity_task_started_event_attributes, 16,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskStartedEventAttributes,
    json_name: "activityTaskStartedEventAttributes",
    oneof: 0
  )

  field(:activity_task_completed_event_attributes, 17,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCompletedEventAttributes,
    json_name: "activityTaskCompletedEventAttributes",
    oneof: 0
  )

  field(:activity_task_failed_event_attributes, 18,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskFailedEventAttributes,
    json_name: "activityTaskFailedEventAttributes",
    oneof: 0
  )

  field(:activity_task_timed_out_event_attributes, 19,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskTimedOutEventAttributes,
    json_name: "activityTaskTimedOutEventAttributes",
    oneof: 0
  )

  field(:timer_started_event_attributes, 20,
    type: Temporal.Protos.Temporal.Api.History.V1.TimerStartedEventAttributes,
    json_name: "timerStartedEventAttributes",
    oneof: 0
  )

  field(:timer_fired_event_attributes, 21,
    type: Temporal.Protos.Temporal.Api.History.V1.TimerFiredEventAttributes,
    json_name: "timerFiredEventAttributes",
    oneof: 0
  )

  field(:activity_task_cancel_requested_event_attributes, 22,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCancelRequestedEventAttributes,
    json_name: "activityTaskCancelRequestedEventAttributes",
    oneof: 0
  )

  field(:activity_task_canceled_event_attributes, 23,
    type: Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCanceledEventAttributes,
    json_name: "activityTaskCanceledEventAttributes",
    oneof: 0
  )

  field(:timer_canceled_event_attributes, 24,
    type: Temporal.Protos.Temporal.Api.History.V1.TimerCanceledEventAttributes,
    json_name: "timerCanceledEventAttributes",
    oneof: 0
  )

  field(:marker_recorded_event_attributes, 25,
    type: Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes,
    json_name: "markerRecordedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_signaled_event_attributes, 26,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionSignaledEventAttributes,
    json_name: "workflowExecutionSignaledEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_terminated_event_attributes, 27,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTerminatedEventAttributes,
    json_name: "workflowExecutionTerminatedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_cancel_requested_event_attributes, 28,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCancelRequestedEventAttributes,
    json_name: "workflowExecutionCancelRequestedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_canceled_event_attributes, 29,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCanceledEventAttributes,
    json_name: "workflowExecutionCanceledEventAttributes",
    oneof: 0
  )

  field(:request_cancel_external_workflow_execution_initiated_event_attributes, 30,
    type:
      Temporal.Protos.Temporal.Api.History.V1.RequestCancelExternalWorkflowExecutionInitiatedEventAttributes,
    json_name: "requestCancelExternalWorkflowExecutionInitiatedEventAttributes",
    oneof: 0
  )

  field(:request_cancel_external_workflow_execution_failed_event_attributes, 31,
    type:
      Temporal.Protos.Temporal.Api.History.V1.RequestCancelExternalWorkflowExecutionFailedEventAttributes,
    json_name: "requestCancelExternalWorkflowExecutionFailedEventAttributes",
    oneof: 0
  )

  field(:external_workflow_execution_cancel_requested_event_attributes, 32,
    type:
      Temporal.Protos.Temporal.Api.History.V1.ExternalWorkflowExecutionCancelRequestedEventAttributes,
    json_name: "externalWorkflowExecutionCancelRequestedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_continued_as_new_event_attributes, 33,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionContinuedAsNewEventAttributes,
    json_name: "workflowExecutionContinuedAsNewEventAttributes",
    oneof: 0
  )

  field(:start_child_workflow_execution_initiated_event_attributes, 34,
    type:
      Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionInitiatedEventAttributes,
    json_name: "startChildWorkflowExecutionInitiatedEventAttributes",
    oneof: 0
  )

  field(:start_child_workflow_execution_failed_event_attributes, 35,
    type:
      Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionFailedEventAttributes,
    json_name: "startChildWorkflowExecutionFailedEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_started_event_attributes, 36,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionStartedEventAttributes,
    json_name: "childWorkflowExecutionStartedEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_completed_event_attributes, 37,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionCompletedEventAttributes,
    json_name: "childWorkflowExecutionCompletedEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_failed_event_attributes, 38,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionFailedEventAttributes,
    json_name: "childWorkflowExecutionFailedEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_canceled_event_attributes, 39,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionCanceledEventAttributes,
    json_name: "childWorkflowExecutionCanceledEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_timed_out_event_attributes, 40,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionTimedOutEventAttributes,
    json_name: "childWorkflowExecutionTimedOutEventAttributes",
    oneof: 0
  )

  field(:child_workflow_execution_terminated_event_attributes, 41,
    type: Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionTerminatedEventAttributes,
    json_name: "childWorkflowExecutionTerminatedEventAttributes",
    oneof: 0
  )

  field(:signal_external_workflow_execution_initiated_event_attributes, 42,
    type:
      Temporal.Protos.Temporal.Api.History.V1.SignalExternalWorkflowExecutionInitiatedEventAttributes,
    json_name: "signalExternalWorkflowExecutionInitiatedEventAttributes",
    oneof: 0
  )

  field(:signal_external_workflow_execution_failed_event_attributes, 43,
    type:
      Temporal.Protos.Temporal.Api.History.V1.SignalExternalWorkflowExecutionFailedEventAttributes,
    json_name: "signalExternalWorkflowExecutionFailedEventAttributes",
    oneof: 0
  )

  field(:external_workflow_execution_signaled_event_attributes, 44,
    type:
      Temporal.Protos.Temporal.Api.History.V1.ExternalWorkflowExecutionSignaledEventAttributes,
    json_name: "externalWorkflowExecutionSignaledEventAttributes",
    oneof: 0
  )

  field(:upsert_workflow_search_attributes_event_attributes, 45,
    type: Temporal.Protos.Temporal.Api.History.V1.UpsertWorkflowSearchAttributesEventAttributes,
    json_name: "upsertWorkflowSearchAttributesEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_update_accepted_event_attributes, 46,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAcceptedEventAttributes,
    json_name: "workflowExecutionUpdateAcceptedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_update_rejected_event_attributes, 47,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateRejectedEventAttributes,
    json_name: "workflowExecutionUpdateRejectedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_update_completed_event_attributes, 48,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateCompletedEventAttributes,
    json_name: "workflowExecutionUpdateCompletedEventAttributes",
    oneof: 0
  )

  field(:workflow_properties_modified_externally_event_attributes, 49,
    type:
      Temporal.Protos.Temporal.Api.History.V1.WorkflowPropertiesModifiedExternallyEventAttributes,
    json_name: "workflowPropertiesModifiedExternallyEventAttributes",
    oneof: 0
  )

  field(:activity_properties_modified_externally_event_attributes, 50,
    type:
      Temporal.Protos.Temporal.Api.History.V1.ActivityPropertiesModifiedExternallyEventAttributes,
    json_name: "activityPropertiesModifiedExternallyEventAttributes",
    oneof: 0
  )

  field(:workflow_properties_modified_event_attributes, 51,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowPropertiesModifiedEventAttributes,
    json_name: "workflowPropertiesModifiedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_update_admitted_event_attributes, 52,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUpdateAdmittedEventAttributes,
    json_name: "workflowExecutionUpdateAdmittedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_scheduled_event_attributes, 53,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationScheduledEventAttributes,
    json_name: "nexusOperationScheduledEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_started_event_attributes, 54,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationStartedEventAttributes,
    json_name: "nexusOperationStartedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_completed_event_attributes, 55,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationCompletedEventAttributes,
    json_name: "nexusOperationCompletedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_failed_event_attributes, 56,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationFailedEventAttributes,
    json_name: "nexusOperationFailedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_canceled_event_attributes, 57,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationCanceledEventAttributes,
    json_name: "nexusOperationCanceledEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_timed_out_event_attributes, 58,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationTimedOutEventAttributes,
    json_name: "nexusOperationTimedOutEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_cancel_requested_event_attributes, 59,
    type: Temporal.Protos.Temporal.Api.History.V1.NexusOperationCancelRequestedEventAttributes,
    json_name: "nexusOperationCancelRequestedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_options_updated_event_attributes, 60,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionOptionsUpdatedEventAttributes,
    json_name: "workflowExecutionOptionsUpdatedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_cancel_request_completed_event_attributes, 61,
    type:
      Temporal.Protos.Temporal.Api.History.V1.NexusOperationCancelRequestCompletedEventAttributes,
    json_name: "nexusOperationCancelRequestCompletedEventAttributes",
    oneof: 0
  )

  field(:nexus_operation_cancel_request_failed_event_attributes, 62,
    type:
      Temporal.Protos.Temporal.Api.History.V1.NexusOperationCancelRequestFailedEventAttributes,
    json_name: "nexusOperationCancelRequestFailedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_paused_event_attributes, 63,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionPausedEventAttributes,
    json_name: "workflowExecutionPausedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_unpaused_event_attributes, 64,
    type: Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUnpausedEventAttributes,
    json_name: "workflowExecutionUnpausedEventAttributes",
    oneof: 0
  )

  field(:workflow_execution_time_skipping_transitioned_event_attributes, 65,
    type:
      Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTimeSkippingTransitionedEventAttributes,
    json_name: "workflowExecutionTimeSkippingTransitionedEventAttributes",
    oneof: 0
  )
end
