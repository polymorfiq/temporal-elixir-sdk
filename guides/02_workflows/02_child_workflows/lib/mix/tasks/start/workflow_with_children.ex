defmodule Mix.Tasks.Start.WorkflowWithChildren do
  use Mix.Task

  alias Temporal.{Client, WorkflowExecution}
  alias TemporalGettingStarted.Workflows.WorkflowWithChildren

  @shortdoc "Runs Temporal's Getting Started workflow"
  @moduledoc """
  Tells Temporal Server to run the Getting Started workflow we created.

  Temporal Server looks for running workers that can execute the workflow and relevant tasks, to durably complete the request.
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    {:ok, we} =
      Client.execute_workflow(
        client,
        &WorkflowWithChildren.parent_workflow/1,
        Enum.map(args, &String.to_integer/1),
        id: "workflow-with-children",
        task_queue: "child-workflows"
      )

    {:ok, result} = WorkflowExecution.get(we)
    IO.puts("Workflow result: #{inspect(result)}")
  end
end
