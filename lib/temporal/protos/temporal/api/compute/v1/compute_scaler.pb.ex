defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler do
  @moduledoc """
  ComputeScaler instructs the Temporal Service when to scale up or down the number of
  Workers that comprise a WorkerDeployment.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Contains scaler-specific instructions and configuration. |
  | 1 | **`type`** | `string` | Type of the compute scaler. this string is implementation-specific and |

  ### Additional Notes

    * `details` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Contains scaler-specific instructions and configuration.
      For server-implemented scalers, use the SDK's default data
      converter to ensure the server can understand it.
      For remote-implemented scalers, you might use your own data
      converters according to what the remote endpoints understand.
    * `type` (`string`): Type of the compute scaler. this string is implementation-specific and
      can be used by implementations to understand how to interpret the
      contents of the scaler_details field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string
  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
