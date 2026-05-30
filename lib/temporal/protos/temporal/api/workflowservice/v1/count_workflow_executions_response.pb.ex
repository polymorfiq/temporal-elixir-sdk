defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsResponse do
  @moduledoc """
  Automatically generated module for CountWorkflowExecutionsResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`count`** | `int64` | If `query` is not grouping by any field, the count is an approximate number |
  | 2 | **`groups`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsResponse.AggregationGroup` | `groups` contains the groups if the request is grouping by a field. |

  ### Additional Notes

    * `count` (`int64`): If `query` is not grouping by any field, the count is an approximate number
      of workflows that matches the query.
      If `query` is grouping by a field, the count is simply the sum of the counts
      of the groups returned in the response. This number can be smaller than the
      total number of workflows matching the query.
    * `groups` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsResponse.AggregationGroup`): `groups` contains the groups if the request is grouping by a field.
      The list might not be complete, and the counts of each group is approximate.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :count, 1, type: :int64

  field :groups, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsResponse.AggregationGroup
end
