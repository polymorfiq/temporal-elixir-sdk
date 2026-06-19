defmodule Temporal.CoreSdk.CoreClient do
  use GenServer
  defstruct [:core]

  import TemporalEngine.Opts.ClientOpts, only: [connection_opts: 2]

  alias TemporalEngine.Opts.ClientOpts
  alias TemporalEngine.Runtime
  alias Temporal.CoreSdk.CoreRuntime

  require Record
  Record.defrecordp(:server_state, [:identity, :runtime, :core])

  @type t :: %__MODULE__{core: term()}

  @client_store Temporal.Application.client_store()

  @spec start_link({Runtime.t(), ClientOpts.connection_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({runtime, conn_opts, server_opts}) do
    GenServer.start_link(__MODULE__, {runtime, conn_opts}, server_opts)
  end

  @impl true
  @spec init({CoreRuntime.t(), ClientOpts.connection_opts()}) :: {:ok, t()} | {:error, term()}
  def init({runtime, conn_opts}) do
    Process.set_label({:core_client, connection_opts(conn_opts, :identity)})

    with {:ok, core_client} <- TemporalEngine.Runtime.create_client(runtime.core, conn_opts) do
      :ets.insert(
        @client_store,
        {{:core, connection_opts(conn_opts, :identity)}, core_client}
      )

      {:ok,
       server_state(
         identity: connection_opts(conn_opts, :identity),
         runtime: runtime,
         core: core_client
       )}
    end
  end

  def existing_for_identity(identity) do
    case :ets.lookup(@client_store, {:core, identity}) do
      [{_, core}] ->
        {:ok, %__MODULE__{core: core}}

      _ ->
        {:error, :core_client_not_online}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state),
    do: {:noreply, state}
end
