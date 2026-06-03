defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus do
  defstruct [:commands, :used_internal_flags, :versioning_behavior]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          commands: [Data.WorkflowCommand.t()],
          used_internal_flags: [pos_integer()],
          versioning_behavior: integer()
        }
end
