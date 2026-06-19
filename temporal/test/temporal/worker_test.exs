defmodule Temporal.WorkerTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Runtime
  alias Temporal.TaskQueue
  alias Temporal.Worker

  setup_all [:setup_create_task_queue]
  setup [:stop_all_workers]

  test "initializes for a task queue", %{queue: queue} do
    [
      max_cached_workflows: 100,
      nonsticky_to_sticky_poll_ratio: 0.5,
      versioning_strategy: [
        version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
        use_worker_versioning: true,
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
    ]

    require Elixir.TemporalEngine.Data.Common

    assert {:ok, _worker} =
             Worker.new(queue,
               nonsticky_to_sticky_poll_ratio: 0.5,
               tuner: [
                 workflow_slot_supplier: [size: 10],
                 activity_slot_supplier: [size: 10],
                 local_activity_slot_supplier: [size: 10]
               ],
               task_types: [
                 enable_workflows: true,
                 enable_local_activities: true,
                 enable_remote_activities: true,
                 enable_nexus: false
               ],
               versioning_strategy: [
                 version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
                 use_worker_versioning: true,
                 default_versioning_behavior: :unspecified
               ],
               max_cached_workflows: 100
             )
  end

  test "shuts down in a reasonable time", ctx do
    {:ok, worker} =
      Worker.new(ctx.queue,
        max_cached_workflows: 100,
        nonsticky_to_sticky_poll_ratio: 0.5,
        versioning_strategy: [
          version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
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
      )

    parent = self()

    spawn_link(fn ->
      send(parent, {:shutdown_result, Worker.shutdown(worker)})
    end)

    assert_receive {:shutdown_result, :ok}, 300
  end

  test "stops worker supervisor when Core Worker is shutdown", ctx do
    {:ok, worker} =
      Worker.new(ctx.queue,
        max_cached_workflows: 100,
        nonsticky_to_sticky_poll_ratio: 0.5,
        versioning_strategy: [
          version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
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
      )

    sup_pid = Worker.worker_supervisor_pid(worker.id)
    ref = Process.monitor(sup_pid)

    Worker.shutdown(worker)

    assert_receive {:DOWN, ^ref, :process, ^sup_pid, _}, 1000
  end

  test "shuts down Core Worker when supervisor is stopped", ctx do
    {:ok, worker} =
      Worker.new(ctx.queue,
        max_cached_workflows: 100,
        nonsticky_to_sticky_poll_ratio: 0.5,
        versioning_strategy: [
          version: [build_id: "#{__MODULE__}", deployment_name: "elixir-test"],
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
      )

    {:ok, _} = CoreWorker.existing_for_id(worker.id)

    Worker.stop_with_id(worker.id)
    assert {:error, :core_worker_not_online} = CoreWorker.existing_for_id(worker.id)
  end

  defp stop_all_workers(ctx) do
    on_exit(fn ->
      Client.stop_all_workers(ctx.client)
    end)
  end

  defp setup_create_task_queue(ctx) do
    {:ok, runtime} = Temporal.Runtime.with_id("#{__MODULE__}")
    {:ok, client} = Client.new("localhost:7233", [identity: "#{__MODULE__}"], runtime: runtime)
    on_exit(fn -> Client.stop(client) end)
    on_exit(fn -> Runtime.stop(runtime) end)

    task_queue = TaskQueue.new(client, "#{__MODULE__}")
    Map.merge(ctx, %{queue: task_queue, client: client})
  end
end
