defmodule Temporal.Protos.Temporal.Api.Command.V1.ModifyWorkflowPropertiesCommandAttributes do
  @moduledoc """
  Automatically generated module for ModifyWorkflowPropertiesCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`upserted_memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | If set, update the workflow memo with the provided values. The values will be merged with |

  ### Additional Notes

    * `upserted_memo` (`Temporal.Protos.Temporal.Api.Common.V1.Memo`): If set, update the workflow memo with the provided values. The values will be merged with
      the existing memo. If the user wants to delete values, a default/empty Payload should be
      used as the value for the key being deleted.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :upserted_memo, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.Memo,
    json_name: "upsertedMemo"
end
