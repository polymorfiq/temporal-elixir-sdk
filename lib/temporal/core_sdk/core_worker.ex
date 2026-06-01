defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:worker]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts

  @type t :: %__MODULE__{
          worker: term()
        }

  @spec new(runtime :: CoreRuntime.t(), client :: CoreClient.t(), opts :: WorkerOpts.t()) ::
          {:ok, t()} | {:error, term()}
  def new(runtime, client, opts) do
    with {:ok, worker} <- CoreSdk._create_worker(runtime.runtime, client.client, opts) do
      {:ok, %__MODULE__{worker: worker}}
    end
  end
end
