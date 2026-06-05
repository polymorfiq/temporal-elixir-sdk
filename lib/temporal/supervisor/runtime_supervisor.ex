defmodule Temporal.Supervisor.RuntimeSupervisor do
  use Supervisor

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.Supervisor.ClientList
  alias Temporal.RuntimeRegistry

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, opts)
  end

  @impl true
  def init(opts) do
    runtime_id = Keyword.fetch!(opts, :runtime_id)
    {runtime_opts, _opts} = Keyword.split(opts, [:runtime_id, :heartbeat_interval_secs])

    children = [
      {CoreRuntime, runtime_opts ++ [name: via_registry({:core, runtime_id})]},
      {ClientList, [name: via_registry({:clients, runtime_id})]}
    ]

    Process.set_label({:runtime_sup, runtime_id})

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec core_for_id(runtime_id :: CoreRuntime.runtime_id()) :: {:ok, term()} | {:error, term()}
  def core_for_id(runtime_id),
    do: CoreRuntime.get_core(via_registry({:core, runtime_id}))

  @spec clients_sup_for_id(runtime_id :: CoreRuntime.runtime_id()) ::
          {:ok, pid()} | {:error, term()}
  def clients_sup_for_id(runtime_id) do
    if pid = GenServer.whereis(via_registry({:clients, runtime_id})) do
      {:ok, pid}
    else
      {:error, "Client list not found for runtime (#{inspect(runtime_id)})"}
    end
  end

  defp via_registry(name),
    do: {:via, Registry, {RuntimeRegistry, name}}
end
