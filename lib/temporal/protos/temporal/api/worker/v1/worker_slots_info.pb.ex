defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current_available_slots, 1, type: :int32, json_name: "currentAvailableSlots")
  field(:current_used_slots, 2, type: :int32, json_name: "currentUsedSlots")
  field(:slot_supplier_kind, 3, type: :string, json_name: "slotSupplierKind")
  field(:total_processed_tasks, 4, type: :int32, json_name: "totalProcessedTasks")
  field(:total_failed_tasks, 5, type: :int32, json_name: "totalFailedTasks")
  field(:last_interval_processed_tasks, 6, type: :int32, json_name: "lastIntervalProcessedTasks")
  field(:last_interval_failure_tasks, 7, type: :int32, json_name: "lastIntervalFailureTasks")
end
