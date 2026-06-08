defmodule Temporal.Worker.WorkerActivityManager do
  use GenServer
  alias Temporal.Supervisor.ExecutionContext

  require Logger
  require Record

  Record.defrecordp(:activities_state, [:id])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init(ExecutionContext.t()) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    {:ok, activities_state(id: exec_ctx.worker_id)}
  end
end
