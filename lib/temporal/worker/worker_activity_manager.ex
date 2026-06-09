defmodule Temporal.Worker.WorkerActivityManager do
  use GenServer

  alias Temporal.ActivityRegistry
  alias Temporal.Supervisor.ActivitySupervisor
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor

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
    do: GenServer.call(pid, {:process_task, task.variant, task}, :infinity)

  def handle_cast({:register, activity_type, activity_fn}, state) do
    registered = activities_state(state, :registered)

    {:noreply,
     activities_state(state, registered: Map.put(registered, activity_type, activity_fn))}
  end

  def handle_call({:process_task, {:start, start}, task}, _from, state) do
    registered = activities_state(state, :registered)
    activity_fn = registered[start.activity_type]

    activity_arity =
      if activity_fn do
        {:arity, arity} = Function.info(activity_fn, :arity)
        arity
      end

    cond do
      !activity_fn ->
        {:reply, {:error, "Activity not found: #{inspect(start.activity_type)}"}, state}

      activity_arity != Enum.count(start.input) + 1 ->
        {:reply, {:error, "Activity of wrong arity: #{inspect(start.activity_type)}"}, state}

      true ->
        exec_ctx = activities_state(state, :exec_ctx)

        resp =
          with {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id) do
            exec_ctx = %{
              exec_ctx
              | worker: worker,
                activity_type: start.activity_type,
                activity_id: start.activity_id,
                activity_fn: activity_fn,
                activity_start: start,
                activity_task_token: task.task_token
            }

            start_or_restart_activity(exec_ctx)
          end

        {:reply, resp, state}
    end
  end

  def handle_call({:process_task, {:cancel, cancel}, _}, _from, state) do
    cancel |> IO.inspect(label: "cancel-activity")

    {:reply, :ok, state}
  end

  @spec process_name(activity_id :: String.t()) :: {:via, atom(), term()}
  def process_name(activity_id) do
    {:via, Registry, {ActivityRegistry, {:activity, activity_id}}}
  end

  @spec start_or_restart_activity(ExecutionContext.t()) :: :ok | {:error, term()}
  def start_or_restart_activity(exec_ctx) do
    with {:ok, activities_sup} <- WorkerSupervisor.activities_sup_for_id(exec_ctx.worker_id) do
      DynamicSupervisor.start_child(
        activities_sup,
        Supervisor.child_spec(
          {ActivitySupervisor,
           {
             exec_ctx,
             [name: ActivitySupervisor.process_name(exec_ctx.activity_id)]
           }},
          restart: :temporary
        )
      )
      |> case do
        {:ok, _} ->
          :ok

        {:error, {:already_started}} ->
          ActivitySupervisor.stop_activity(exec_ctx.run_id, wait: true)
          start_or_restart_activity(exec_ctx)

        {:error, err} ->
          {:error, err}
      end
    end
  end
end
