defmodule Temporal.Protos.Temporal.Api.Update.V1.Request do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:meta, 1, type: Temporal.Protos.Temporal.Api.Update.V1.Meta)
  field(:input, 2, type: Temporal.Protos.Temporal.Api.Update.V1.Input)
  field(:request_id, 3, type: :string, json_name: "requestId")

  field(:completion_callbacks, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"
  )

  field(:links, 5, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
