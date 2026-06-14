defmodule TemporalEngineNif.Data.Header do
  defstruct [
    :fields
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.Payload.t()}
        }

  @type opts ::
          %{String.t() => Data.Payload.t()}
          | [{:fields, %{String.t() => Data.Payload.t()}}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) when is_map(opts) do
    %__MODULE__{fields: opts}
  end

  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
