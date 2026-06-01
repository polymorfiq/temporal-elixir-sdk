defmodule Temporal.Worker.WorkflowActivityManager do
  use GenServer

  @workflows_table_name :_temporal_sdk_worker_workflows

  def start_link(worker, opts \\ []) do
    GenServer.start_link(__MODULE__, worker, opts)
  end

  @impl true
  def init(worker) do
    table =
      case :ets.whereis(@workflows_table_name) do
        :undefined -> :ets.new(@workflows_table_name, [:named_table, :set, :public])
        table_ref -> table_ref
      end

    {:ok, %{table: table, worker: worker}}
  end

  def execute_fn(worker, workflow, num_args) do
    case :ets.lookup(@workflows_table_name, {workflow, num_args, worker.instance_key}) do
      [] -> {:ok, nil}
      [{_, execute_fn}] -> {:ok, execute_fn}
    end
  end

  def add(pid, workflow_mod, execute_fn, num_args) do
    GenServer.cast(pid, {:add, workflow_mod, execute_fn, num_args})
  end

  @impl true
  def handle_cast({:add, workflow_mod, execute_fn, num_args}, state) do
    :ets.insert(
      state.table,
      {{workflow_mod, num_args, state.worker.instance_key},
       Function.capture(workflow_mod, execute_fn, num_args)}
    )

    {:noreply, state}
  end
end
