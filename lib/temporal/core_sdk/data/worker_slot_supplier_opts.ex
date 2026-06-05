defmodule Temporal.CoreSdk.Data.WorkerSlotSupplierOpts do
  alias Temporal.CoreSdk.Data.WorkerTunerResourceOpts

  @type t :: {:fixed_size, pos_integer()} | {:resource_based, WorkerTunerResourceOpts.opts()}

  def with_opts!({:fixed_size, fixed_size}) do
    {:fixed_size, fixed_size}
  end

  def with_opts!({:resource_based, resource_tuner_opts}) do
    {:resource_based, WorkerTunerResourceOpts.with_opts!(resource_tuner_opts)}
  end
end
