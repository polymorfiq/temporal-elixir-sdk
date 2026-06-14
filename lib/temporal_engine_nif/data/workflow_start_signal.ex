defmodule TemporalEngineNif.Data.WorkflowStartSignal do
  defstruct [
    :signal_name,
    input: nil,
    header: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          signal_name: String.t(),
          input: Data.Payloads.t() | nil,
          header: Data.Header.t() | nil
        }
end
