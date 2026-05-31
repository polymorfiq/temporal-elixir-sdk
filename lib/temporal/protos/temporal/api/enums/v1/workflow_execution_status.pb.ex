defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKFLOW_EXECUTION_STATUS_UNSPECIFIED, 0)
  field(:WORKFLOW_EXECUTION_STATUS_RUNNING, 1)
  field(:WORKFLOW_EXECUTION_STATUS_COMPLETED, 2)
  field(:WORKFLOW_EXECUTION_STATUS_FAILED, 3)
  field(:WORKFLOW_EXECUTION_STATUS_CANCELED, 4)
  field(:WORKFLOW_EXECUTION_STATUS_TERMINATED, 5)
  field(:WORKFLOW_EXECUTION_STATUS_CONTINUED_AS_NEW, 6)
  field(:WORKFLOW_EXECUTION_STATUS_TIMED_OUT, 7)
  field(:WORKFLOW_EXECUTION_STATUS_PAUSED, 8)
end
