defmodule Temporal.CoreSdk.Data.WorkerSlotSupplierOpts do
  defstruct fixed_size: nil,
            resource_based: nil

  alias Temporal.CoreSdk.Data.WorkerTunerResourceOpts

  @type t :: %__MODULE__{
          fixed_size: pos_integer(),
          resource_based: WorkerTunerResourceOpts.t()
        }
end
