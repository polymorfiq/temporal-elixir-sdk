defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.QueryWorkflowRequest do
  @moduledoc """
  Automatically generated module for QueryWorkflowRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`query`** | `Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery` |  |
  | 4 | **`query_reject_condition`** | `Temporal.Protos.Temporal.Api.Enums.V1.QueryRejectCondition` | QueryRejectCondition can used to reject the query if workflow state does not satisfy condition. |

  ### Additional Notes

    * `query_reject_condition` (`Temporal.Protos.Temporal.Api.Enums.V1.QueryRejectCondition`): QueryRejectCondition can used to reject the query if workflow state does not satisfy condition.
      Default: QUERY_REJECT_CONDITION_NONE.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :query, 3, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery

  field :query_reject_condition, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryRejectCondition,
    json_name: "queryRejectCondition",
    enum: true
end
