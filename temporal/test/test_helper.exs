ExUnit.start()
TemporalEngine.Mock.Storage.initialize!()

defmodule WorkflowHelpers do
  use ExUnit.Case

  alias TemporalEngine.Mock.Worker, as: WorkerMock

  def setup_client(ctx) do
    alias Temporal.{Client, Runtime}

    # Connect to Temporal Server
    {:ok, runtime} = Runtime.with_id(System.unique_integer(), engine: TemporalEngine.Mock.Engine)
    {:ok, client} = Client.new("localhost:7233", runtime: runtime, identity: ctx.task_queue)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    Map.put(ctx, :client, client)
  end

  def setup_worker(ctx) do
    alias Temporal.{TaskQueue, Worker}
    queue = TaskQueue.new(ctx.client, ctx.task_queue)

    worker_opts = Map.get(ctx, :worker_opts, [])

    worker_resp =
      Worker.new(
        queue,
        [
          max_cached_workflows: 100,
          deployment_options: [
            version: [build_id: "0.1.0", deployment_name: "elixir-sdk"],
            use_worker_versioning: false,
            default_versioning_behavior: nil
          ],
          task_types: [
            enable_workflows: true,
            enable_local_activities: true,
            enable_remote_activities: true
          ],
          tuner: [
            workflow_slot_supplier: [fixed_size: 10],
            activity_slot_supplier: [fixed_size: 10],
            local_activity_slot_supplier: [fixed_size: 10]
          ]
        ] ++ worker_opts
      )

    with {:ok, worker} <- worker_resp do
      :ok = Worker.register_workflow(worker, TestWorkflows.ActivitiesWithAwait)
      :ok = Worker.register_workflow(worker, TestWorkflows.TimerWithAwait)
      {:ok, mocked_worker} = WorkerMock.mocked_for_id(worker.id)

      on_exit(fn -> Worker.shutdown(worker) end)
      %{queue: queue, worker: worker, mocked_worker: mocked_worker}
    else
      {:error, err} -> {:error, err}
    end
  end
end