defmodule Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecutions do
  @moduledoc """
  WorkflowExecutions is used by the Cloud Export feature to deserialize 
  the exported file. It encapsulates a collection of workflow execution information.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`items`** | `Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecution` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :items, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecution
end
