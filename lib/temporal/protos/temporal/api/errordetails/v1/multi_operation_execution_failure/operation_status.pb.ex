defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure.OperationStatus do
  @moduledoc """
  Automatically generated module for OperationStatus

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`code`** | `int32` | One status for each requested operation from the failed MultiOperation. The failed |
  | 3 | **`details`** | `Google.Protobuf.Any` |  |
  | 2 | **`message`** | `string` |  |

  ### Additional Notes

    * `code` (`int32`): One status for each requested operation from the failed MultiOperation. The failed
      operation(s) have the same error details as if it was executed separately. All other operations have the
      status code `Aborted` and `MultiOperationExecutionAborted` is added to the details field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :code, 1, type: :int32
  field :message, 2, type: :string
  field :details, 3, repeated: true, type: Google.Protobuf.Any
end
