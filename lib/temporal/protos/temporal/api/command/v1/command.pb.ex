defmodule Temporal.Protos.Temporal.Api.Command.V1.Command do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:attributes, 0)

  field(:command_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.CommandType,
    json_name: "commandType",
    enum: true
  )

  field(:user_metadata, 301,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )

  field(:schedule_activity_task_command_attributes, 2,
    type: Temporal.Protos.Temporal.Api.Command.V1.ScheduleActivityTaskCommandAttributes,
    json_name: "scheduleActivityTaskCommandAttributes",
    oneof: 0
  )

  field(:start_timer_command_attributes, 3,
    type: Temporal.Protos.Temporal.Api.Command.V1.StartTimerCommandAttributes,
    json_name: "startTimerCommandAttributes",
    oneof: 0
  )

  field(:complete_workflow_execution_command_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Command.V1.CompleteWorkflowExecutionCommandAttributes,
    json_name: "completeWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:fail_workflow_execution_command_attributes, 5,
    type: Temporal.Protos.Temporal.Api.Command.V1.FailWorkflowExecutionCommandAttributes,
    json_name: "failWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:request_cancel_activity_task_command_attributes, 6,
    type: Temporal.Protos.Temporal.Api.Command.V1.RequestCancelActivityTaskCommandAttributes,
    json_name: "requestCancelActivityTaskCommandAttributes",
    oneof: 0
  )

  field(:cancel_timer_command_attributes, 7,
    type: Temporal.Protos.Temporal.Api.Command.V1.CancelTimerCommandAttributes,
    json_name: "cancelTimerCommandAttributes",
    oneof: 0
  )

  field(:cancel_workflow_execution_command_attributes, 8,
    type: Temporal.Protos.Temporal.Api.Command.V1.CancelWorkflowExecutionCommandAttributes,
    json_name: "cancelWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:request_cancel_external_workflow_execution_command_attributes, 9,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.RequestCancelExternalWorkflowExecutionCommandAttributes,
    json_name: "requestCancelExternalWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:record_marker_command_attributes, 10,
    type: Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes,
    json_name: "recordMarkerCommandAttributes",
    oneof: 0
  )

  field(:continue_as_new_workflow_execution_command_attributes, 11,
    type: Temporal.Protos.Temporal.Api.Command.V1.ContinueAsNewWorkflowExecutionCommandAttributes,
    json_name: "continueAsNewWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:start_child_workflow_execution_command_attributes, 12,
    type: Temporal.Protos.Temporal.Api.Command.V1.StartChildWorkflowExecutionCommandAttributes,
    json_name: "startChildWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:signal_external_workflow_execution_command_attributes, 13,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.SignalExternalWorkflowExecutionCommandAttributes,
    json_name: "signalExternalWorkflowExecutionCommandAttributes",
    oneof: 0
  )

  field(:upsert_workflow_search_attributes_command_attributes, 14,
    type: Temporal.Protos.Temporal.Api.Command.V1.UpsertWorkflowSearchAttributesCommandAttributes,
    json_name: "upsertWorkflowSearchAttributesCommandAttributes",
    oneof: 0
  )

  field(:protocol_message_command_attributes, 15,
    type: Temporal.Protos.Temporal.Api.Command.V1.ProtocolMessageCommandAttributes,
    json_name: "protocolMessageCommandAttributes",
    oneof: 0
  )

  field(:modify_workflow_properties_command_attributes, 17,
    type: Temporal.Protos.Temporal.Api.Command.V1.ModifyWorkflowPropertiesCommandAttributes,
    json_name: "modifyWorkflowPropertiesCommandAttributes",
    oneof: 0
  )

  field(:schedule_nexus_operation_command_attributes, 18,
    type: Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes,
    json_name: "scheduleNexusOperationCommandAttributes",
    oneof: 0
  )

  field(:request_cancel_nexus_operation_command_attributes, 19,
    type: Temporal.Protos.Temporal.Api.Command.V1.RequestCancelNexusOperationCommandAttributes,
    json_name: "requestCancelNexusOperationCommandAttributes",
    oneof: 0
  )
end
