defmodule Temporal.Clients do
  use DynamicSupervisor

  defmacro __using__(_opts) do
    quote do
      use Supervisor
    end
  end

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, nil, [name: __MODULE__] ++ opts)
  end

  @impl true
  def init(_init_arg), do: DynamicSupervisor.init(strategy: :one_for_one)

  def add(mod, client_id, client_opts) do
    DynamicSupervisor.start_child(
      __MODULE__,
      %{
        id: client_id,
        start:
          {Supervisor, :start_link,
           [
             mod,
             {client_id, client_opts},
             [name: {:via, Registry, {Temporal.ClientRegistry, client_id}}]
           ]}
      }
    )
  end
end
