defmodule TemporalEngineNif.Data.WorkerTunerResourceOpts do
  defstruct [
    :target_mem_usage,
    :target_cpu_usage,
    :min_slots,
    :max_slots,
    :ramp_throttle
  ]

  @type t :: %__MODULE__{
          target_mem_usage: float(),
          target_cpu_usage: float(),
          min_slots: pos_integer(),
          max_slots: pos_integer(),
          ramp_throttle: float()
        }

  @type opts :: [
          {:target_mem_usage, float()}
          | {:target_cpu_usage, float()}
          | {:min_slots, pos_integer()}
          | {:max_slots, pos_integer()}
          | {:ramp_throttle, float()}
        ]
  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
