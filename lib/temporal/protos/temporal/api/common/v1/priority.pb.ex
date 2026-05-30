defmodule Temporal.Protos.Temporal.Api.Common.V1.Priority do
  @moduledoc """
  Priority contains metadata that controls relative ordering of task processing
  when tasks are backed up in a queue. Initially, Priority will be used in
  matching (workflow and activity) task queues. Later it may be used in history
  task queues and in rate limiting decisions.

  Priority is attached to workflows and activities. By default, activities
  inherit Priority from the workflow that created them, but may override fields
  when an activity is started or modified.

  Despite being named "Priority", this message also contains fields that
  control "fairness" mechanisms.

  For all fields, the field not present or equal to zero/empty string means to
  inherit the value from the calling workflow, or if there is no calling
  workflow, then use the default value.

  For all fields other than fairness_key, the zero value isn't meaningful so
  there's no confusion between inherit/default and a meaningful value. For
  fairness_key, the empty string will be interpreted as "inherit". This means
  that if a workflow has a non-empty fairness key, you can't override the
  fairness key of its activity to the empty string.

  The overall semantics of Priority are:
  1. First, consider "priority": higher priority (lower number) goes first.
  2. Then, consider fairness: try to dispatch tasks for different fairness keys
     in proportion to their weight.

  Applications may use any subset of mechanisms that are useful to them and
  leave the other fields to use default values.

  Not all queues in the system may support the "full" semantics of all priority
  fields. (Currently only support in matching task queues is planned.)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`fairness_key`** | `string` | Fairness key is a short string that's used as a key for a fairness |
  | 3 | **`fairness_weight`** | `float` | Fairness weight for a task can come from multiple sources for |
  | 1 | **`priority_key`** | `int32` | Priority key is a positive integer from 1 to n, where smaller integers |

  ### Additional Notes

    * `fairness_key` (`string`): Fairness key is a short string that's used as a key for a fairness
      balancing mechanism. It may correspond to a tenant id, or to a fixed
      string like "high" or "low". The default is the empty string.

      The fairness mechanism attempts to dispatch tasks for a given key in
      proportion to its weight. For example, using a thousand distinct tenant
      ids, each with a weight of 1.0 (the default) will result in each tenant
      getting a roughly equal share of task dispatch throughput.

      (Note: this does not imply equal share of worker capacity! Fairness
      decisions are made based on queue statistics, not
      current worker load.)

      As another example, using keys "high" and "low" with weight 9.0 and 1.0
      respectively will prefer dispatching "high" tasks over "low" tasks at a
      9:1 ratio, while allowing either key to use all worker capacity if the
      other is not present.

      All fairness mechanisms, including rate limits, are best-effort and
      probabilistic. The results may not match what a "perfect" algorithm with
      infinite resources would produce. The more unique keys are used, the less
      accurate the results will be.

      Fairness keys are limited to 64 bytes.
    * `fairness_weight` (`float`): Fairness weight for a task can come from multiple sources for
      flexibility. From highest to lowest precedence:
      1. Weights for a small set of keys can be overridden in task queue
         configuration with an API.
      2. It can be attached to the workflow/activity in this field.
      3. The default weight of 1.0 will be used.

      Weight values are clamped to the range [0.001, 1000].
    * `priority_key` (`int32`): Priority key is a positive integer from 1 to n, where smaller integers
      correspond to higher priorities (tasks run sooner). In general, tasks in
      a queue should be processed in close to priority order, although small
      deviations are possible.

      The maximum priority value (minimum priority) is determined by server
      configuration, and defaults to 5.

      If priority is not present (or zero), then the effective priority will be
      the default priority, which is calculated by (min+max)/2. With the
      default max of 5, and min of 1, that comes out to 3.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :priority_key, 1, type: :int32, json_name: "priorityKey"
  field :fairness_key, 2, type: :string, json_name: "fairnessKey"
  field :fairness_weight, 3, type: :float, json_name: "fairnessWeight"
end
