defmodule Temporal.Protos.Temporal.Api.Command.V1.CancelTimerCommandAttributes do
  @moduledoc """
  Automatically generated module for CancelTimerCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`timer_id`** | `string` | The same timer id from the start timer command |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :timer_id, 1, type: :string, json_name: "timerId"
end
