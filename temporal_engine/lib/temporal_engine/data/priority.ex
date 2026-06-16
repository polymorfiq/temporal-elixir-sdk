defmodule TemporalEngine.Data.Priority do
  require Record

  Record.defrecord(:priority, [:priority_key, :fairness_key, :fairness_weight])

  @type priority ::
          record(:priority,
            priority_key: integer(),
            fairness_key: String.t(),
            fairness_weight: float()
          )
end
