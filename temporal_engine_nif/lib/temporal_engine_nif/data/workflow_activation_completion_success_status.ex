defmodule TemporalEngineNif.Data.WorkflowActivationCompletionSuccessStatus do
  defstruct [:commands, used_internal_flags: [], versioning_behavior: :unspecified]

  alias TemporalEngineNif.Data

  @type versioning_behavior :: :unspecified | :pinned | :auto_upgrade
  @type t :: %__MODULE__{
          commands: [Data.WorkflowCommand.t()],
          used_internal_flags: [pos_integer()],
          versioning_behavior: versioning_behavior()
        }
end
