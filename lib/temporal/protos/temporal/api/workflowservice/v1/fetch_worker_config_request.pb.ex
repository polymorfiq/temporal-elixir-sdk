defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigRequest do
  @moduledoc """
  Automatically generated module for FetchWorkerConfigRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | Namespace this worker belongs to. |
  | 3 | **`reason`** | `string` | Reason for sending worker command, can be used for audit purpose. |
  | 7 | **`resource_id`** | `string` | Resource ID for routing. Contains the worker grouping key. |
  | 6 | **`selector`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector` | Defines which workers should receive this command. |

  ### Additional Notes

    * `selector` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector`): Defines which workers should receive this command.
      only single worker is supported at this time.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string
  field :reason, 3, type: :string
  field :selector, 6, type: Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector
  field :resource_id, 7, type: :string, json_name: "resourceId"
end
