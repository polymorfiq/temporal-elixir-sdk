defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit,
    json_name: "rateLimit"
  )

  field(:reason, 2, type: :string)
end
