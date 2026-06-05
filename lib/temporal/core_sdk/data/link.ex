defmodule Temporal.CoreSdk.Data.Link do
  defstruct [
    :fields
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.ActivationPayload.t()}
        }

  @type opts ::
          [{:fields, %{String.t() => Data.ActivationPayload.opts()}}]
          | %{String.t() => Data.ActivationPayload.t()}

  @spec with_opts!(opts()) :: t()
  def with_opts!(fields) when is_map(fields) do
    %__MODULE__{fields: fields}
  end

  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
