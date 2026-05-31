defmodule Temporal.Protos.Temporal.Api.Failure.V1.Failure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:failure_info, 0)

  field(:message, 1, type: :string)
  field(:source, 2, type: :string)
  field(:stack_trace, 3, type: :string, json_name: "stackTrace")

  field(:encoded_attributes, 20,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload,
    json_name: "encodedAttributes"
  )

  field(:cause, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)

  field(:application_failure_info, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ApplicationFailureInfo,
    json_name: "applicationFailureInfo",
    oneof: 0
  )

  field(:timeout_failure_info, 6,
    type: Temporal.Protos.Temporal.Api.Failure.V1.TimeoutFailureInfo,
    json_name: "timeoutFailureInfo",
    oneof: 0
  )

  field(:canceled_failure_info, 7,
    type: Temporal.Protos.Temporal.Api.Failure.V1.CanceledFailureInfo,
    json_name: "canceledFailureInfo",
    oneof: 0
  )

  field(:terminated_failure_info, 8,
    type: Temporal.Protos.Temporal.Api.Failure.V1.TerminatedFailureInfo,
    json_name: "terminatedFailureInfo",
    oneof: 0
  )

  field(:server_failure_info, 9,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ServerFailureInfo,
    json_name: "serverFailureInfo",
    oneof: 0
  )

  field(:reset_workflow_failure_info, 10,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ResetWorkflowFailureInfo,
    json_name: "resetWorkflowFailureInfo",
    oneof: 0
  )

  field(:activity_failure_info, 11,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ActivityFailureInfo,
    json_name: "activityFailureInfo",
    oneof: 0
  )

  field(:child_workflow_execution_failure_info, 12,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ChildWorkflowExecutionFailureInfo,
    json_name: "childWorkflowExecutionFailureInfo",
    oneof: 0
  )

  field(:nexus_operation_execution_failure_info, 13,
    type: Temporal.Protos.Temporal.Api.Failure.V1.NexusOperationFailureInfo,
    json_name: "nexusOperationExecutionFailureInfo",
    oneof: 0
  )

  field(:nexus_handler_failure_info, 14,
    type: Temporal.Protos.Temporal.Api.Failure.V1.NexusHandlerFailureInfo,
    json_name: "nexusHandlerFailureInfo",
    oneof: 0
  )
end
