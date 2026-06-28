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
