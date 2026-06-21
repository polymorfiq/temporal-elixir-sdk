defmodule Temporal.Comms.Pollers.WorkflowActivationPoller do
  use GenStage

  alias TemporalEngine.Worker

  require Logger
  require Record

  Record.defrecordp(:poll_state, [:worker, poll_pid: nil, poll_ref: nil, demand: 0])

  def start_link(worker), do: GenStage.start_link(__MODULE__, worker)

  @spec init(TemporalEngine.Worker.t()) :: {:ok, pid()} | {:error, term()}
  def init(worker) do
    Process.set_label(:workflow_activation_poller)
    {:producer, poll_state(worker: worker)}
  end

  def handle_demand(demand, state) when demand > 0 do
    existing_demand = poll_state(state, :demand)
    GenStage.async_info(self(), :poll_if_not_already)

    {:noreply, [], poll_state(state, demand: existing_demand + demand)}
  end

  def handle_info(:poll_if_not_already, poll_state(poll_pid: poll_pid) = state)
      when is_pid(poll_pid) do
    {:noreply, [], state}
  end

  def handle_info(:poll_if_not_already, poll_state(demand: 0) = state) do
    {:noreply, [], state}
  end

  def handle_info(:poll_if_not_already, state) do
    poller = self()

    {poll_pid, poll_ref} =
      spawn_monitor(fn ->
        worker = poll_state(state, :worker)
        Logger.debug("Polling workflow activations... (#{TemporalEngine.Worker.id(worker)})")

        with {:ok, activation} <- Worker.poll_workflow_activation(worker) do
          send(poller, {self(), {:ok, activation}})
        else
          {:error, "core_shutdown"} ->
            send(poller, {self(), :shutdown_requested})

          {:error, err} ->
            send(poller, {self(), {:error, err}})
        end
      end)

    {:noreply, [], poll_state(state, poll_pid: poll_pid, poll_ref: poll_ref)}
  end

  def handle_info({sender, {:ok, nil}}, poll_state(poll_pid: sender) = state) do
    {:noreply, [], state}
  end

  def handle_info({sender, {:ok, activation}}, poll_state(poll_pid: sender) = state) do
    demand = poll_state(state, :demand)
    {:noreply, [activation], poll_state(state, demand: demand - 1)}
  end

  def handle_info({sender, :shutdown_requested}, poll_state(poll_pid: sender) = state) do
    GenStage.async_info(self(), :shutdown_requested)
    {:noreply, [], poll_state(state, poll_pid: nil)}
  end

  def handle_info(:shutdown_requested, state) do
    Logger.debug("Shutdown requested for Workflow Activation Poller... Exiting...")
    {:stop, :normal, state}
  end

  def handle_info({:DOWN, poll_ref, :process, _, :normal}, poll_state(poll_ref: poll_ref) = state) do
    if poll_state(state, :demand) > 0,
      do: GenStage.async_info(self(), :poll_if_not_already)

    Logger.debug(
      "Workflow Activation poll finished! Starting over! (Demand: #{poll_state(state, :demand)})"
    )

    {:noreply, [], poll_state(state, poll_pid: nil, poll_ref: nil)}
  end
end
