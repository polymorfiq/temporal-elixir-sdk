defmodule TemporalEngineNif.Data.WorkerSlotSupplierOpts do
  alias TemporalEngineNif.Data.WorkerTunerResourceOpts

  @type t :: {:fixed_size, pos_integer()} | {:resource_based, WorkerTunerResourceOpts.opts()}
end
