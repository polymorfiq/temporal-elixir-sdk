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
       {Temporal.Worker, [
         client: client,
         workflows: [
           Workflows.ModuleBasedWorkflow,
           &Workflows.FunctionBasedWorkflow.function_based_workflow/2,
           {Workflows.FunctionBasedWorkflow, :function_based_workflow, [name: "my_custom_workflow_type"]},
           {Workflows.FunctionBasedWorkflow, :another_function_based_workflow}
         ],
         activities: [
           &Workflows.FunctionBasedWorkflow.function_based_activity/2,
         ],
         task_queue: "workflow-basics",
         server_opts: [name: TemporalGettingStarted.MyWorker]
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TemporalGettingStarted.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
