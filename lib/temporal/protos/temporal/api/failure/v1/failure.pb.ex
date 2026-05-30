defmodule Temporal.Protos.Temporal.Api.Failure.V1.Failure do
  @moduledoc """
  Automatically generated module for Failure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 11 | **`activity_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.ActivityFailureInfo` |  |
  | 5 | **`application_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.ApplicationFailureInfo` |  |
  | 7 | **`canceled_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.CanceledFailureInfo` |  |
  | 4 | **`cause`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |
  | 12 | **`child_workflow_execution_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.ChildWorkflowExecutionFailureInfo` |  |
  | 20 | **`encoded_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Alternative way to supply `message` and `stack_trace` and possibly other attributes, used for encryption of |
  | 1 | **`message`** | `string` |  |
  | 14 | **`nexus_handler_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.NexusHandlerFailureInfo` |  |
  | 13 | **`nexus_operation_execution_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.NexusOperationFailureInfo` |  |
  | 10 | **`reset_workflow_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.ResetWorkflowFailureInfo` |  |
  | 9 | **`server_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.ServerFailureInfo` |  |
  | 2 | **`source`** | `string` | The source this Failure originated in, e.g. TypeScriptSDK / JavaSDK |
  | 3 | **`stack_trace`** | `string` |  |
  | 8 | **`terminated_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.TerminatedFailureInfo` |  |
  | 6 | **`timeout_failure_info`** | `Temporal.Protos.Temporal.Api.Failure.V1.TimeoutFailureInfo` |  |

  ### Additional Notes

    * `encoded_attributes` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Alternative way to supply `message` and `stack_trace` and possibly other attributes, used for encryption of
      errors originating in user code which might contain sensitive information.
      The `encoded_attributes` Payload could represent any serializable object, e.g. JSON object or a `Failure` proto
      message.

      SDK authors:
      - The SDK should provide a default `encodeFailureAttributes` and `decodeFailureAttributes` implementation that:
        - Uses a JSON object to represent `{ message, stack_trace }`.
        - Overwrites the original message with "Encoded failure" to indicate that more information could be extracted.
        - Overwrites the original stack_trace with an empty string.
        - The resulting JSON object is converted to Payload using the default PayloadConverter and should be processed
          by the user-provided PayloadCodec

      - If there's demand, we could allow overriding the default SDK implementation to encode other opaque Failure attributes.
      (-- api-linter: core::0203::optional=disabled --)
    * `source` (`string`): The source this Failure originated in, e.g. TypeScriptSDK / JavaSDK
      In some SDKs this is used to rehydrate the stack trace into an exception object.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :failure_info, 0

  field :message, 1, type: :string
  field :source, 2, type: :string
  field :stack_trace, 3, type: :string, json_name: "stackTrace"

  field :encoded_attributes, 20,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload,
    json_name: "encodedAttributes"

  field :cause, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure

  field :application_failure_info, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ApplicationFailureInfo,
    json_name: "applicationFailureInfo",
    oneof: 0

  field :timeout_failure_info, 6,
    type: Temporal.Protos.Temporal.Api.Failure.V1.TimeoutFailureInfo,
    json_name: "timeoutFailureInfo",
    oneof: 0

  field :canceled_failure_info, 7,
    type: Temporal.Protos.Temporal.Api.Failure.V1.CanceledFailureInfo,
    json_name: "canceledFailureInfo",
    oneof: 0

  field :terminated_failure_info, 8,
    type: Temporal.Protos.Temporal.Api.Failure.V1.TerminatedFailureInfo,
    json_name: "terminatedFailureInfo",
    oneof: 0

  field :server_failure_info, 9,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ServerFailureInfo,
    json_name: "serverFailureInfo",
    oneof: 0

  field :reset_workflow_failure_info, 10,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ResetWorkflowFailureInfo,
    json_name: "resetWorkflowFailureInfo",
    oneof: 0

  field :activity_failure_info, 11,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ActivityFailureInfo,
    json_name: "activityFailureInfo",
    oneof: 0

  field :child_workflow_execution_failure_info, 12,
    type: Temporal.Protos.Temporal.Api.Failure.V1.ChildWorkflowExecutionFailureInfo,
    json_name: "childWorkflowExecutionFailureInfo",
    oneof: 0

  field :nexus_operation_execution_failure_info, 13,
    type: Temporal.Protos.Temporal.Api.Failure.V1.NexusOperationFailureInfo,
    json_name: "nexusOperationExecutionFailureInfo",
    oneof: 0

  field :nexus_handler_failure_info, 14,
    type: Temporal.Protos.Temporal.Api.Failure.V1.NexusHandlerFailureInfo,
    json_name: "nexusHandlerFailureInfo",
    oneof: 0
end
