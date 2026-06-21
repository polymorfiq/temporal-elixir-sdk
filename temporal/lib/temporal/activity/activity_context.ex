defmodule Temporal.Activity.ActivityContext do
  require Record

  Record.defrecord(:activity_context, [:execution, :run_id, :activity_type, :activity_id])

  @type activity_context ::
          record(:activity_context,
            execution: pid(),
            run_id: String.t(),
            activity_type: String.t(),
            activity_id: String.t()
          )
end
