# Continue-As-New - Elixir SDK

> Use Temporal's Continue-As-New in Go to manage large Event Histories by atomically creating new Workflow Executions with the same Workflow Id and fresh parameters.

## What is Continue-As-New?

[Continue-As-New](https://docs.temporal.io/workflow-execution/continue-as-new) lets a Workflow Execution close successfully and creates a new Workflow Execution.
You can think of it as a checkpoint when your Workflow gets too long or approaches certain scaling limits.

The new Workflow Execution is in the same [chain](https://docs.temporal.io/workflow-execution#workflow-execution-chain); it keeps the same Workflow Id but gets a new Run Id and a fresh Event History.
It also receives your Workflow's usual parameters.

## How to Continue-As-New using the Go SDK

First, design your Workflow parameters so that you can pass in the "current state" when you Continue-As-New into the next Workflow run.
This state is typically set to `nil` for the original caller of the Workflow.

Inside your Workflow, return `{:error, Workflow.continue_as_new_error!(...)}` to initiate a Continue As New process.
This stops the Workflow right away and starts a new one.

---

If you'd like, you can [view this code](/guides/02_workflows/03_continue_as_new/lib/temporal_getting_started/workflows/continue_as_new_workflow.ex) in context of an actual codebase.

---
```elixir
defmodule TemporalGettingStarted.Workflows.ContinueAsNewWorkflow do
  use Temporal.Workflow
  alias Temporal.Workflow

  defmodule State do
    defstruct [current_count: 0]
    @type t :: %__MODULE__{current_count: non_neg_integer()}
  end

  def execute(ctx, state \\ %State{}) do
    new_count = state.current_count + 1

    if new_count < 3 do
      {:error, Workflow.continue_as_new_error!(ctx, __MODULE__, [%State{current_count: new_count}])}
    else
      {:ok, new_count}
    end
  end
end
````

### Considerations for Workflows with Message Handlers

If you use Updates or Signals, don't call Continue-as-New from the handlers.

Instead, wait for your handlers to finish in your main Workflow before you return `Workflow.continue_as_new_error!`.
See the [`Workflow.all_handlers_finished?(ctx)`](https://docs.temporal.io/develop/go/workflows/message-passing#wait-for-message-handlers) example for guidance.

## When is it right to Continue-as-New using the Go SDK?

Use Continue-as-New when your Workflow might hit [Event History Limits](https://docs.temporal.io/workflow-execution/event#event-history).

Temporal tracks your Workflow's progress against these limits to let you know when you should Continue-as-New.
Call `Workflow.get_info(ctx).continue_as_new_suggested` to check if it's time.
