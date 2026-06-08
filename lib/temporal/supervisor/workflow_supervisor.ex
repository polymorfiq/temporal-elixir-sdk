defmodule Temporal.Supervisor.WorkflowSupervisor do
  use Supervisor

  alias Temporal.WorkflowRegistry
  alias Temporal.Workflow.WorkflowContext
  alias Temporal.Workflow.WorkflowFlowController
  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Workflow.WorkflowExecutor
  alias Temporal.CoreSdk.Data.WorkflowActivation
  alias Temporal.CoreSdk.Data.ActivationInitializeWorkflow

  @type workflow_id :: String.t()
  @type run_id :: String.t()
  @type worker_id :: String.t()

  @spec start_link(
          {workflow_id(), run_id(), worker_id(), WorkflowActivation.t(),
           ActivationInitializeWorkflow.t(), keyword()}
        ) ::
          {:ok, pid()} | {:error, term()}
  def start_link({exec_ctx, initialize, server_opts}) do
    Supervisor.start_link(
      __MODULE__,
      {exec_ctx, initialize},
      server_opts
    )
  end

  @impl true
  def init({exec_ctx, initialize}) do
    Process.set_label({:workflow_supervisor, exec_ctx.workflow_id})

    run_id = exec_ctx.run_id

    children = [
      {WorkflowProgressReporter,
       {exec_ctx, [name: via_registry({:progress_reporter, run_id}), shutdown: 10_000]}},
      {WorkflowFlowController, {exec_ctx, [name: via_registry({:flow_control, run_id})]}},
      {WorkflowContext, {exec_ctx, [name: via_registry({:context, run_id})]}},
      {WorkflowExecutor, {exec_ctx, initialize, [name: via_registry({:executor, run_id})]}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec stop_workflow(run_id :: String.t()) :: :ok
  def stop_workflow(run_id) do
    if sup = GenServer.whereis(process_name(run_id)) do
      spawn(fn ->
        Supervisor.stop(sup, :shutdown, :infinity)
      end)
    end

    :ok
  end

  @spec progress_reporter_pid(workflow_id()) :: {:ok, term()} | {:error, term()}
  def progress_reporter_pid(workflow_id) do
    if pid = GenServer.whereis(via_registry({:progress_reporter, workflow_id})) do
      {:ok, pid}
    else
      {:error, :progress_reporter_not_running}
    end
  end

  @spec context_pid(workflow_id()) :: {:ok, term()} | {:error, term()}
  def context_pid(workflow_id) do
    if pid = GenServer.whereis(via_registry({:context, workflow_id})) do
      {:ok, pid}
    else
      {:error, :context_not_running}
    end
  end

  @spec flow_control_pid(workflow_id()) :: {:ok, term()} | {:error, term()}
  def flow_control_pid(workflow_id) do
    if pid = GenServer.whereis(via_registry({:flow_control, workflow_id})) do
      {:ok, pid}
    else
      {:error, :flow_control_not_running}
    end
  end

  @spec process_name(run_id :: String.t()) :: {:via, atom(), term()}
  def process_name(run_id), do: via_registry({:workflow, run_id})

  defp via_registry(name), do: {:via, Registry, {WorkflowRegistry, name}}
end
