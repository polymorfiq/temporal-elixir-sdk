defmodule Temporal.Runtime do
  defstruct [:id]

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.Runtimes
  alias Temporal.RuntimeRegistry
  alias Temporal.Supervisor.RuntimeSupervisor

  @type t() :: %__MODULE__{id: CoreRuntime.runtime_id()}

  @global_name :_global

  @spec with_id(CoreRuntime.runtime_id(), CoreRuntime.runtime_opts()) ::
          {:ok, t()} | {:error, term()}
  def with_id(runtime_id, opts \\ []) do
    reg_name = via_registry({:runtime, runtime_id})

    if _pid = GenServer.whereis(reg_name) do
      {:ok, %__MODULE__{id: runtime_id}}
    else
      child_started =
        DynamicSupervisor.start_child(
          Runtimes,
          Supervisor.child_spec(
            {RuntimeSupervisor, opts ++ [name: reg_name, runtime_id: runtime_id, shutdown: 60_000]},
            restart: :transient
          )
        )

      with {:ok, _pid} <- child_started do
        {:ok, %__MODULE__{id: runtime_id}}
      else
        {:error, {:already_started, _pid}} ->
          {:ok, %__MODULE__{id: runtime_id}}

        {:error, err} ->
          {:error, err}
      end
    end
  end

  def stop(runtime) do
    if sup = GenServer.whereis({:via, Registry, {RuntimeRegistry, runtime.id}}) do
      Supervisor.stop(sup, :shutdown, :infinity)
    else
      {:error, :runtime_already_stopped}
    end
  end

  @spec global() :: {:ok, t()} | {:error, term()}
  def global, do: with_id(@global_name, heartbeat_interval_secs: 30)

  defp via_registry(name),
    do: {:via, Registry, {RuntimeRegistry, name}}
end
