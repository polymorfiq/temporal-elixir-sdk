defmodule Temporal.CoreSdk.Data.WorkerTunerOpts do
  defstruct [
    :workflow_slot_supplier,
    :activity_slot_supplier,
    :local_activity_slot_supplier
  ]

  alias Temporal.CoreSdk.Data.WorkerSlotSupplierOpts

  @type t :: %__MODULE__{
          workflow_slot_supplier: WorkerSlotSupplierOpts.t(),
          activity_slot_supplier: WorkerSlotSupplierOpts.t(),
          local_activity_slot_supplier: WorkerSlotSupplierOpts.t()
        }
end
