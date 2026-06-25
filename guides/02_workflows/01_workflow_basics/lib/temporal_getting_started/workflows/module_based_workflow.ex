defmodule TemporalGettingStarted.Workflows.ModuleBasedWorkflow do
  @moduledoc """
  Using a module-based workflow can be convenient as it provides convenience options for bulk-registering activities and otherwise keeps everything organized and together.

  ```
  use Temporal.Workflow, activities: [:multiply]
  ```

  It also provides a convenient place for keeping struct-based Params:
  ```
  defmodule Params do
    defstruct [:multiply_me, multiply_by: nil]
    @type t :: %__MODULE__{multiply_me: number(), multiply_by: number() | nil}
  end
  ... workflow definition ...
  ```
  """

  use Temporal.Workflow, activities: [:multiply]
  alias Temporal.{Workflow, WorkflowContext}

  defmodule Params do
    defstruct [:multiply_me, multiply_by: nil]
    @type t :: %__MODULE__{multiply_me: number(), multiply_by: number() | nil}
  end

  @doc """
  The first parameter of an Elixir-based Workflow must be a `t:Temporal.WorkflowContext.t/0`.

  This allows for interacting with the Workflow Execution Context, which is required for communicating about the workflow to the Temporal Server.

  Additional parameters can be passed to the Workflow when it is invoked.
  A Workflow Definition may support multiple custom parameters, or none.
  These parameters can be of any type that Elixir supports, as transporting them will fallback on Erlang's [External Term Format](https://www.erlang.org/doc/apps/erts/erl_ext_dist.html) for serialization and deserialization.

  However, the best practice is to pass a single parameter that is of a `struct` type, so there can be some backward compatibility if new parameters are added.

  Keep in mind that the Workers executing activities, or the Workflow code upon executing a retry, might run on a different node or at an arbitrary point in the future. So it is generally recommended to not pass around Process IDs.

  The return values can be `{:ok, term()}` if the workflow should succeed, `{:error, term()}` should the workflow fail.
  If an exception is raised mid-workflow, it will be treated as a failure and perhaps retried by the Temporal Server.

  When retries are exhausted, anything listening will see `{:error, details}` as the response.
  """
  @spec execute(WorkflowContext.t(), Params.t()) :: {:ok, number()} | {:error, number()}
  def execute(ctx, %Params{multiply_by: nil} = params) do
    ctx = Workflow.with_activity_opts(ctx, start_to_close_timeout: {10, :seconds})

    #
    # The Activity function name can be provided as a function capture or as a string.
    # The benefit of passing the actual function capture is that the framework can validate the parameters against the Activity Definition.
    # The `execute_activity` call returns a handle, which can be used to get the result of the Activity Execution. The actual execution is asynchronous until you utilize `&Workflow.get/2` to request the results, at which point it blocks.
    #

    {:ok, multiplied_by_5} = Workflow.execute_activity!(ctx, &multiply/2, [params.multiply_me, 5]) |> then(& Workflow.get(ctx, &1))
    {:ok, multiplied_by_15} = Workflow.execute_activity!(ctx, "ModuleBasedWorkflow.multiply", [multiplied_by_5, 3]) |> then(& Workflow.get(ctx, &1))

    {:ok, "#{params.multiply_me} x 15 = #{multiplied_by_15}"}
  end

  #
  # Workflows can use the pattern-matching function heads and even multiple arities of the same function head, just like regular Elixir functions.
  #
  def execute(ctx, %Params{multiply_me: a, multiply_by: b}) do
    ctx = Workflow.with_activity_opts(ctx, start_to_close_timeout: {10, :seconds})

    {:ok, multiplied} = Workflow.execute_activity!(ctx, &multiply/2, [a, b]) |> then(& Workflow.get(ctx, &1))
    {:ok, "#{a} x #{b} = #{multiplied}"}
  end

  @spec multiply(number(), number()) :: {:ok, number()}
  def multiply(a, b) do
    {:ok, a * b}
  end
end