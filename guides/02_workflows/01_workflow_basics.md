# Workflow basics - Elixir SDK

> This section explains Workflow basics with the Elixir SDK

## How to develop a basic Workflow

Workflows are the fundamental unit of a Temporal Application, and it all starts with the development of a [Workflow Definition](https://docs.temporal.io/workflow-definition).

In the Temporal Elixir SDK programming model, a [Workflow Definition](https://docs.temporal.io/workflow-definition) is a function.

Below is an example of a basic Workflow Definition.

---

If you'd like, you can [view this code](/guides/02_workflows/01_workflow_basics/lib/temporal_getting_started/workflows/function_based_workflow.ex) in context of an actual codebase.

---
```elixir
defmodule TemporalGettingStarted.Workflows.FunctionBasedWorkflow do
  # ...

  def function_based_workflow(ctx, ...) do
    # ...
    {:ok, nil}
  end
  
  # ...
end
```

### How to define Workflow parameters

Temporal Workflows may have any number of custom parameters.
However, we strongly recommend that structs are used as parameters, so that the structs's individual fields may be altered without breaking the signature of the Workflow.

The first parameter of an Elixir-based Workflow Definition must be of the [`Temporal.WorkflowContext.t()`](/temporal/lib/temporal/workflow_context.ex) type.
It is used by the Temporal Elixir SDK to pass around Workflow Execution context, and virtually all the SDK APIs that are callable from the Workflow require it.

Additional parameters can be passed to the Workflow when it is invoked.
A Workflow Definition may support multiple custom parameters, or none.
The best practice is to pass a single parameter that is of a `struct` type, so there can be some backward compatibility if new parameters are added.

---

If you'd like, you can [view this code](/guides/02_workflows/01_workflow_basics/lib/temporal_getting_started/workflows/module_based_workflow.ex) in context of an actual codebase.

---

```elixir
defmodule TemporalGettingStarted.Workflows.ModuleBasedWorkflow do
  use Temporal.Workflow, activities: [:multiply]
  alias Temporal.{Workflow, WorkflowContext}

  defmodule Params do
    defstruct [:multiply_me, multiply_by: nil]
    @type t :: %__MODULE__{multiply_me: number(), multiply_by: number() | nil}
  end
  
  @spec execute(WorkflowContext.t(), Params.t()) :: {:ok, number()} | {:error, number()}
  def execute(ctx, %Params{} = params) do
    # ...
  end
  
  # ...
end
```

### How to define Workflow return parameters

Returning results, returning errors, or throwing exceptions is fairly idiomatic in each language that is supported.

An Elixir-based Workflow Definition can return either `{:ok, ...}` or `{:error, ...}`.

The best practice here is to use a `struct` type to hold all custom values to allow for more easily writing backwards-compatible code.

Returning an `{:error, ...}` indicates that the workflow encountered an error during execution and should be considered as having failed.

### How to customize Workflow Type in Elixir

In Elixir, by default, the Workflow Type name is the same as `TopLevelModule` in the case of Module-based workflows, and `TopLevelModule.workflow_fn` in the case of function-based workflows.

To customize the Workflow Type, set the `name` parameter with `opts`, via a 3-element tuple when registering your Workflow with a Worker.

---

If you'd like, you can [view this code](/guides/02_workflows/01_workflow_basics/lib/temporal_getting_started/application.ex) in context of an actual codebase.

---
```elixir
defmodule TemporalGettingStarted.Application do
  # ...
  def start(_type, _args) do
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    children = [
       {Temporal.Worker, [
         client: client,
         workflows: [
           {Workflows.FunctionBasedWorkflow, :function_based_workflow, [name: "my_custom_workflow_type"]}
           # ...
         ],
         # ...
       ]}
    ]
    
    # ...
  end
end

```

### How to develop Workflow logic

Workflow logic is constrained by [deterministic execution requirements](https://docs.temporal.io/workflow-definition#deterministic-constraints). Each Temporal SDK provides a set of APIs that can be used inside your Workflow to interact with application code outside the Workflow.

In Elixir, Workflow Definition code cannot directly do the following:

- Iterate over Maps because the order of the map's iteration is randomized.
  Instead you can collect the keys of the map, sort them, and then iterate over the sorted keys to access the map.
  This technique provides deterministic results.
  You can also use a Side Effect or an Activity to process the map instead.
- Call an external API, conduct a file I/O operation, talk to another service, etc. (Use an Activity for these.)

The Temporal Go SDK has APIs to handle equivalent Go constructs:

- `Workflow.utc_now(ctx)` This is a replacement for `&DateTime.utc_now/1`.
- `Workflow.sleep(ctx, ...)` This is a replacement for `&Process.sleep/1`.
