defmodule TemporalEngineNif.Data.WorkflowSearchAttributes do
  defstruct indexed_fields: %{}

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          indexed_fields: %{String.t() => Data.Payload.t()}
        }

  @type opts ::
          [{:indexed_fields, %{String.t() => Data.Payload.opts()}}]
          | %{String.t() => Data.Payload.opts()}

  @spec with_opts!(opts()) :: t()
  def with_opts!(fields) when is_map(fields) do
    %__MODULE__{indexed_fields: Map.new(fields, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)}
  end

  def with_opts!(opts) do
    attribs = struct!(__MODULE__, opts)

    attribs =
      update_in(attribs, [Access.key(:indexed_fields)], fn fields ->
        Map.new(fields, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    attribs
  end
end
