defmodule TemporalEngineNif.Data.WorkflowMemo do
  defstruct [:fields]

  import TemporalEngine.Data.Jobs

  alias TemporalEngineNif.Data
  alias TemporalEngine.Data.Jobs

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.Payload.t()}
        }

  @spec to_record(nil | t()) :: Jobs.memo() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{fields: fields}) do
    memo(fields: fields)
  end
end
