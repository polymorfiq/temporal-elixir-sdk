defmodule TemporalEngine.Data.Priority do
  use TemporalEngine.Data.TypeSpec

  deftype :priority do
    @structdoc """
    Priority contains metadata that controls relative ordering of task processing when tasks are backlogged in a queue. Initially, Priority will be used in activity and workflow task queues, which are typically where backlogs exist. Other queues in the server (such as transfer and timer queues) and rate limiting decisions do not use Priority, but may in the future.

    Priority is attached to workflows and activities. Activities and child workflows inherit Priority from the workflow that created them, but may override fields when they are started or modified.

    All fields default to None, which means “inherit from the calling workflow” or, if there is no calling workflow, “use the server default.”

    Despite being named “Priority”, this type also contains fields that control “fairness” mechanisms.

    The overall semantics of Priority are: (more will be added here later)

    1. First, consider “priority_key”: lower number goes first.
    """

    @doc """
    Priority key is a positive integer from 1 to n, where smaller integers correspond to higher priorities (tasks run sooner). In general, tasks in a queue should be processed in close to priority order, although small deviations are possible.

    The maximum priority value (minimum priority) is determined by server configuration, and defaults to 5.

    The server default priority is (min + max) / 2. With the default max of 5 and min of 1, that comes out to 3.

    `nil` means inherit from the calling workflow or use the server default.
    """
    @type priority_key :: integer()

    @doc """
    Fairness key is a short string that’s used as a key for a fairness balancing mechanism. It may correspond to a tenant id, or to a fixed string like “high” or “low”.

    The fairness mechanism attempts to dispatch tasks for a given key in proportion to its weight. For example, using a thousand distinct tenant ids, each with a weight of 1.0 (the default) will result in each tenant getting a roughly equal share of task dispatch throughput.

    (Note: this does not imply equal share of worker capacity! Fairness decisions are made based on queue statistics, not current worker load.)

    As another example, using keys “high” and “low” with weight 9.0 and 1.0 respectively will prefer dispatching “high” tasks over “low” tasks at a 9:1 ratio, while allowing either key to use all worker capacity if the other is not present.

    All fairness mechanisms, including rate limits, are best-effort and probabilistic. The results may not match what a “perfect” algorithm with infinite resources would produce. The more unique keys are used, the less accurate the results will be.

    Fairness keys are limited to 64 bytes.

    `nil` means inherit from the calling workflow or use the server default (empty string).
    """
    @type fairness_key :: String.t()

    @doc """
    Fairness weight for a task can come from multiple sources for flexibility. From highest to lowest precedence:

    Weights for a small set of keys can be overridden in task queue configuration with an API.
    It can be attached to the workflow/activity in this field.
    The server default weight of 1.0 will be used.
    Weight values are clamped by the server to the range [0.001, 1000].

    `nil` means inherit from the calling workflow or use the server default (1.0).
    """
    @type fairness_weight :: float()
  end
end
