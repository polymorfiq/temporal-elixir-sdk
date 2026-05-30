defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider do
  @moduledoc """
  ComputeProvider stores information used by a worker control plane controller
  to respond to worker lifecycle events. For example, when a Task is received
  on a TaskQueue that has no active pollers, a serverless worker lifecycle
  controller might need to invoke an AWS Lambda Function that itself ends up
  calling the SDK's worker.New() function.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Contains provider-specific instructions and configuration. |
  | 10 | **`nexus_endpoint`** | `string` | Optional. If the compute provider is a Nexus service, this should point |
  | 1 | **`type`** | `string` | Type of the compute provider. This string is implementation-specific and |

  ### Additional Notes

    * `details` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Contains provider-specific instructions and configuration.
      For server-implemented providers, use the SDK's default content
      converter to ensure the server can understand it.
      For remote-implemented providers, you might use your own content
      converters according to what the remote endpoints understand.
    * `nexus_endpoint` (`string`): Optional. If the compute provider is a Nexus service, this should point
      there.
    * `type` (`string`): Type of the compute provider. This string is implementation-specific and
      can be used by implementations to understand how to interpret the
      contents of the provider_details field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
  field :nexus_endpoint, 10, type: :string, json_name: "nexusEndpoint"
end
