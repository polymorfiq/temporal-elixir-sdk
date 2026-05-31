defmodule Temporal.Protos.Temporal.Api.Common.V1.Link do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:workflow_event, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent,
    json_name: "workflowEvent",
    oneof: 0
  )

  field(:batch_job, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.BatchJob,
    json_name: "batchJob",
    oneof: 0
  )

  field(:activity, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Link.Activity, oneof: 0)

  field(:nexus_operation, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.NexusOperation,
    json_name: "nexusOperation",
    oneof: 0
  )

  field(:workflow, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Link.Workflow, oneof: 0)
end
