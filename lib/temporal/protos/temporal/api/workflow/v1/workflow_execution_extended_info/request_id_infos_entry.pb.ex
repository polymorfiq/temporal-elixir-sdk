defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry do
  @moduledoc """
  Holds all the extra information about workflow execution that is not part of Visibility.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Workflow execution expiration time is defined as workflow start time plus expiration timeout. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Workflow.V1.RequestIdInfo` | Workflow run expiration time is defined as current workflow run start time plus workflow run timeout. |

  ### Additional Notes

    * `key` (`string`): Workflow execution expiration time is defined as workflow start time plus expiration timeout.
      Workflow start time may change after workflow reset.

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Workflow.V1.RequestIdInfo
end
