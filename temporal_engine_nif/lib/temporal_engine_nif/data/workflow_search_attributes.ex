defmodule TemporalEngineNif.Data.WorkflowSearchAttributes do
  defstruct indexed_fields: %{}

  import TemporalEngine.Data.Jobs

  alias TemporalEngineNif.Data
  alias TemporalEngine.Data.Jobs

  @type t :: %__MODULE__{
          indexed_fields: %{String.t() => Data.Payload.t()}
        }

  @spec to_record(nil | t()) :: Jobs.search_attribs() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{indexed_fields: fields}) do
    search_attribs(indexed_fields: fields)
  end
end
