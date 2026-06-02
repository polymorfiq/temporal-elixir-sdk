defmodule Temporal.CoreSdk do
  use Rustler,
    otp_app: :temporal,
    crate: :temporalcoresdk

  alias Temporal.CoreSdk.Data.ClientOpts
  alias Temporal.CoreSdk.Data.RuntimeOpts
  alias Temporal.CoreSdk.Data.WorkerOpts

  @doc false
  @spec _create_runtime(opts :: RuntimeOpts.t()) :: {:ok, term()} | {:error, term()}
  def _create_runtime(_opts \\ nil), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_client(runtime :: term(), opts :: ClientOpts.t(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _create_client(_runtime, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_worker(runtime :: term(), client :: term(), opts :: WorkerOpts.t(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _create_worker(_runtime, _client, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _validate_worker(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _validate_worker(_runtime, _worker, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)


  @doc false
  @spec _worker_poll_workflow_activation(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _worker_poll_workflow_activation(_runtime, _worker, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)
end
