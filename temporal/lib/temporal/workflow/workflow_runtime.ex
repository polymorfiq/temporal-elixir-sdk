defmodule Temporal.Workflow.WorkflowRuntime do
  use GenStage

  require Record

  alias Temporal.Workflow.WorkflowExecution

  @active_retrieve_delay 300
  Record.defrecordp(:state, [
    :execution,
    threads: %{},
    locks: %{},
    unlocks: [],
    queued_commands: [],
    demand: 0
  ])

  @typep state ::
           record(:state,
             execution: pid(),
             threads: %{pid() => map()},
             unlocks: [{{pid(), reference()}, term()}],
             locks: %{pid() => {pid(), reference()}},
             queued_commands: [term()],
             demand: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(pid()) :: {:producer, state()}
  def init(exec) do
    Process.set_label(:runtime)

    {:producer, state(execution: exec)}
  end

  def register(pid, type, func, opts) do
    GenStage.cast(pid, {:register, type, func, opts})
  end

  def locked(pid, addr) do
    GenStage.cast(pid, {:locked, addr})
  end

  def unlocked(pid, addr, result) do
    GenStage.cast(pid, {:unlocked, addr, result})
  end

  def all_handlers_finished?(pid) do
    GenStage.call(pid, :all_handlers_finished?, :infinity)
  end

  def handle_call(:all_handlers_finished?, from, state) do
    GenStage.reply(from, Enum.count(state(state, :threads)) == 1)

    {:noreply, [], state}
  end

  def handle_cast({:register, type, func, opts}, state) do
    on_complete = Keyword.fetch!(opts, :on_complete)
    on_crash = Keyword.fetch!(opts, :on_crash)
    runtime = self()

    {pid, _} =
      spawn_monitor(fn ->
        try do
          resp = func.()
          send(runtime, {:finished, self(), resp})
        rescue
          exception ->
            send(runtime, {:crashed, self(), exception, __STACKTRACE__})
        end
      end)

    threads = state(state, :threads)

    {:noreply, [],
     state(state,
       threads:
         Map.put(threads, pid, %{
           type: type,
           on_complete: on_complete,
           on_crash: on_crash
         })
     )}
  end

  def handle_cast({:locked, addr}, state) do
    {pid, _} = addr
    locks = state(state, :locks)
    GenStage.async_info(self(), :retrieve_new_commands)

    {:noreply, [], state(state, locks: Map.put(locks, pid, addr))}
  end

  def handle_cast({:unlocked, addr, result}, state) do
    unlocks = state(state, :unlocks)
    {:noreply, [], state(state, unlocks: [{addr, result} | unlocks])}
  end

  def handle_info(:retrieve_new_commands, state(demand: 0) = state) do
    {:noreply, [], state}
  end

  def handle_info(:retrieve_new_commands, state) do
    threads = state(state, :threads)
    locks = state(state, :locks)
    unlocks = state(state, :unlocks)
    existing_demand = state(state, :demand)

    exec = state(state, :execution)
    unlocked_awaits = WorkflowExecution.unlocked_await_checks(exec)

    unlocked_awaits
    |> Enum.each(fn addr ->
      unlocked(self(), addr, :ok)
    end)

    cond do
      Enum.any?(unlocked_awaits) ->
        # We just unlocked some await calls. Let's let those execute first.
        send(self(), :retrieve_new_commands)
        {:noreply, [], state}

      Enum.count(threads) > 0 && Enum.count(threads) > Enum.count(locks) ->
        # There is still code running. Let's wait for it to finish.
        Process.send_after(self(), :retrieve_new_commands, @active_retrieve_delay)
        {:noreply, [], state}

      Enum.count(unlocks) > 0 ->
        # There are threads to be unlocked. Let's unlock one
        [{awaiter, result} | unlocks] = unlocks
        GenStage.reply(awaiter, result)
        {:noreply, [], state(state, unlocks: unlocks)}

      true ->
        # All threads are locked. No unlocks planned.
        queued_commands = state(state, :queued_commands)

        {:noreply, [queued_commands],
         state(state, demand: existing_demand - 1, queued_commands: [])}
    end
  end

  def handle_info({:finished, pid, response}, state) do
    threads = state(state, :threads)
    details = Map.fetch!(threads, pid)
    commands = details.on_complete.(response)
    GenStage.async_info(self(), :retrieve_new_commands)

    {:noreply, [], queue_commands(state, commands)}
  end

  def handle_info({:crashed, pid, exception, stacktrace}, state) do
    threads = state(state, :threads)
    details = Map.fetch!(threads, pid)
    commands = details.on_crash.(exception, stacktrace)
    GenStage.async_info(self(), :retrieve_new_commands)

    {:noreply, [], queue_commands(state, commands)}
  end

  def handle_info({:DOWN, _, :process, pid, :normal}, state) do
    threads = state(state, :threads)
    {:noreply, [], state(state, threads: Map.delete(threads, pid))}
  end

  @doc false
  @spec handle_demand(integer(), state()) :: {:noreply, list(), state()}
  def handle_demand(demand, state) when demand > 0 do
    existing_demand = state(state, :demand)

    if existing_demand == 0,
      do: GenStage.async_info(self(), :retrieve_new_commands)

    {:noreply, [], state(state, demand: existing_demand + demand)}
  end

  defp queue_commands(state, commands) do
    queued = state(state, :queued_commands)
    state(state, queued_commands: queued ++ commands)
  end
end
