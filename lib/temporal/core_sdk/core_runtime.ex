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

  @runtime_store Temporal.Application.runtime_store()

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

    try do
      :ets.new(@runtime_store, [:set, :public, :named_table, read_concurrency: true])
    rescue
      ArgumentError ->
        # Table already exists
        :ok
    end

    with {:ok, core} <- CoreSdk._create_runtime(runtime_opts) do
      :ets.insert(@runtime_store, {{:core, runtime_id}, core})

      {:ok, server_state(id: runtime_id, core: core)}
    end
  end

  def existing_for_id(runtime_id) do
    case :ets.lookup(@runtime_store, {:core, runtime_id}) do
      [{_, core}] ->
        {:ok, %__MODULE__{core: core}}

      _ ->
        {:error, :core_runtime_not_online}
    end
  end
end
