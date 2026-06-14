defmodule TemporalEngineNif.Data.CallbackNexus do
  defstruct [:url, :header]

  @type t :: %__MODULE__{
          url: String.t(),
          header: %{String.t() => String.t()}
        }

  @type opts() :: [{:url, String.t()} | {:header, %{String.t() => String.t()}}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
