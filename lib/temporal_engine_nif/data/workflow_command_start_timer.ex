defmodule TemporalEngineNif.Data.WorkflowCommandStartTimer do
  defstruct [:seq, start_to_fire_timeout: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          start_to_fire_timeout: Data.Duration.t() | nil
        }
  @type opts :: [{:seq, pos_integer()} | {:start_to_fire_timeout, Data.Duration.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    timer = struct!(__MODULE__, opts)

    timer =
      if opts[:start_to_fire_timeout] do
        update_in(timer, [Access.key(:start_to_fire_timeout)], &Data.Duration.with_opts!/1)
      else
        timer
      end

    timer
  end
end
