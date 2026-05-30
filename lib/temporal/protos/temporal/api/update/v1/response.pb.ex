defmodule Temporal.Protos.Temporal.Api.Update.V1.Response do
  @moduledoc """
  An Update protocol message indicating that a Workflow Update has
  completed with the contained outcome.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`meta`** | `Temporal.Protos.Temporal.Api.Update.V1.Meta` |  |
  | 2 | **`outcome`** | `Temporal.Protos.Temporal.Api.Update.V1.Outcome` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :meta, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Meta
  field :outcome, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Outcome
end
