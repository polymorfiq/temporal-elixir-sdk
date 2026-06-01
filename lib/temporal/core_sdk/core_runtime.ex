defmodule Temporal.CoreSdk.CoreRuntime do
  defstruct [:runtime]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.RuntimeOpts

  @type t :: %__MODULE__{
          runtime: term()
        }

  @spec new(opts :: RuntimeOpts.t()) :: {:ok, t()} | {:error, term()}
  def new(opts \\ nil) do
    with {:ok, runtime} <- CoreSdk._create_runtime(opts) do
      {:ok, %__MODULE__{runtime: runtime}}
    end
  end
end
