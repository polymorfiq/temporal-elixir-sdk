defmodule Temporal.Workflow.WorkflowFlowController do
  use GenServer

  require Logger
  require Record

  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow.WorkflowProgressReporter

  Record.defrecordp(:flow_state, [
    :id,
    :run_id,
    awaiting_activities: %{},
    activity_results: %{},
    awaiting_timers: %{},
    fired_timers: %{}
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    Process.set_label({:workflow_flow_control, exec_ctx.run_id})
    {:ok, flow_state(id: exec_ctx.run_id, run_id: exec_ctx.run_id)}
  end

  def activity_tasks_resolved(pid, results),
    do: GenServer.call(pid, {:activity_tasks_resolved, results})

  def timers_resolved(pid, timer_ids), do: GenServer.call(pid, {:timers_resolved, timer_ids})

  def await_timer(pid, _run_id, timer_id) do
    GenServer.call(pid, {:await_timer, timer_id}, :infinity)
  end

  def await_activity_result(pid, _run_id, activity_id) do
    GenServer.call(pid, {:await_activity_result, activity_id}, :infinity)
  end

  def will_resolutions_unlock?(run_id, activity_ids) do
    with {:ok, flow} <- WorkflowSupervisor.flow_control_pid(run_id) do
      GenServer.call(flow, {:will_resolutions_unlock?, activity_ids}, :infinity)
    end
  end

  def handle_call({:activity_tasks_resolved, results}, _, state) do
    awaiting = flow_state(state, :awaiting_activities)
    activity_ids = Enum.map(results, fn {activity_id, _} -> activity_id end)

    {was_awaiting, still_awaiting} = Map.split(awaiting, activity_ids)

    was_awaiting
    |> Enum.map(fn {activity_id, awaiting} ->
      result = Enum.find_value(results, fn {id, output} -> id == activity_id && output end)

      Enum.each(awaiting, fn awaiter ->
        Logger.debug("Awaiting activity (Unlocked): #{inspect(awaiter)} - #{activity_id}")
        GenServer.reply(awaiter, result)
      end)
    end)

    activity_results = Map.merge(flow_state(state, :activity_results), Map.new(results))

    {:reply, :ok,
     flow_state(state, awaiting_activities: still_awaiting, activity_results: activity_results)}
  end

  def handle_call({:timers_resolved, timer_ids}, _, state) do
    awaiting = flow_state(state, :awaiting_timers)

    {was_awaiting, still_awaiting} = Map.split(awaiting, timer_ids)

    was_awaiting
    |> Enum.map(fn {timer_id, awaiting} ->
      Enum.each(awaiting, fn awaiter ->
        Logger.debug("Awaiting timer (Unlocked): #{inspect(awaiter)} - #{timer_id}")
        GenServer.reply(awaiter, :ok)
      end)
    end)

    fired_timers =
      Enum.reduce(timer_ids, flow_state(state, :fired_timers), fn timer_id, acc ->
        Map.put(acc, timer_id, true)
      end)

    {:reply, :ok, flow_state(state, awaiting_timers: still_awaiting, fired_timers: fired_timers)}
  end

  def handle_call({:will_resolutions_unlock?, activity_ids}, _from, state) do
    awaiting = flow_state(state, :awaiting_activities)
    is_locked? = Enum.any?(awaiting)
    still_locked? = Map.drop(awaiting, activity_ids) |> Enum.any?()

    {:reply, {:ok, {is_locked?, is_locked? && !still_locked?}}, state}
  end

  def handle_call({:await_activity_result, activity_id}, from, state) do
    seen_results = flow_state(state, :activity_results)
    run_id = flow_state(state, :run_id)

    if Map.has_key?(seen_results, activity_id) do
      Logger.debug("Awaiting activity (Skipped): #{inspect(from)} - #{activity_id}")
      {:reply, seen_results[activity_id], state}
    else
      Logger.debug("Awaiting activity (Locked): #{inspect(from)} - #{activity_id}")
      WorkflowProgressReporter.send_heartbeat_for_id(run_id)
      {:noreply, append_activity_results_awaiter(state, activity_id, from)}
    end
  end

  def handle_call({:await_timer, timer_id}, from, state) do
    fired_timers = flow_state(state, :fired_timers)
    run_id = flow_state(state, :run_id)

    if Map.has_key?(fired_timers, timer_id) do
      Logger.debug("Awaiting timer (Skipped): #{inspect(from)} - #{timer_id}")
      {:reply, fired_timers[timer_id], state}
    else
      Logger.debug("Awaiting timer (Locked): #{inspect(from)} - #{timer_id}")
      WorkflowProgressReporter.send_heartbeat_for_id(run_id)
      {:noreply, append_timer_awaiter(state, timer_id, from)}
    end
  end

  defp append_activity_results_awaiter(state, activity_id, from) do
    awaiting = flow_state(state, :awaiting_activities)
    awaiters = Map.get(awaiting, activity_id, [])

    awaiting = Map.put(awaiting, activity_id, [from | awaiters])
    flow_state(state, awaiting_activities: awaiting)
  end

  defp append_timer_awaiter(state, timer_id, from) do
    awaiting = flow_state(state, :awaiting_timers)
    awaiters = Map.get(awaiting, timer_id, [])

    awaiting = Map.put(awaiting, timer_id, [from | awaiters])
    flow_state(state, awaiting_timers: awaiting)
  end
end
