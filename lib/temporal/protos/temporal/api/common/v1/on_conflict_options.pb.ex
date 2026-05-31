defmodule Temporal.Protos.Temporal.Api.Common.V1.OnConflictOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:attach_request_id, 1, type: :bool, json_name: "attachRequestId")
  field(:attach_completion_callbacks, 2, type: :bool, json_name: "attachCompletionCallbacks")
  field(:attach_links, 3, type: :bool, json_name: "attachLinks")
end
