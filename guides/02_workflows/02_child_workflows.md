# Child Workflows - Elixir SDK

> Use the Elixir SDK to start a Child Workflow Execution and set a Parent Close Policy, including details on Workflow Options and future management.

This page shows how to do the following:

- [Start a Child Workflow Execution](#child-workflows)
- [Set a Parent Close Policy](#parent-close-policy)

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

A [Parent Close Policy](/parent-close-policy) determines what happens to a Child Workflow Execution if its Parent changes to a Closed status (Completed, Failed, or Timed Out).

The default Parent Close Policy option is set to terminate the Child Workflow Execution.

In Go, a Parent Close Policy is set on the `ParentClosePolicy` field of an instance of [`workflow.ChildWorkflowOptions`](https://pkg.go.dev/go.temporal.io/sdk/workflow#ChildWorkflowOptions).
The possible values can be obtained from the [`go.temporal.io/api/enums/v1`](https://pkg.go.dev/go.temporal.io/api/enums/v1#ParentClosePolicy) package.

- `PARENT_CLOSE_POLICY_ABANDON`
- `PARENT_CLOSE_POLICY_TERMINATE`
- `PARENT_CLOSE_POLICY_REQUEST_CANCEL`

The Child Workflow Options are then applied to the instance of `workflow.Context` by using the `WithChildOptions` API, which is then passed to the `ExecuteChildWorkflow()` call.

- Type: [`ParentClosePolicy`](https://pkg.go.dev/go.temporal.io/api/enums/v1#ParentClosePolicy)
- Default: `PARENT_CLOSE_POLICY_TERMINATE`

```go
import (
  // ...
  "go.temporal.io/api/enums/v1"
)

func YourWorkflowDefinition(ctx workflow.Context, params ParentParams) (ParentResp, error) {
  // ...
  childWorkflowOptions := workflow.ChildWorkflowOptions{
    // ...
    ParentClosePolicy: enums.PARENT_CLOSE_POLICY_ABANDON,
  }
  ctx = workflow.WithChildOptions(ctx, childWorkflowOptions)
  childWorkflowFuture := workflow.ExecuteChildWorkflow(ctx, YourOtherWorkflowDefinition, ChildParams{})
  // ...
}

func YourOtherWorkflowDefinition(ctx workflow.Context, params ChildParams) (ChildResp, error) {
  // ...
  return resp, nil
}
```
