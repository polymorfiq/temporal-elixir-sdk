defmodule Temporal.Protos.Temporal.Api.Query.V1.WorkflowQueryResult do
  @moduledoc """
  Answer to a `WorkflowQuery`

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`answer`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Set when the query succeeds with the results. |
  | 3 | **`error_message`** | `string` | Mutually exclusive with `answer`. Set when the query fails. |
  | 4 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The full reason for this query failure. This field is newer than `error_message` and can be encoded by the SDK's |
  | 1 | **`result_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType` | Did the query succeed or fail? |

  ### Additional Notes

    * `answer` (`Temporal.Protos.Temporal.Api.Common.V1.Payloads`): Set when the query succeeds with the results.
      Mutually exclusive with `error_message` and `failure`.
    * `error_message` (`string`): Mutually exclusive with `answer`. Set when the query fails.
      See also the newer `failure` field.
    * `failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): The full reason for this query failure. This field is newer than `error_message` and can be encoded by the SDK's
      failure converter to support E2E encryption of messages and stack traces.
      Mutually exclusive with `answer`. Set when the query fails.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :result_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryResultType,
    json_name: "resultType",
    enum: true

  field :answer, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :error_message, 3, type: :string, json_name: "errorMessage"
  field :failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
end
