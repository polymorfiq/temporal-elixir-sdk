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

  @type opts :: [
          {:workflow_slot_supplier, WorkerSlotSupplierOpts.t()}
          | {:activity_slot_supplier, WorkerSlotSupplierOpts.t()}
          | {:local_activity_slot_supplier, WorkerSlotSupplierOpts.t()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    tuner = struct!(__MODULE__, opts)

    tuner =
      update_in(
        tuner,
        [Access.key(:workflow_slot_supplier)],
        &WorkerSlotSupplierOpts.with_opts!/1
      )

    tuner =
      update_in(
        tuner,
        [Access.key(:activity_slot_supplier)],
        &WorkerSlotSupplierOpts.with_opts!/1
      )

    tuner =
      update_in(
        tuner,
        [Access.key(:local_activity_slot_supplier)],
        &WorkerSlotSupplierOpts.with_opts!/1
      )

    tuner
  end
end
