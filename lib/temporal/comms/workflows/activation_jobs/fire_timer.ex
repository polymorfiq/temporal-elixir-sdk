defmodule Temporal.Comms.Workflows.ActivationJobs.FireTimer do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }

  @type fire_timer :: {:fire_timer, pos_integer()}

  def send_to_sdk(%__MODULE__{} = fire_timer) do
    {:fire_timer, fire_timer.seq}
  end
end
