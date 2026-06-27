defmodule Temporal.Workflow.ChildWorkflowActions do
  require Record
  import Temporal.WorkflowContext
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.Common

  alias Temporal.Workflow.WorkflowExecution
  alias Temporal.WorkflowContext
  alias Temporal.Workflows.WorkflowName
  alias TemporalEngine.Data.Commands

  Record.defrecord(:child_workflow_handle, [:seq, :execution, :workflow_id])

  @type child_workflow_handle ::
          record(:child_workflow_handle,
            seq: pos_integer(),
            execution: pid(),
            workflow_id: String.t()
          )

  @spec execute_child_workflow!(
          WorkflowContext.t(),
          WorkflowName.t(),
          [term()],
          Commands.start_child_workflow_execution_opts()
        ) :: child_workflow_handle()
  def execute_child_workflow!(ctx, name, inputs, opts \\ []) do
    {:ok, activity_handle} = execute_child_workflow(ctx, name, inputs, opts)
    activity_handle
  end

  @spec execute_child_workflow(
          WorkflowContext.t(),
          WorkflowName.t(),
          [term()],
          Commands.start_child_workflow_execution_opts()
        ) :: {:ok, child_workflow_handle()} | {:error, term()}
  def execute_child_workflow(ctx, name, inputs, opts \\ []) do
    opts = WorkflowContext.workflow_context(ctx, :child_workflow_options) ++ opts

    workflow_context(namespace: namespace, execution: exec, task_queue: task_queue) = ctx

    # Let's default to the current workflow's settings unless otherwise specified
    opts =
      Keyword.merge(
        [
          namespace: namespace,
          task_queue: task_queue,
          input: inputs
        ],
        opts
      )

    with {:ok, workflow_type} <- WorkflowName.server_recognized_name(name),
         {:ok, cmd} <-
           start_child_workflow_execution_from_opts(
             Keyword.merge([workflow_type: workflow_type], opts)
           ),
         {:ok, start_child_workflow_execution(id: workflow_id, seq: seq)} <-
           WorkflowExecution.queue_command(exec, cmd) do
      {:ok, child_workflow_handle(seq: seq, execution: exec, workflow_id: workflow_id)}
    end
  end

  def get_child_workflow_execution(
        child_workflow_handle(seq: seq, execution: exec, workflow_id: workflow_id)
      ) do
    with {:ok, run_id} <- WorkflowExecution.get_child_workflow(exec, seq) do
      {:ok, workflow_execution(workflow_id: workflow_id, run_id: run_id)}
    end
  end

  def get(child_workflow_handle(seq: seq, execution: exec)),
    do: WorkflowExecution.get_child_workflow_result(exec, seq)
end
