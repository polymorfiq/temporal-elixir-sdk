defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection do
  @moduledoc """
  Used for specifying versions the caller is interested in.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`all_active`** | `bool` | Include all active versions. A version is considered active if, in the last few minutes, |
  | 1 | **`build_ids`** | `string` | Include specific Build IDs. |
  | 2 | **`unversioned`** | `bool` | Include the unversioned queue. |

  ### Additional Notes

    * `all_active` (`bool`): Include all active versions. A version is considered active if, in the last few minutes,
      it has had new tasks or polls, or it has been the subject of certain task queue API calls.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_ids, 1, repeated: true, type: :string, json_name: "buildIds"
  field :unversioned, 2, type: :bool
  field :all_active, 3, type: :bool, json_name: "allActive"
end
