defmodule Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:NEXUS_OPERATION_EXECUTION_STATUS_UNSPECIFIED, 0)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_RUNNING, 1)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_COMPLETED, 2)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_FAILED, 3)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_CANCELED, 4)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_TERMINATED, 5)
  field(:NEXUS_OPERATION_EXECUTION_STATUS_TIMED_OUT, 6)
end
