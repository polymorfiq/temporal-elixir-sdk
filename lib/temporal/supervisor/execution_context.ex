defmodule Temporal.Supervisor.ExecutionContext do
  alias Temporal.TaskQueue

  defstruct namespace: nil,
            task_queue: nil,
            worker_id: nil,
            workflow_id: nil,
            run_id: nil,
            runtime: nil,
            client: nil,
            core_worker: nil,
            worker: nil,
            workflow_module: nil,
            activity_id: nil,
            activity_type: nil,
            activity_fn: nil,
            activity_task_token: nil,
            activity_start: nil,
            workflow_initialize: nil,
            channel: nil

  alias Temporal.Comms.Channel
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Worker

  @type t :: %__MODULE__{
          namespace: String.t() | nil,
          task_queue: TaskQueue.t() | nil,
          worker_id: String.t() | nil,
          workflow_id: String.t() | nil,
          run_id: String.t() | nil,
          runtime: CoreRuntime.t() | nil,
          client: CoreClient.t() | nil,
          core_worker: CoreWorker.t() | nil,
          worker: Worker.t() | nil,
          workflow_module: module() | nil,
          activity_id: String.t() | nil,
          activity_type: String.t() | nil,
          activity_fn: function() | nil,
          activity_start: term() | nil,
          activity_task_token: [byte()] | nil,
          workflow_initialize: term() | nil,
          channel: Channel.t() | nil
        }
end
