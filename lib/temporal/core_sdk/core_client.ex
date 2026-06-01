defmodule Temporal.CoreSdk.CoreClient do
  defstruct [:runtime, :client]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.ClientOpts

  @message_prefix :temporal_client_resp

  @type t :: %__MODULE__{
          runtime: CoreRuntime.t(),
          client: term()
        }

  @spec new(runtime :: CoreRuntime.t(), opts :: ClientOpts.t()) :: {:ok, t()} | {:error, term()}
  def new(runtime, opts) do
    new_async(runtime, opts)

    client_resp =
      receive do
        {@message_prefix, resp} -> resp
      end

    with {:ok, client} <- client_resp do
      {:ok, %__MODULE__{runtime: runtime, client: client}}
    end
  end

  @spec new_async(runtime :: CoreRuntime.t(), opts :: ClientOpts.t()) ::
          {:ok, t()} | {:error, term()}
  def new_async(runtime, opts) do
    parent = self()

    spawn_link(fn ->
      with {:ok, _} <- CoreSdk._create_client(runtime.runtime, opts, self()) do
        receive do
          {:ok, client} ->
            send(parent, {@message_prefix, {:ok, client}})

          {:error, err} ->
            send(parent, {@message_prefix, {:error, {:connection_error, err}}})
        end
      else
        {:error, err} ->
          send(parent, {@message_prefix, {:error, {:creation_error, err}}})
      end
    end)
  end
end
