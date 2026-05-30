defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerHostInfo do
  @moduledoc """
  Holds everything needed to identify the worker host/process context

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`current_host_cpu_usage`** | `float` | System used CPU as a float in the range [0.0, 1.0] where 1.0 is defined as all |
  | 4 | **`current_host_mem_usage`** | `float` | System used memory as a float in the range [0.0, 1.0] where 1.0 is defined as |
  | 1 | **`host_name`** | `string` | Worker host identifier. |
  | 2 | **`process_id`** | `string` | Worker process identifier. This id only needs to be unique |
  | 5 | **`worker_grouping_key`** | `string` | Worker grouping identifier. A key to group workers that share the same client+namespace+process. |

  ### Additional Notes

    * `current_host_cpu_usage` (`float`): System used CPU as a float in the range [0.0, 1.0] where 1.0 is defined as all
      cores on the host pegged.
    * `current_host_mem_usage` (`float`): System used memory as a float in the range [0.0, 1.0] where 1.0 is defined as
      all available memory on the host is used.
    * `process_id` (`string`): Worker process identifier. This id only needs to be unique
      within one host (so using e.g. a unix pid would be appropriate).
    * `worker_grouping_key` (`string`): Worker grouping identifier. A key to group workers that share the same client+namespace+process.
      This will be used to build the worker command nexus task queue name:
      "temporal-sys/worker-commands/{worker_grouping_key}"

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :host_name, 1, type: :string, json_name: "hostName"
  field :worker_grouping_key, 5, type: :string, json_name: "workerGroupingKey"
  field :process_id, 2, type: :string, json_name: "processId"
  field :current_host_cpu_usage, 3, type: :float, json_name: "currentHostCpuUsage"
  field :current_host_mem_usage, 4, type: :float, json_name: "currentHostMemUsage"
end
