defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetCurrentDeploymentRequest do
  @moduledoc """
  Returns the Current Deployment of a deployment series.
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`series_name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :series_name, 2, type: :string, json_name: "seriesName"
end
