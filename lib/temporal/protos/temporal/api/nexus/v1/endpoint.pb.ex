defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint do
  @moduledoc """
  A cluster-global binding from an endpoint ID to a target for dispatching incoming Nexus requests.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`created_time`** | `Google.Protobuf.Timestamp` | The date and time when the endpoint was created. |
  | 2 | **`id`** | `string` | Unique server-generated endpoint ID. |
  | 5 | **`last_modified_time`** | `Google.Protobuf.Timestamp` | The date and time when the endpoint was last modified. |
  | 3 | **`spec`** | `Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec` | Spec for the endpoint. |
  | 6 | **`url_prefix`** | `string` | Server exposed URL prefix for invocation of operations on this endpoint. |
  | 1 | **`version`** | `int64` | Data version for this endpoint, incremented for every update issued via the UpdateNexusEndpoint API. |

  ### Additional Notes

    * `created_time` (`Google.Protobuf.Timestamp`): The date and time when the endpoint was created.
      (-- api-linter: core::0142::time-field-names=disabled
          aip.dev/not-precedent: Not following linter rules. --)
    * `last_modified_time` (`Google.Protobuf.Timestamp`): The date and time when the endpoint was last modified.
      Will not be set if the endpoint has never been modified.
      (-- api-linter: core::0142::time-field-names=disabled
          aip.dev/not-precedent: Not following linter rules. --)
    * `url_prefix` (`string`): Server exposed URL prefix for invocation of operations on this endpoint.
      This doesn't include the protocol, hostname or port as the server does not know how it should be accessed
      publicly. The URL is stable in the face of endpoint renames.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :version, 1, type: :int64
  field :id, 2, type: :string
  field :spec, 3, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointSpec
  field :created_time, 4, type: Google.Protobuf.Timestamp, json_name: "createdTime"
  field :last_modified_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastModifiedTime"
  field :url_prefix, 6, type: :string, json_name: "urlPrefix"
end
