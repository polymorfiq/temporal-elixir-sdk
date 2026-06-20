ExUnit.start()

defmodule WorkflowHelpers do
  use ExUnit.Case

  def setup_client(ctx) do
    alias Temporal.{Client, Runtime}

    # Connect to Temporal Server
    {:ok, runtime} = Runtime.with_id(System.unique_integer())
    {:ok, client} = Client.new("localhost:7233", [identity: ctx.task_queue], runtime: runtime)
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
          versioning_strategy: [
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
            workflow_slot_supplier: [size: 10],
            activity_slot_supplier: [size: 10],
            local_activity_slot_supplier: [size: 10]
          ]
        ] ++ worker_opts
      )

    with {:ok, worker} <- worker_resp do
      on_exit(fn -> Worker.shutdown(worker) end)
      %{queue: queue, worker: worker}
    else
      {:error, err} -> {:error, err}
    end
  end
end
