defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TimestampedBuildIdAssignmentRule do
  @moduledoc """
  Automatically generated module for TimestampedBuildIdAssignmentRule

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`rule`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule, 1, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule
  field :create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime"
end
