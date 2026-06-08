defmodule Temporal.Workflow.WorkflowFlowController do
  use GenServer

  require Logger
  require Record

  Record.defrecordp(:flow_state, [
    :id,
    :workflow_id,
    awaiting_activities: %{},
    activity_results: %{}
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    {:ok, flow_state(id: exec_ctx.run_id, workflow_id: exec_ctx.workflow_id)}
  end

  @spec activity_task_resolved(
          pid(),
          activity_id :: String.t(),
          result :: :ok | {:ok, term()} | {:error, term()}
        ) :: :ok
  def activity_task_resolved(pid, activity_id, result),
    do: GenServer.cast(pid, {:activity_task_resolved, activity_id, result})

  def await_activity_result(pid, activity_id),
    do: GenServer.call(pid, {:await_activity_result, activity_id}, :infinity)

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

  def handle_call({:await_activity_result, activity_id}, from, state) do
    seen_results = flow_state(state, :activity_results)

    if Map.has_key?(seen_results, activity_id) do
      {:reply, seen_results[activity_id], state}
    else
      {:noreply, append_activity_results_awaiter(state, activity_id, from)}
    end
  end

  defp append_activity_results_awaiter(state, activity_id, from) do
    awaiting = flow_state(state, :awaiting_activities)
    awaiters = Map.get(awaiting, activity_id, [])

    awaiting = Map.put(awaiting, activity_id, [from | awaiters])
    flow_state(state, awaiting_activities: awaiting)
  end
end
