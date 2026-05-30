defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo do
  @moduledoc """
  Automatically generated module for WorkerSlotsInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`current_available_slots`** | `int32` | Number of slots available for the worker to specific tasks. |
  | 2 | **`current_used_slots`** | `int32` | Number of slots used by the worker for specific tasks. |
  | 7 | **`last_interval_failure_tasks`** | `int32` | Number of failed tasks processed since the last heartbeat from the worker. |
  | 6 | **`last_interval_processed_tasks`** | `int32` | Number of tasks processed in since the last heartbeat from the worker. |
  | 3 | **`slot_supplier_kind`** | `string` | Kind of the slot supplier, which is used to determine how the slots are allocated. |
  | 5 | **`total_failed_tasks`** | `int32` | Total number of failed tasks processed by the worker so far. |
  | 4 | **`total_processed_tasks`** | `int32` | Total number of tasks processed (completed both successfully and unsuccesfully, or any other way) |

  ### Additional Notes

    * `current_available_slots` (`int32`): Number of slots available for the worker to specific tasks.
      May be -1 if the upper bound is not known.
    * `last_interval_processed_tasks` (`int32`): Number of tasks processed in since the last heartbeat from the worker.
      This is a cumulative counter, and it is reset to 0 each time the worker sends a heartbeat.
      Contains both successful and failed tasks.
    * `slot_supplier_kind` (`string`): Kind of the slot supplier, which is used to determine how the slots are allocated.
      Possible values: "Fixed | ResourceBased | Custom String"
    * `total_processed_tasks` (`int32`): Total number of tasks processed (completed both successfully and unsuccesfully, or any other way)
      by the worker since the worker started. This is a cumulative counter.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :current_available_slots, 1, type: :int32, json_name: "currentAvailableSlots"
  field :current_used_slots, 2, type: :int32, json_name: "currentUsedSlots"
  field :slot_supplier_kind, 3, type: :string, json_name: "slotSupplierKind"
  field :total_processed_tasks, 4, type: :int32, json_name: "totalProcessedTasks"
  field :total_failed_tasks, 5, type: :int32, json_name: "totalFailedTasks"
  field :last_interval_processed_tasks, 6, type: :int32, json_name: "lastIntervalProcessedTasks"
  field :last_interval_failure_tasks, 7, type: :int32, json_name: "lastIntervalFailureTasks"
end
