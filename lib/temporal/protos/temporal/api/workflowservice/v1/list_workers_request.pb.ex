defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkersRequest do
  @moduledoc """
  Automatically generated module for ListWorkersRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`include_system_workers`** | `bool` | When true, the response will include system workers that are created implicitly |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`next_page_token`** | `bytes` |  |
  | 2 | **`page_size`** | `int32` |  |
  | 4 | **`query`** | `string` | `query` in ListWorkers is used to filter workers based on worker attributes. |

  ### Additional Notes

    * `include_system_workers` (`bool`): When true, the response will include system workers that are created implicitly
      by the server and not by the user. By default, system workers are excluded.
    * `query` (`string`): `query` in ListWorkers is used to filter workers based on worker attributes.
      Supported attributes:
      * WorkerInstanceKey
      * WorkerIdentity
      * HostName
      * TaskQueue
      * DeploymentName
      * BuildId
      * SdkName
      * SdkVersion
      * StartTime
      * Status

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :page_size, 2, type: :int32, json_name: "pageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :query, 4, type: :string
  field :include_system_workers, 5, type: :bool, json_name: "includeSystemWorkers"
end
