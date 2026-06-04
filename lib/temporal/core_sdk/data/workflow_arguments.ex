defmodule Temporal.CoreSdk.Data.WorkflowArguments do
  defstruct [:args]

  alias Temporal.CoreSdk.Data.WorkflowInput

  @type t :: %__MODULE__{args: [WorkflowInput.t()]}
end
