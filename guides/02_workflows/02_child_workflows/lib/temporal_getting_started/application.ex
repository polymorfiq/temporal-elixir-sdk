defmodule TemporalGettingStarted.Application do
  @moduledoc false

  use Application

  alias Temporal.Client
  alias TemporalGettingStarted.Workflows

  @impl true
  @doc """
  Starts the Temporal Worker with registered activities and workflows.

  It will poll the Temporal Server for relevant tasks and Workflows to execute, within the configured task queue.

  Notice how `Workflows.ModuleBasedWorkflow` does not need to specify its `execute` function handle nor its bundled activities.
  """
  def start(_type, _args) do
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    children = [
      {Temporal.Worker,
       [
         client: client,
         workflows: [
           &Workflows.WorkflowWithChildren.parent_workflow/1,
           &Workflows.WorkflowWithChildren.child_workflow_1/2,
           &Workflows.WorkflowWithChildren.child_workflow_2/2
         ],
         activities: [],
         task_queue: "child-workflows",
         server_opts: [name: TemporalGettingStarted.MyWorker]
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TemporalGettingStarted.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
