defmodule Temporal.Workflow.WorkflowFlowController do
  use GenServer

  require Logger
  require Record

  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Supervisor.WorkflowSupervisor

  Record.defrecordp(:flow_state, [
    :id,
    :run_id,
    awaiting_activities: %{},
    activity_results: %{},
    progress_lock_token: 0,
    progress_lock_given: false,
    awaiting_progress_lock: []
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

  @spec activity_task_resolved(
          pid(),
          activity_id :: String.t(),
          result :: :ok | {:ok, term()} | {:error, term()}
        ) :: :ok
  def activity_task_resolved(pid, activity_id, result),
    do: GenServer.cast(pid, {:activity_task_resolved, activity_id, result})

  @spec acquire_progress_lock(run_id :: String.t()) :: {:ok, term()} | {:error, term()}
  def acquire_progress_lock(run_id) do
    with {:ok, flow} <- WorkflowSupervisor.flow_control_pid(run_id) do
      GenServer.call(flow, :acquire_progress_lock, :infinity)
    end
  end

  @spec release_progress_lock(run_id :: String.t(), lock_token :: term()) ::
          :ok | {:error, term()}
  def release_progress_lock(run_id, token) do
    with {:ok, flow} <- WorkflowSupervisor.flow_control_pid(run_id) do
      GenServer.call(flow, {:release_progress_lock, token}, :infinity)
    end
  end

  def await_activity_result(pid, run_id, activity_id) do
    WorkflowProgressReporter.send_heartbeat_for_id(run_id)
    GenServer.call(pid, {:await_activity_result, activity_id}, :infinity)
  end

  def handle_cast({:activity_task_resolved, activity_id, result}, state) do
    awaiting = flow_state(state, :awaiting_activities)

    awaiting =
      if Map.has_key?(awaiting, activity_id) do
        Enum.each(awaiting[activity_id], fn awaiter ->
          GenServer.reply(awaiter, result)
        end)

        Map.delete(awaiting, activity_id)
      else
        awaiting
      end

    activity_results = Map.put(flow_state(state, :activity_results), activity_id, result)

    {:noreply,
     flow_state(state, awaiting_activities: awaiting, activity_results: activity_results)}
  end

  def handle_call(:acquire_progress_lock, from, state) do
    if flow_state(state, :progress_lock_given) do
      already_waiting = flow_state(state, :awaiting_progress_lock)
      {:noreply, flow_state(state, awaiting_progress_lock: already_waiting ++ [from])}
    else
      curr_token = flow_state(state, :progress_lock_token)
      {:reply, {:ok, curr_token}, flow_state(state, progress_lock_given: true)}
    end
  end

  def handle_call({:release_progress_lock, token}, _from, state) do
    awaiting = flow_state(state, :awaiting_progress_lock)
    curr_token = flow_state(state, :progress_lock_token)

    cond do
      curr_token != token ->
        {:error, "Wrong token. Given #{token} when it is #{curr_token}"}

      Enum.count(awaiting) == 0 ->
        {:reply, :ok,
         flow_state(state, progress_lock_given: false, progress_lock_token: curr_token + 1),
         {:continue, :maybe_heartbeat}}

      true ->
        new_token = curr_token + 1
        [first_in_line | rest] = awaiting
        GenServer.reply(first_in_line, {:ok, new_token})

        {:reply, :ok,
         flow_state(state, awaiting_progress_lock: rest, progress_lock_token: new_token)}
    end
  end

  def handle_call({:await_activity_result, activity_id}, from, state) do
    seen_results = flow_state(state, :activity_results)

    if Map.has_key?(seen_results, activity_id) do
      {:reply, seen_results[activity_id], state}
    else
      {:noreply, append_activity_results_awaiter(state, activity_id, from)}
    end
  end

  def handle_continue(:maybe_heartbeat, state) do
    awaiting_activities = flow_state(state, :awaiting_activities)
    run_id = flow_state(state, :run_id)

    if Enum.count(Map.keys(awaiting_activities)) > 0 do
      # They are still stuck and will have no events
      WorkflowProgressReporter.send_heartbeat_for_id(run_id)
    end

    {:noreply, state}
  end

  defp append_activity_results_awaiter(state, activity_id, from) do
    awaiting = flow_state(state, :awaiting_activities)
    awaiters = Map.get(awaiting, activity_id, [])

    awaiting = Map.put(awaiting, activity_id, [from | awaiters])
    flow_state(state, awaiting_activities: awaiting)
  end
end
