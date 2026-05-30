defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.BatchJob do
  @moduledoc """
  Link can be associated with history events. It might contain information about an external entity
  related to the history event. For example, workflow A makes a Nexus call that starts workflow B:
  in this case, a history event in workflow A could contain a Link to the workflow started event in
  workflow B, and vice-versa.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`job_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :job_id, 1, type: :string, json_name: "jobId"
end
