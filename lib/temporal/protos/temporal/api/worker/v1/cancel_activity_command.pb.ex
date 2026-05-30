defmodule Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityCommand do
  @moduledoc """
  Cancel an activity if it is still running. Otherwise, do nothing.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`task_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"
end
