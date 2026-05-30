defmodule Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig do
  @moduledoc """
  Configuration for time skipping during a workflow execution.
  When enabled, virtual time advances automatically whenever there is no in-flight work.
  In-flight work includes activities, child workflows, Nexus operations, signal/cancel external workflow operations,
  and possibly other features added in the future.
  User timers are not classified as in-flight work and will be skipped over.
  When time advances, it skips to the earlier of the next user timer or the configured bound, if either exists.

  Propagation behavior of time skipping:
  The enabled flag, bound fields, and accumulated skipped duration are propagated to related executions as follows:
  (1) Child workflows and continue-as-new: both the configuration and the accumulated skipped duration are
      inherited from the current execution. The configured bound is shared between the inherited skipped
      duration and any additional duration skipped by the new run.
  (2) Retry and cron: the configuration and accumulated skipped duration are inherited as recorded when the
      current workflow started; the accumulated skipped duration of the current run is not propagated.
  (3) Reset: the new run retains the time-skipping configuration of the current execution. Because reset replays
      all events up to the reset point and re-applies any UpdateWorkflowExecutionOptions changes made after that
      point, the resulting run ends up with the same final time-skipping configuration as the previous run.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`enabled`** | `bool` | Enables or disables time skipping for this workflow execution. |
  | 5 | **`max_elapsed_duration`** | `Google.Protobuf.Duration` | Maximum elapsed time since time skipping was enabled. |
  | 4 | **`max_skipped_duration`** | `Google.Protobuf.Duration` | Maximum total virtual time that can be skipped. |

  ### Additional Notes

    * `max_elapsed_duration` (`Google.Protobuf.Duration`): Maximum elapsed time since time skipping was enabled.
      This includes both skipped time and real time elapsing.
      (-- api-linter: core::0142::time-field-names=disabled --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :bound, 0

  field :enabled, 1, type: :bool

  field :max_skipped_duration, 4,
    type: Google.Protobuf.Duration,
    json_name: "maxSkippedDuration",
    oneof: 0

  field :max_elapsed_duration, 5,
    type: Google.Protobuf.Duration,
    json_name: "maxElapsedDuration",
    oneof: 0
end
