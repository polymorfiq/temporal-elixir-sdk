defmodule TemporalSamples.Workflows.ErlangTermFormat do
  @moduledoc """
  The Erlang SDK allows for inputs/outputs to be sent in erlang term format.
  Can be beneficial for very Elixir-centric workflows and local activities, though disadvantageous for cross-language compatibility.
  This can be done by using the tuple {:etf, ... arbitrary term ...}

  Look in [test/workflows/erlang_term_format_test.exs](test/workflows/erlang_term_format_test.exs) for usage
  """

  use Temporal.Workflow, activities: [greet: 2]
  alias Temporal.Workflow

  @doc """
  The main body of the workflow.

  Note that it can take a keyword list due to {:etf, ...}, like below:
  ```elixir
  TaskQueue.start_workflow(..., [{:etf, [
      name: "World",
      first_name: "Bob",
      last_name: "Smith"
  ]}])
  ```
  """
  def execute(ctx, kw_list_input) do
    # Schedule activities (non-blocking)
    name = Keyword.fetch!(kw_list_input, :name)

    {:ok, given_name} =
      Workflow.execute_activity(
        ctx,
        &greet/2,
        [etf({:given_name, name})],
        start_to_close_timeout: [seconds: 1]
      )

    fname = Keyword.fetch!(kw_list_input, :first_name)
    lname = Keyword.fetch!(kw_list_input, :last_name)

    {:ok, first_last_name} =
      Workflow.execute_activity(
        ctx,
        &greet/2,
        [etf({:first_last_name, fname, lname})],
        start_to_close_timeout: [seconds: 1]
      )

    # Get result of activity (blocks until activity finished).
    with {:ok, {:greeting, greeting_1}} <- Workflow.get(ctx, given_name),
         {:ok, {:greeting, greeting_2}} <- Workflow.get(ctx, first_last_name) do
      {:ok, [greeting_1, greeting_2]}
    end
  end

  @doc """
  A simple activity, marked as such by the use Temporal.Workflow, [activities: ...] above.

  Note the tuple it takes as an input, made possible by {:etf, ...}
  """
  def greet(_ctx, {:given_name, name}) do
    {:ok, etf({:greeting, "Hello, #{name}!"})}
  end

  def greet(_ctx, {:first_last_name, first_name, last_name}) do
    {:ok, etf({:greeting, "Hello, #{first_name} #{last_name}!"})}
  end

  defp etf(val), do: {:etf, val}
end
