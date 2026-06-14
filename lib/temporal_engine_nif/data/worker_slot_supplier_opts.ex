defmodule TemporalEngineNif.Data.WorkerSlotSupplierOpts do
  alias TemporalEngineNif.Data.WorkerTunerResourceOpts

  @type t :: {:fixed_size, pos_integer()} | {:resource_based, WorkerTunerResourceOpts.opts()}

  def with_opts!({:fixed_size, fixed_size}) do
    {:fixed_size, fixed_size}
  end

  def with_opts!({:resource_based, resource_tuner_opts}) do
    {:resource_based, WorkerTunerResourceOpts.with_opts!(resource_tuner_opts)}
  end
end
