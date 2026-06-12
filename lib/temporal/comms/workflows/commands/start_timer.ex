defmodule Temporal.Comms.Workflows.Commands.StartTimer do
  defstruct [:seq, :start_to_fire_timeout]

  alias Temporal.Comms.Shared.Duration

  @type seq :: pos_integer()
  @type start_timer :: {:start_timer, seq(), start_to_fire_timeout :: Duration.duration()}
  @type t :: %__MODULE__{seq: pos_integer(), start_to_fire_timeout: Duration.t()}

  @spec send_to_engine(start_timer()) :: t()
  def send_to_engine({:start_timer, seq, timeout}) do
    {:start_timer, %__MODULE__{seq: seq, start_to_fire_timeout: Duration.send_to_engine(timeout)}}
  end
end
