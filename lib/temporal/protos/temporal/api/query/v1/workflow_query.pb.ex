defmodule Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery do
  @moduledoc """
  See https://docs.temporal.io/docs/concepts/queries/

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that were passed by the caller of the query and copied by temporal |
  | 2 | **`query_args`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments that will be provided to the query handler. |
  | 1 | **`query_type`** | `string` | The workflow-author-defined identifier of the query. Typically a function name. |

  ### Additional Notes

    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that were passed by the caller of the query and copied by temporal
      server into the workflow task.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :query_type, 1, type: :string, json_name: "queryType"

  field :query_args, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "queryArgs"

  field :header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header
end
