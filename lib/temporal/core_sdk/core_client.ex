defmodule Temporal.CoreSdk.CoreClient do
  use GenServer
  defstruct [:core]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.ClientOpts

  require Record
  Record.defrecordp(:server_state, [:identity, :runtime, :core])

  @type t :: %__MODULE__{core: term()}

  @client_store Temporal.Application.client_store()

  @spec start_link({CoreRuntime.t(), ClientOpts.t(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({runtime, opts, server_opts}) do
    GenServer.start_link(__MODULE__, {runtime, opts}, server_opts)
  end

  @impl true
  @spec init({CoreRuntime.t(), ClientOpts.t()}) :: {:ok, t()} | {:error, term()}
  def init({runtime, opts}) do
    parent = self()

    Process.set_label({:core_client, opts.identity})

    try do
      :ets.new(@client_store, [:set, :public, :named_table, read_concurrency: true])
    rescue
      ArgumentError ->
        # Table already exists
        :ok
    end

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_client(runtime.core, opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize client from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, client} ->
            :ets.insert(@client_store, {{:core, opts.identity}, client})
            send(parent, {self(), {:ok, client}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    client_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    with {:ok, core} <- client_resp do
      {:ok, server_state(identity: opts.identity, runtime: runtime, core: core)}
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
