defmodule Temporal.CoreSdk.CoreClient do
  use GenServer
  defstruct [:core]

  import TemporalEngine.Runtime

  alias TemporalEngine.Runtime
  alias Temporal.CoreSdk.CoreRuntime

  require Record
  Record.defrecordp(:server_state, [:identity, :runtime, :core])

  @type t :: %__MODULE__{core: term()}

  @client_store Temporal.Application.client_store()

  @spec start_link({Runtime.t(), Runtime.client_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({runtime, opts, server_opts}) do
    GenServer.start_link(__MODULE__, {runtime, opts}, server_opts)
  end

  @impl true
  @spec init({CoreRuntime.t(), Runtime.client_opts()}) :: {:ok, t()} | {:error, term()}
  def init({runtime, opts}) do
    Process.set_label({:core_client, client_opts(opts, :identity)})

    with {:ok, core_client} <- TemporalEngine.Runtime.create_client(runtime.core, opts) do
      :ets.insert(@client_store, {{:core, client_opts(opts, :identity)}, core_client})

      {:ok,
       server_state(identity: client_opts(opts, :identity), runtime: runtime, core: core_client)}
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
