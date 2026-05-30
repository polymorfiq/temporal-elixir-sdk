defmodule Temporal.Protos.Temporal.Api.Command.V1.Command do
  @moduledoc """
  Automatically generated module for Command

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`cancel_timer_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.CancelTimerCommandAttributes` |  |
  | 8 | **`cancel_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.CancelWorkflowExecutionCommandAttributes` |  |
  | 1 | **`command_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.CommandType` |  |
  | 4 | **`complete_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.CompleteWorkflowExecutionCommandAttributes` |  |
  | 11 | **`continue_as_new_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.ContinueAsNewWorkflowExecutionCommandAttributes` |  |
  | 5 | **`fail_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.FailWorkflowExecutionCommandAttributes` |  |
  | 17 | **`modify_workflow_properties_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.ModifyWorkflowPropertiesCommandAttributes` | 16 is available for use - it was used as part of a prototype that never made it into a release |
  | 15 | **`protocol_message_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.ProtocolMessageCommandAttributes` |  |
  | 10 | **`record_marker_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes` |  |
  | 6 | **`request_cancel_activity_task_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.RequestCancelActivityTaskCommandAttributes` |  |
  | 9 | **`request_cancel_external_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.RequestCancelExternalWorkflowExecutionCommandAttributes` |  |
  | 19 | **`request_cancel_nexus_operation_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.RequestCancelNexusOperationCommandAttributes` |  |
  | 2 | **`schedule_activity_task_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.ScheduleActivityTaskCommandAttributes` |  |
  | 18 | **`schedule_nexus_operation_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes` |  |
  | 13 | **`signal_external_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.SignalExternalWorkflowExecutionCommandAttributes` |  |
  | 12 | **`start_child_workflow_execution_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.StartChildWorkflowExecutionCommandAttributes` |  |
  | 3 | **`start_timer_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.StartTimerCommandAttributes` |  |
  | 14 | **`upsert_workflow_search_attributes_command_attributes`** | `Temporal.Protos.Temporal.Api.Command.V1.UpsertWorkflowSearchAttributesCommandAttributes` |  |
  | 301 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata on the command. This is sometimes carried over to the history event if one is |

  ### Additional Notes

    * `user_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata`): Metadata on the command. This is sometimes carried over to the history event if one is
      created as a result of the command. Most commands won't have this information, and how this
      information is used is dependent upon the interface that reads it.

      Current well-known uses:
       * start_child_workflow_execution_command_attributes - populates
         temporal.api.workflow.v1.WorkflowExecutionInfo.user_metadata where the summary and details
         are used by user interfaces to show fixed as-of-start workflow summary and details.
       * start_timer_command_attributes - populates temporal.api.history.v1.HistoryEvent for timer
         started where the summary is used to identify the timer.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :attributes, 0

  field :command_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.CommandType,
    json_name: "commandType",
    enum: true

  field :user_metadata, 301,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :schedule_activity_task_command_attributes, 2,
    type: Temporal.Protos.Temporal.Api.Command.V1.ScheduleActivityTaskCommandAttributes,
    json_name: "scheduleActivityTaskCommandAttributes",
    oneof: 0

  field :start_timer_command_attributes, 3,
    type: Temporal.Protos.Temporal.Api.Command.V1.StartTimerCommandAttributes,
    json_name: "startTimerCommandAttributes",
    oneof: 0

  field :complete_workflow_execution_command_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Command.V1.CompleteWorkflowExecutionCommandAttributes,
    json_name: "completeWorkflowExecutionCommandAttributes",
    oneof: 0

  field :fail_workflow_execution_command_attributes, 5,
    type: Temporal.Protos.Temporal.Api.Command.V1.FailWorkflowExecutionCommandAttributes,
    json_name: "failWorkflowExecutionCommandAttributes",
    oneof: 0

  field :request_cancel_activity_task_command_attributes, 6,
    type: Temporal.Protos.Temporal.Api.Command.V1.RequestCancelActivityTaskCommandAttributes,
    json_name: "requestCancelActivityTaskCommandAttributes",
    oneof: 0

  field :cancel_timer_command_attributes, 7,
    type: Temporal.Protos.Temporal.Api.Command.V1.CancelTimerCommandAttributes,
    json_name: "cancelTimerCommandAttributes",
    oneof: 0

  field :cancel_workflow_execution_command_attributes, 8,
    type: Temporal.Protos.Temporal.Api.Command.V1.CancelWorkflowExecutionCommandAttributes,
    json_name: "cancelWorkflowExecutionCommandAttributes",
    oneof: 0

  field :request_cancel_external_workflow_execution_command_attributes, 9,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.RequestCancelExternalWorkflowExecutionCommandAttributes,
    json_name: "requestCancelExternalWorkflowExecutionCommandAttributes",
    oneof: 0

  field :record_marker_command_attributes, 10,
    type: Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes,
    json_name: "recordMarkerCommandAttributes",
    oneof: 0

  field :continue_as_new_workflow_execution_command_attributes, 11,
    type: Temporal.Protos.Temporal.Api.Command.V1.ContinueAsNewWorkflowExecutionCommandAttributes,
    json_name: "continueAsNewWorkflowExecutionCommandAttributes",
    oneof: 0

  field :start_child_workflow_execution_command_attributes, 12,
    type: Temporal.Protos.Temporal.Api.Command.V1.StartChildWorkflowExecutionCommandAttributes,
    json_name: "startChildWorkflowExecutionCommandAttributes",
    oneof: 0

  field :signal_external_workflow_execution_command_attributes, 13,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.SignalExternalWorkflowExecutionCommandAttributes,
    json_name: "signalExternalWorkflowExecutionCommandAttributes",
    oneof: 0

  field :upsert_workflow_search_attributes_command_attributes, 14,
    type: Temporal.Protos.Temporal.Api.Command.V1.UpsertWorkflowSearchAttributesCommandAttributes,
    json_name: "upsertWorkflowSearchAttributesCommandAttributes",
    oneof: 0

  field :protocol_message_command_attributes, 15,
    type: Temporal.Protos.Temporal.Api.Command.V1.ProtocolMessageCommandAttributes,
    json_name: "protocolMessageCommandAttributes",
    oneof: 0

  field :modify_workflow_properties_command_attributes, 17,
    type: Temporal.Protos.Temporal.Api.Command.V1.ModifyWorkflowPropertiesCommandAttributes,
    json_name: "modifyWorkflowPropertiesCommandAttributes",
    oneof: 0

  field :schedule_nexus_operation_command_attributes, 18,
    type: Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes,
    json_name: "scheduleNexusOperationCommandAttributes",
    oneof: 0

  field :request_cancel_nexus_operation_command_attributes, 19,
    type: Temporal.Protos.Temporal.Api.Command.V1.RequestCancelNexusOperationCommandAttributes,
    json_name: "requestCancelNexusOperationCommandAttributes",
    oneof: 0
end
