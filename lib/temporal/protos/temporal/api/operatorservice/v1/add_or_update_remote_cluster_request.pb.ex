defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.AddOrUpdateRemoteClusterRequest do
  @moduledoc """
  Automatically generated module for AddOrUpdateRemoteClusterRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`enable_remote_cluster_connection`** | `bool` | Flag to enable / disable the cross cluster connection. |
  | 4 | **`enable_replication`** | `bool` | Controls whether replication streams are active. |
  | 1 | **`frontend_address`** | `string` | Frontend Address is a cross cluster accessible address for gRPC traffic. This field is required. |
  | 3 | **`frontend_http_address`** | `string` | Frontend HTTP Address is a cross cluster accessible address for HTTP traffic. This field is optional. If not provided |

  ### Additional Notes

    * `frontend_http_address` (`string`): Frontend HTTP Address is a cross cluster accessible address for HTTP traffic. This field is optional. If not provided
       on update, the existing HTTP address will be removed.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :frontend_address, 1, type: :string, json_name: "frontendAddress"

  field :enable_remote_cluster_connection, 2,
    type: :bool,
    json_name: "enableRemoteClusterConnection"

  field :frontend_http_address, 3, type: :string, json_name: "frontendHttpAddress"
  field :enable_replication, 4, type: :bool, json_name: "enableReplication"
end
