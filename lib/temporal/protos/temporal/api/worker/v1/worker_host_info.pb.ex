defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerHostInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:host_name, 1, type: :string, json_name: "hostName")
  field(:worker_grouping_key, 5, type: :string, json_name: "workerGroupingKey")
  field(:process_id, 2, type: :string, json_name: "processId")
  field(:current_host_cpu_usage, 3, type: :float, json_name: "currentHostCpuUsage")
  field(:current_host_mem_usage, 4, type: :float, json_name: "currentHostMemUsage")
end
