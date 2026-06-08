defmodule Temporal.Workflow.WorkflowContext do
  defstruct [:run_id, :workflow_id, :pid, :reporter_pid, :flow_control_pid]
  use GenServer

  @type t :: %__MODULE__{}

  require Logger
  require Record
  Record.defrecordp(:context_state, [:id, :workflow_id, :worker_id, :module])

  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Supervisor.ExecutionContext

  @spec new(ExecutionContext.t()) :: t()
  def new(exec_ctx) do
    with {:ok, context_pid} <- WorkflowSupervisor.context_pid(exec_ctx.run_id),
         {:ok, reporter_pid} <- WorkflowSupervisor.progress_reporter_pid(exec_ctx.run_id),
         {:ok, flow_control_pid} <- WorkflowSupervisor.flow_control_pid(exec_ctx.run_id) do
      {:ok,
       %__MODULE__{
         run_id: exec_ctx.run_id,
         workflow_id: exec_ctx.workflow_id,
         pid: context_pid,
         reporter_pid: reporter_pid,
         flow_control_pid: flow_control_pid
       }}
    else
      {:error, err} -> {:error, "Error creating workflow context - #{inspect(err)}"}
    end
  end

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    {:ok,
     context_state(
       id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       module: exec_ctx.workflow_module
     )}
  end
end
