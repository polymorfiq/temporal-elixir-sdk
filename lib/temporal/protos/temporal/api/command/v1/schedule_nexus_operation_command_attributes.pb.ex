defmodule Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes do
  @moduledoc """
  Automatically generated module for ScheduleNexusOperationCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`endpoint`** | `string` | Endpoint name, must exist in the endpoint registry or this command will fail. |
  | 4 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Input for the operation. The server converts this into Nexus request content and the appropriate content headers |
  | 6 | **`nexus_header`** | `Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes.NexusHeaderEntry` | Header to attach to the Nexus request. |
  | 3 | **`operation`** | `string` | Operation name. |
  | 5 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Schedule-to-close timeout for this operation. |
  | 7 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Schedule-to-start timeout for this operation. |
  | 2 | **`service`** | `string` | Service name. |
  | 8 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Start-to-close timeout for this operation. |

  ### Additional Notes

    * `input` (`Temporal.Protos.Temporal.Api.Common.V1.Payload`): Input for the operation. The server converts this into Nexus request content and the appropriate content headers
      internally when sending the StartOperation request. On the handler side, if it is also backed by Temporal, the
      content is transformed back to the original Payload sent in this command.
    * `nexus_header` (`Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes.NexusHeaderEntry`): Header to attach to the Nexus request.
      Users are responsible for encrypting sensitive data in this header as it is stored in workflow history and
      transmitted to external services as-is.
      This is useful for propagating tracing information.
      Note these headers are not the same as Temporal headers on internal activities and child workflows, these are
      transmitted to Nexus operations that may be external and are not traditional payloads.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Schedule-to-close timeout for this operation.
      Indicates how long the caller is willing to wait for operation completion.
      Calls are retried internally by the server.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Schedule-to-start timeout for this operation.
      Indicates how long the caller is willing to wait for the operation to be started (or completed if synchronous)
      by the handler. If the operation is not started within this timeout, it will fail with
      TIMEOUT_TYPE_SCHEDULE_TO_START.
      If not set or zero, no schedule-to-start timeout is enforced.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
      Requires server version 1.31.0 or later.
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Start-to-close timeout for this operation.
      Indicates how long the caller is willing to wait for an asynchronous operation to complete after it has been
      started. If the operation does not complete within this timeout after starting, it will fail with
      TIMEOUT_TYPE_START_TO_CLOSE.
      Only applies to asynchronous operations. Synchronous operations ignore this timeout.
      If not set or zero, no start-to-close timeout is enforced.
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
      Requires server version 1.31.0 or later.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :endpoint, 1, type: :string
  field :service, 2, type: :string
  field :operation, 3, type: :string
  field :input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload

  field :schedule_to_close_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :nexus_header, 6,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Command.V1.ScheduleNexusOperationCommandAttributes.NexusHeaderEntry,
    json_name: "nexusHeader",
    map: true

  field :schedule_to_start_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
end
