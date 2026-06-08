defmodule Temporal.Supervisor.ExecutionContext do
  alias Temporal.TaskQueue

  defstruct namespace: nil,
            task_queue: nil,
            worker_id: nil,
            workflow_id: nil,
            run_id: nil,
            runtime: nil,
            client: nil,
            worker: nil,
            workflow_module: nil,
            activity_id: nil,
            activity_type: nil,
            activity_fn: nil,
            activity_start: nil,
            activity_task_token: nil

  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.CoreWorker

  @type t :: %__MODULE__{
          namespace: String.t() | nil,
          task_queue: TaskQueue.t() | nil,
          worker_id: String.t() | nil,
          workflow_id: String.t() | nil,
          run_id: String.t() | nil,
          runtime: CoreRuntime.t() | nil,
          client: CoreClient.t() | nil,
          worker: CoreWorker.t() | nil,
          workflow_module: module() | nil,
          activity_id: String.t() | nil,
          activity_type: String.t() | nil,
          activity_fn: function() | nil,
          activity_start: term() | nil,
          activity_task_token: [byte()] | nil
        }
end
