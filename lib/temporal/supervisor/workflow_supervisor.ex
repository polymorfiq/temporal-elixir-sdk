defmodule Temporal.Supervisor.WorkflowSupervisor do
  use Supervisor

  alias Temporal.WorkflowRegistry
  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Workflow.WorkflowExecutor
  alias Temporal.CoreSdk.Data.ActivationInitializeWorkflow

  @type workflow_id :: String.t()
  @type worker_id :: String.t()

  @spec start_link({workflow_id(), worker_id(), ActivationInitializeWorkflow.t(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({workflow_id, workflow_module, worker_id, initialize, server_opts}) do
    Supervisor.start_link(
      __MODULE__,
      {workflow_id, workflow_module, worker_id, initialize},
      server_opts
    )
  end

  @impl true
  def init({workflow_id, workflow_module, worker_id, initialize}) do
    Process.set_label({:workflow_sup, workflow_id})

    children = [
      {WorkflowProgressReporter,
       {workflow_id, worker_id, initialize,
        [name: via_registry({:progress_reporter, workflow_id}), shutdown: 10_000]}},
      {WorkflowExecutor,
       {workflow_id, worker_id, workflow_module, initialize,
        [name: via_registry({:executor, workflow_id})]}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec progress_reporter_pid(workflow_id()) :: {:ok, term()} | {:error, term()}
  def progress_reporter_pid(workflow_id) do
    if pid = GenServer.whereis(via_registry({:progress_reporter, workflow_id})) do
      {:ok, pid}
    else
      {:error, :progress_reporter_not_running}
    end
  end

  defp via_registry(name), do: {:via, Registry, {WorkflowRegistry, name}}
end
