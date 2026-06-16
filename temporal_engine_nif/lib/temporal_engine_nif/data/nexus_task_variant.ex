defmodule TemporalEngineNif.Data.NexusTaskVariant do
  defstruct task: nil,
            cancel_task: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          task: Data.NexusPollTaskQueueResponse.t() | nil,
          cancel_task: Data.NexusCancelTask.t() | nil
        }
end
