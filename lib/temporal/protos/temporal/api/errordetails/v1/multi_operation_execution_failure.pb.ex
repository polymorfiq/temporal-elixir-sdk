defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure do
  @moduledoc """
  Automatically generated module for MultiOperationExecutionFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`statuses`** | `Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure.OperationStatus` | One status for each requested operation from the failed MultiOperation. The failed |

  ### Additional Notes

    * `statuses` (`Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure.OperationStatus`): One status for each requested operation from the failed MultiOperation. The failed
      operation(s) have the same error details as if it was executed separately. All other operations have the
      status code `Aborted` and `MultiOperationExecutionAborted` is added to the details field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :statuses, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure.OperationStatus
end
