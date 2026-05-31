defmodule Temporal.Data.Worker.WorkerHeartbeat do
  defstruct [:heartbeat_at, :worker_started_at, :last_heartbeat_at, :addr, :host]

  @type t :: %__MODULE__{
          worker_started_at: DateTime.t(),
          heartbeat_at: DateTime.t(),
          last_heartbeat_at: DateTime.t() | nil,
          addr: WorkerAddress.t(),
          host: Environment.host_info()
        }
end
