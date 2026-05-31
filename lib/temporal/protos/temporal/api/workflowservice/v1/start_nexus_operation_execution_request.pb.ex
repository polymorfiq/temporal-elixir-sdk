defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
  field(:operation_id, 4, type: :string, json_name: "operationId")
  field(:endpoint, 5, type: :string)
  field(:service, 6, type: :string)
  field(:operation, 7, type: :string)

  field(:schedule_to_close_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:schedule_to_start_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 10,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:input, 11, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)

  field(:id_reuse_policy, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationIdReusePolicy,
    json_name: "idReusePolicy",
    enum: true
  )

  field(:id_conflict_policy, 13,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationIdConflictPolicy,
    json_name: "idConflictPolicy",
    enum: true
  )

  field(:search_attributes, 14,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:nexus_header, 15,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionRequest.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true
  )

  field(:user_metadata, 16,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"
  )
end
