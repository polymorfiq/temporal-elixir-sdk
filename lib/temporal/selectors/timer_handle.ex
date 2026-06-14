defmodule Temporal.Selectors.TimerHandle do
  defstruct [:run_id, :workflow_id, :timer_id]

  @type t :: %__MODULE__{
          run_id: String.t(),
          workflow_id: String.t(),
          timer_id: String.t()
        }
end
