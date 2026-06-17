defmodule Temporal.Worker.WorkerActivityManager do
  use GenServer

  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.Common

  alias Temporal.Worker
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Workflow.WorkflowActivityManager
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  Record.defrecordp(:activities_state, [:worker_id, :exec_ctx, registered: %{}])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(__MODULE__, exec_ctx, server_opts)
  end

  @spec init(ExecutionContext.t()) :: {:ok, pid()} | {:error, term()}
  def init(exec_ctx) do
    Process.set_label({:activity_manager, exec_ctx.worker_id})
    {:ok, activities_state(worker_id: exec_ctx.worker_id, exec_ctx: exec_ctx)}
  end

  def register(pid, activity_type, activity_fn),
    do: GenServer.cast(pid, {:register, activity_type, activity_fn})

  def process_task(pid, task),
    do: GenServer.call(pid, {:process_task, task}, :infinity)

  def handle_cast({:register, activity_type, activity_fn}, state) do
    registered = activities_state(state, :registered)

    {:noreply,
     activities_state(state, registered: Map.put(registered, activity_type, activity_fn))}
  end

  def handle_call({:process_task, {:error, "core_shutdown"}}, _from, state) do
    Logger.debug("Activity Manager received a 'core_shutdown' and is shutting down...")
    {:stop, :shutdown, state}
  end

  def handle_call(
        {:process_task,
         activity_task(task_token: task_token, variant: start_activity(activity_id: activity_id, activity_type: activity_type) = start)},
        _from,
        state
      ) do
    registered = activities_state(state, :registered)
    activity_fn = registered[activity_type]

    activity_arity =
      if activity_fn do
        {:arity, arity} = Function.info(activity_fn, :arity)
        arity
      end

    inputs = start_activity(start, :input) |> Enum.map(&Payload.value_from_record/1)
    workflow_execution(workflow_id: workflow_id, run_id: run_id) = start_activity(start, :workflow_execution)

    cond do
      !activity_fn ->
        {:reply, {:error, "Activity not found: #{inspect(activity_type)}"}, state}

      activity_arity != Enum.count(inputs) + 1 ->
        {:reply, {:error, "Activity of wrong arity: #{inspect(activity_type)}"}, state}

      true ->
        exec_ctx = activities_state(state, :exec_ctx)

        exec_ctx = %{
          exec_ctx
          | worker: %Worker{
              id: exec_ctx.worker_id,
              task_queue: exec_ctx.task_queue
            },
            workflow_id: workflow_id,
            run_id: run_id,
            activity_type: activity_type,
            activity_id: activity_id,
            activity_fn: activity_fn,
            activity_inputs: inputs,
            activity_task_token: task_token
        }

        {:reply, WorkflowActivityManager.start_or_restart_activity(exec_ctx), state}
    end
  end

  def handle_call(
        {:process_task, cancel_activity(reason: reason, details: details)},
        _from,
        state
      ) do
    {reason, details} |> IO.inspect(label: "cancel-activity")

    {:reply, :ok, state}
  end
end
