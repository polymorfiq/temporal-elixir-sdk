ExUnit.start()
TemporalEngine.Mock.Storage.initialize!()

defmodule WorkflowHelpers do
  use ExUnit.Case

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
        [task_queue: ctx.task_queue] ++ worker_opts
      )

    with {:ok, worker} <- worker_resp do
      on_exit(fn -> Worker.shutdown(worker) end)
      %{worker: worker}
    else
      {:error, err} -> {:error, err}
    end
  end
end
