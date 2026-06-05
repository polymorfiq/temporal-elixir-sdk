defmodule Temporal.CoreSdk.CoreRuntime do
  use GenServer
  defstruct [:core]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.RuntimeOpts

  require Record
  Record.defrecordp(:server_state, [:id, :core])

  @type runtime_id() :: String.t() | atom()
  @type runtime_opts() :: [
          {:runtime_id, runtime_id()}
          | {:heartbeat_interval_secs, pos_integer()}
        ]
  @type t :: %__MODULE__{core: term()}

  @spec start_link(runtime_opts() | keyword()) :: {:ok, pid()} | {:error, term()}
  def start_link(opts) do
    {runtime_opts, server_opts} = Keyword.split(opts, [:runtime_id, :heartbeat_interval_secs])

    cond do
      !runtime_opts[:runtime_id] ->
        {:error, {:required_option, :runtime_id}}

      true ->
        GenServer.start_link(__MODULE__, runtime_opts, server_opts)
    end
  end

  @impl true
  @spec init(runtime_opts()) :: {:ok, pid} | {:error, term()}
  def init(opts) do
    runtime_opts = %RuntimeOpts{
      heartbeat_interval_secs: Keyword.get(opts, :heartbeat_interval_secs)
    }

    runtime_id = Keyword.fetch!(opts, :runtime_id)
    Process.set_label({:runtime, runtime_id})

    with {:ok, core} <- CoreSdk._create_runtime(runtime_opts) do
      {:ok, server_state(id: runtime_id, core: core)}
    end
  end

  def get_core(pid), do: GenServer.call(pid, :get_core)
  def get_id(pid), do: GenServer.call(pid, :get_id)

  @impl true
  def handle_call(:get_core, _from, state),
    do: {:reply, {:ok, %__MODULE__{core: server_state(state, :core)}}, state}

  @impl true
  def handle_call(:get_id, _from, state), do: {:reply, {:ok, server_state(state, :id)}, state}
end
