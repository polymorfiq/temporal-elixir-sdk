defmodule Temporal.Activity.ActivityExecHandle do
  defstruct [:run_id, :workflow_id, :activity_id, :activity_type]

  @type t :: %__MODULE__{
          run_id: String.t(),
          workflow_id: String.t(),
          activity_id: String.t(),
          activity_type: String.t()
        }
end
