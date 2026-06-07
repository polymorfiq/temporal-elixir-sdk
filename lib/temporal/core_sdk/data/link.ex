defmodule Temporal.CoreSdk.Data.Link do
  defstruct [
    :fields
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.Payload.t()}
        }

  @type opts ::
          [{:fields, %{String.t() => Data.Payload.opts()}}]
          | %{String.t() => Data.Payload.t()}

  @spec with_opts!(opts()) :: t()
  def with_opts!(fields) when is_map(fields) do
    %__MODULE__{fields: fields}
  end

  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
