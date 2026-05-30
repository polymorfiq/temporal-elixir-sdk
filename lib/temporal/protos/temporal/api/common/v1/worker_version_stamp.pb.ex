defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp do
  @moduledoc """
  Deprecated. This message is replaced with `Deployment` and `VersioningBehavior`.
  Identifies the version(s) of a worker that processed a task

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_id`** | `string` | An opaque whole-worker identifier. Replaces the deprecated `binary_checksum` field when this |
  | 3 | **`use_versioning`** | `bool` | If set, the worker is opting in to worker versioning. Otherwise, this is used only as a |

  ### Additional Notes

    * `build_id` (`string`): An opaque whole-worker identifier. Replaces the deprecated `binary_checksum` field when this
      message is included in requests which previously used that.
    * `use_versioning` (`bool`): If set, the worker is opting in to worker versioning. Otherwise, this is used only as a
      marker for workflow reset points and the BuildIDs search attribute.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id, 1, type: :string, json_name: "buildId"
  field :use_versioning, 3, type: :bool, json_name: "useVersioning"
end
