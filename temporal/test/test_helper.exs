ExUnit.start()
TemporalEngine.Mock.Storage.initialize!()

defmodule WorkflowHelpers do
  use ExUnit.Case

  alias TemporalEngine.Mock.Worker, as: WorkerMock

  def setup_client(ctx) do
    alias Temporal.{Client, Runtime}

    # Connect to Temporal Server
    {:ok, runtime} =
      Runtime.with_id("#{System.unique_integer()}", engine: TemporalEngine.Mock.Engine)

    {:ok, client} = Client.new("localhost:7233", identity: ctx.task_queue, runtime: runtime)

    Map.put(ctx, :client, client)
  end

  def setup_worker(ctx) do
    alias Temporal.Worker
    worker_opts = Map.get(ctx, :worker_opts, [])

    worker_resp =
      Worker.new(
        ctx.client,
        [
          task_queue: ctx.task_queue,
          max_cached_workflows: 100,
          nonsticky_to_sticky_poll_ratio: 0.5,
          versioning_strategy: [
            version: [build_id: "0.1.0", deployment_name: "elixir-sdk"],
            use_worker_versioning: false,
            default_versioning_behavior: nil
          ],
          task_types: [
            enable_workflows: true,
            enable_local_activities: true,
            enable_remote_activities: true,
            enable_nexus: false
          ],
          tuner: [
            workflow_slot_supplier: [size: 10],
            activity_slot_supplier: [size: 10],
            local_activity_slot_supplier: [size: 10]
          ]
        ] ++ worker_opts
      )

    with {:ok, worker} <- worker_resp do
      :ok =
        Worker.register_workflows(worker, [
          TestWorkflows.ActivitiesWithAwait,
          TestWorkflows.TimerWithAwait,
          TestWorkflows.Queries,
          TestWorkflows.Determinism
        ])

      :ok =
        Worker.register_workflows(worker, [
          {TestWorkflows.Activities, :workflow_with_long_activity}
        ])

      {:ok, mocked_worker} = WorkerMock.mocked_for_id(Temporal.Worker.id(worker))

      %{worker: mocked_worker}
    else
      {:error, err} -> {:error, err}
    end
  end
end
