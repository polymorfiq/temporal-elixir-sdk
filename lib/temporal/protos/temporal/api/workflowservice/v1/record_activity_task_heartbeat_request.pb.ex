defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatRequest do
  @moduledoc """
  Automatically generated module for RecordActivityTaskHeartbeatRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Arbitrary data, of which the most recent call is kept, to store for this activity |
  | 3 | **`identity`** | `string` | The identity of the worker/client |
  | 4 | **`namespace`** | `string` |  |
  | 5 | **`resource_id`** | `string` | Resource ID for routing. Contains the workflow ID or activity ID for standalone activities. |
  | 1 | **`task_token`** | `bytes` | The task token as received in `PollActivityTaskQueueResponse` |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 3, type: :string
  field :namespace, 4, type: :string
  field :resource_id, 5, type: :string, json_name: "resourceId"
end
