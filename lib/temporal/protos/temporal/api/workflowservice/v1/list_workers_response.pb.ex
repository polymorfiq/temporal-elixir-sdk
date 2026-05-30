defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkersResponse do
  @moduledoc """
  Automatically generated module for ListWorkersResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`next_page_token`** | `bytes` | Next page token |
  | 3 | **`workers`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerListInfo` | Limited worker information. |
  | 1 | **`workers_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo` | Deprecated: Use workers instead. This field returns full WorkerInfo which |

  ### Additional Notes

    * `workers_info` (`Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo`): Deprecated: Use workers instead. This field returns full WorkerInfo which
      includes expensive runtime metrics. We will stop populating this field in the future.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workers_info, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerInfo,
    json_name: "workersInfo",
    deprecated: true

  field :workers, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerListInfo
  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
end
