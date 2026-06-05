defmodule Temporal.CoreSdk.Data.Header do
  defstruct [
    :fields
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          fields: %{String.t() => Data.ActivationPayload.t()}
        }

  @type opts ::
          %{String.t() => Data.ActivationPayload.t()}
          | [{:fields, %{String.t() => Data.ActivationPayload.t()}}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) when is_map(opts) do
    %__MODULE__{fields: opts}
  end

  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
