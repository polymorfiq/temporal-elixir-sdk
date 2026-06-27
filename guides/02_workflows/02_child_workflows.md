# Child Workflows - Elixir SDK

> Use the Elixir SDK to start a Child Workflow Execution and set a Parent Close Policy, including details on Workflow Options and future management.

## Start a Child Workflow Execution

A [Child Workflow Execution](https://docs.temporal.io/child-workflows) is a Workflow Execution that is scheduled from within another Workflow using a Child Workflow API.

When using a Child Workflow API, Child Workflow related Events ([StartChildWorkflowExecutionInitiated](https://docs.temporal.io/references/events#startchildworkflowexecutioninitiated), [ChildWorkflowExecutionStarted](https://docs.temporal.io/references/events#childworkflowexecutionstarted), [ChildWorkflowExecutionCompleted](https://docs.temporal.io/references/events#childworkflowexecutioncompleted), etc...) are logged in the Workflow Execution Event History.

The [ChildWorkflowExecutionStarted](https://docs.temporal.io/references/events#childworkflowexecutionstarted) Event must be logged to the Event History before the Parent Workflow completes to ensure the Child Workflow has started.

In Elixir, you must explicitly call `Temporal.WorkflowExecution.get_child_workflow_started/1` on the Child Workflow Handle to wait for this Event.
See the [Async Child Workflows](#async-child-workflows) section below for a complete example.

To spawn a [Child Workflow Execution](https://docs.temporal.io/child-workflows) in Elixir, use the [`Temporal.Workflow.execute_child_workflow`](https://pkg.go.dev/go.temporal.io/sdk/workflow#ExecuteChildWorkflow) API.

The `execute_child_workflow` call requires an instance of `WorkflowContext`, with an instance of `start_child_workflow_execution_opts` applied to it, the Workflow Type, and any parameters that should be passed to the Child Workflow Execution.

`start_child_workflow_execution_opts` contain the same fields as `workflow_start_opts`.
Workflow Option fields automatically inherit their values from the Parent Workflow Options if they are not explicitly set.

If a custom `id` is not set, one is generated when the Child Workflow Execution is spawned.
Use the `Workflow.with_child_workflow_opts/2` API to apply Child Workflow Options to the instance of `WorkflowContext`.

The `execute_child_workflow` call returns an handle representing the child workflow which can be used to wait for and retrieve the asynchronous result.

Call the `Workflow.get/2` method on the handle to wait for the result.

```elixir
defmodule TemporalGettingStarted.Workflows.WorkflowWithChildren do
  alias Temporal.Workflow

  def parent_workflow(ctx) do
    ctx =
      Workflow.with_child_workflow_opts(ctx,
        workflow_execution_timeout: {10, :minutes},
        workflow_task_timeout: {1, :minutes}
      )

    {:ok, child} = Workflow.execute_child_workflow(ctx, &child_workflow/2, ["Child 1"], id: "child_1")
    # ...
    {:ok, result} = Workflow.get(ctx, child)
    # ...
  end

  def child_workflow(ctx, arg) do
    Workflow.sleep(ctx, 3000)
    {:ok, "Processed: #{arg}"}
  end
end
```

### Async Child Workflows

To asynchronously spawn a Child Workflow Execution, the Child Workflow must have an `[parent_close_policy: :abandon]` set in the Child Workflow Options.
Additionally, the Parent Workflow Execution must wait for the `ChildWorkflowExecutionStarted` Event to appear in its Event History before it completes.

If the Parent makes the `execute_child_workflow` call and then immediately completes, the Child Workflow Execution does not spawn.

To be sure that the Child Workflow Execution has started, first call the `Workflow.get_child_workflow_execution` method on the child workflow handle, which will return a Workflow Execution Handle.

```elixir
defmodule TemporalGettingStarted.Workflows.WorkflowWithChildren do
  alias Temporal.Workflow

  def parent_workflow(ctx) do
    ctx =
      Workflow.with_child_workflow_opts(ctx,
        workflow_execution_timeout: {10, :minutes},
        workflow_task_timeout: {1, :minutes},
        parent_close_policy: :abandon
      )

    child =
      Workflow.execute_child_workflow!(ctx, &child_workflow/2, ["Child 1"], id: "child_1")

    # Wait for the child workflow to spawn
    {:ok, _child_we} = Workflow.get_child_workflow_execution(child1)
    # ... The child execution has definitely started and the parent can safely complete
    {:ok, nil}
  end

  def child_workflow(ctx, arg) do
    Workflow.sleep(ctx, 3000)
    {:ok, "Processed: #{arg}"}
  end
end
```

#### Set a Parent Close Policy

A [Parent Close Policy](https://docs.temporal.io/parent-close-policy) determines what happens to a Child Workflow Execution if its Parent changes to a Closed status (Completed, Failed, or Timed Out).

The default Parent Close Policy option is set to terminate the Child Workflow Execution.

In Elixir, a Parent Close Policy is set on the `parent_close_policy` field of an instance of `start_child_workflow_execution_opts`.
The possible values can be obtained from the [`go.temporal.io/api/enums/v1`](https://pkg.go.dev/go.temporal.io/api/enums/v1#ParentClosePolicy) package.

- `:abandon`
- `:terminate`
- `:request_cancel`

The default value for Parent Close Policy is **`:terminate`**

The Child Workflow Options are then applied to the instance of `WorkflowContext` by using the `WorkflowContext.with_child_workflow_opts/2` function, which is then passed to the `execute_child_workflow` call.

```elixir
defmodule TemporalGettingStarted.Workflows.WorkflowWithChildren do
  alias Temporal.Workflow

  def parent_workflow(ctx) do
    ctx =
      Workflow.with_child_workflow_opts(ctx,
        workflow_execution_timeout: {10, :minutes},
        workflow_task_timeout: {1, :minutes},
        parent_close_policy: :abandon
      )

    child1 =
      Workflow.execute_child_workflow!(ctx, &child_workflow_1/2, ["Child 1"], id: "child_1")

    child2 =
      Workflow.execute_child_workflow!(ctx, &child_workflow_2/2, ["Child 2"], id: "child_2")

    {:ok, _child_1_we} = Workflow.get_child_workflow_execution(child1)
    {:ok, _child_2_we} = Workflow.get_child_workflow_execution(child2)

    {:ok, result_1} = Workflow.get(ctx, child1)
    {:ok, result_2} = Workflow.get(ctx, child2)

    {:ok, [result_1, result_2]}
  end

  def child_workflow_1(ctx, arg) do
    Workflow.sleep(ctx, 3000)
    {:ok, "Processed: #{arg}"}
  end

  def child_workflow_2(ctx, arg) do
    Workflow.sleep(ctx, 1000)
    {:ok, "Processed: #{arg}"}
  end
end
```
