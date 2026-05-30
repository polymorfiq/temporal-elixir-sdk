defmodule Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata do
  @moduledoc """
  Information a user can set, often for use by user interfaces.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Long-form text that provides details. This payload should be a "json/plain"-encoded payload |
  | 1 | **`summary`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Short-form text that provides a summary. This payload should be a "json/plain"-encoded payload |

  ### Additional Notes

    * `details` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Long-form text that provides details. This payload should be a "json/plain"-encoded payload
      that is a single JSON string for use in user interfaces. User interface formatting may apply to
      this text in common use. The payload data section is limited to 20000 bytes by default.
    * `summary` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Short-form text that provides a summary. This payload should be a "json/plain"-encoded payload
      that is a single JSON string for use in user interfaces. User interface formatting may not
      apply to this text when used in "title" situations. The payload data section is limited to 400
      bytes by default.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :summary, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
