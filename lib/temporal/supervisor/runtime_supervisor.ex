defmodule Temporal.Supervisor.RuntimeSupervisor do
  use Supervisor

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.Supervisor.ClientList
  alias Temporal.RuntimeRegistry

  @spec core_for_id(runtime_id :: CoreRuntime.runtime_id()) :: {:ok, term()} | {:error, term()}
  def core_for_id(runtime_id) do
    CoreRuntime.get_core(via_registry({:core, runtime_id}))
  end

  def start_link({{runtime_id, runtime_opts}, opts}),
    do: Supervisor.start_link(__MODULE__, {runtime_id, runtime_opts}, opts)

  @impl true
  def init({runtime_id, runtime_opts}) do
    children = [
      {CoreRuntime,
       [
         runtime_id: runtime_id,
         runtime_opts: runtime_opts,
         name: via_registry({:core, runtime_id})
       ]},
      {ClientList, [name: via_registry({:clients, runtime_id})]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  defp via_registry(name),
    do: {:via, Registry, {RuntimeRegistry, name}}
end
