defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountActivityExecutionsResponse.AggregationGroup do
  @moduledoc """
  Automatically generated module for AggregationGroup

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`count`** | `int64` | Contains the groups if the request is grouping by a field. |
  | 1 | **`group_values`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | If `query` is not grouping by any field, the count is an approximate number |

  ### Additional Notes

    * `count` (`int64`): Contains the groups if the request is grouping by a field.
      The list might not be complete, and the counts of each group is approximate.
    * `group_values` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): If `query` is not grouping by any field, the count is an approximate number
      of activities that match the query.
      If `query` is grouping by a field, the count is simply the sum of the counts
      of the groups returned in the response. This number can be smaller than the
      total number of activities matching the query.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :group_values, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload,
    json_name: "groupValues"

  field :count, 2, type: :int64
end
