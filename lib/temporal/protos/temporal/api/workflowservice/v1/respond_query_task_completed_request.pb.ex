defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondQueryTaskCompletedRequest do
  @moduledoc """
  Automatically generated module for RespondQueryTaskCompletedRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 8 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause` | Why did the task fail? It's important to note that many of the variants in this enum cannot |
  | 2 | **`completed_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType` |  |
  | 4 | **`error_message`** | `string` | A plain error message that must be set if completed_type is QUERY_RESULT_TYPE_FAILED. |
  | 7 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The full reason for this query failure. This field is newer than `error_message` and can be |
  | 6 | **`namespace`** | `string` |  |
  | 9 | **`poller_group_id`** | `string` | Client must forward the poller_group_id received in PollWorkflowTaskQueueResponse for proper |
  | 3 | **`query_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | The result of the query. |
  | 1 | **`task_token`** | `bytes` |  |

  ### Additional Notes

    * `cause` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause`): Why did the task fail? It's important to note that many of the variants in this enum cannot
      apply to worker responses. See the type's doc for more.
    * `error_message` (`string`): A plain error message that must be set if completed_type is QUERY_RESULT_TYPE_FAILED.
      SDKs should also fill in the more complete `failure` field to provide the full context and
      support encryption of failure information.
      `error_message` will be duplicated if the `failure` field is present to support callers
      that pre-date the addition of that field, regardless of whether or not a custom failure
      converter is used.
      Mutually exclusive with `query_result`. Set when the query fails.
    * `failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): The full reason for this query failure. This field is newer than `error_message` and can be
      encoded by the SDK's failure converter to support E2E encryption of messages and stack
      traces.
      Mutually exclusive with `query_result`. Set when the query fails.
    * `poller_group_id` (`string`): Client must forward the poller_group_id received in PollWorkflowTaskQueueResponse for proper
      routing of the response.
    * `query_result` (`Temporal.Protos.Temporal.Api.Common.V1.Payloads`): The result of the query.
      Mutually exclusive with `error_message` and `failure`. Set when the query succeeds.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"

  field :completed_type, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType,
    json_name: "completedType",
    enum: true

  field :query_result, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "queryResult"

  field :error_message, 4, type: :string, json_name: "errorMessage"
  field :namespace, 6, type: :string
  field :failure, 7, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :cause, 8, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause, enum: true
  field :poller_group_id, 9, type: :string, json_name: "pollerGroupId"
end
