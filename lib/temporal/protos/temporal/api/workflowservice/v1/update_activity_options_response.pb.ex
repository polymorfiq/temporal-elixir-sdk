defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateActivityOptionsResponse do
  @moduledoc """
  Deprecated. Use `UpdateActivityExecutionOptionsResponse`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_options`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions` | Activity options after an update |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :activity_options, 1,
    type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions,
    json_name: "activityOptions"
end
