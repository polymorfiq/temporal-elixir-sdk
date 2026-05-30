defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceSDKInfo do
  @moduledoc """
  Information pertaining to the SDK that the trace has been captured from.
  (-- api-linter: core::0123::resource-annotation=disabled
      aip.dev/not-precedent: Naming SDK version is optional. --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`name`** | `string` | Name of the SDK |
  | 2 | **`version`** | `string` | Version string of the SDK |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :version, 2, type: :string
end
