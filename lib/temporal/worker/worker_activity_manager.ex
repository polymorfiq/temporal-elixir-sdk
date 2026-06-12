defmodule Temporal.Worker.WorkerActivityManager do
  use GenServer

  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Workflow.WorkflowActivityManager

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

  def process_task(pid, {:activity_task, variant, token}),
    do: GenServer.call(pid, {:process_task, variant, token}, :infinity)

  def handle_cast({:register, activity_type, activity_fn}, state) do
    registered = activities_state(state, :registered)

    {:noreply,
     activities_state(state, registered: Map.put(registered, activity_type, activity_fn))}
  end

  def handle_call(
        {:process_task, {:start, activity_id, activity_type, opts}, token},
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

    input = opts.input
    {:execution, workflow_id, run_id} = opts.workflow_execution

    cond do
      !activity_fn ->
        {:reply, {:error, "Activity not found: #{inspect(activity_type)}"}, state}

      activity_arity != Enum.count(input) + 1 ->
        {:reply, {:error, "Activity of wrong arity: #{inspect(activity_type)}"}, state}

      true ->
        exec_ctx = activities_state(state, :exec_ctx)

        resp =
          with {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id) do
            exec_ctx = %{
              exec_ctx
              | worker: worker,
                workflow_id: workflow_id,
                run_id: run_id,
                activity_type: activity_type,
                activity_id: activity_id,
                activity_fn: activity_fn,
                activity_start: opts,
                activity_task_token: token
            }

            WorkflowActivityManager.start_or_restart_activity(exec_ctx)
          end

        {:reply, resp, state}
    end
  end

  def handle_call({:process_task, {:cancel, reason, details}, _}, _from, state) do
    {reason, details} |> IO.inspect(label: "cancel-activity")

    {:reply, :ok, state}
  end
end
