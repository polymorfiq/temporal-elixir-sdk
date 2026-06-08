defmodule Temporal.Activity.ActivityContext do
  defstruct [:activity_id]
  use GenServer

  @type t :: %__MODULE__{}

  require Logger
  require Record
  Record.defrecordp(:context_state, [:activity_id])

  alias Temporal.Supervisor.ExecutionContext

  @spec new(ExecutionContext.t()) :: {:ok, t()} | {:error, term()}
  def new(exec_ctx) do
    {:ok, %__MODULE__{activity_id: exec_ctx.activity_id}}
  end

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    {:ok, context_state(activity_id: exec_ctx.activity_id)}
  end
end
