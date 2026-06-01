defmodule Temporal.CoreSdk do
  use Rustler,
    otp_app: :temporal,
    crate: :temporalcoresdk

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.ClientOpts
  alias Temporal.CoreSdk.Data.RuntimeOpts

  @doc false
  @spec _create_runtime(opts :: RuntimeOpts.t()) :: {:ok, term()} | {:error, term()}
  def _create_runtime(_opts \\ nil), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_client(runtime :: CoreRuntime.t(), opts :: ClientOpts.t(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _create_client(_runtime, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)
end
