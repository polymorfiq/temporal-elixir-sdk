defmodule Temporal.Protos.Temporal.Api.Enums.V1.StartChildWorkflowExecutionFailedCause do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:START_CHILD_WORKFLOW_EXECUTION_FAILED_CAUSE_UNSPECIFIED, 0)
  field(:START_CHILD_WORKFLOW_EXECUTION_FAILED_CAUSE_WORKFLOW_ALREADY_EXISTS, 1)
  field(:START_CHILD_WORKFLOW_EXECUTION_FAILED_CAUSE_NAMESPACE_NOT_FOUND, 2)
end
