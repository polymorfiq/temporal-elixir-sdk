defmodule Mix.Tasks.Start.ContinueAsNew do
  use Mix.Task

  alias Temporal.{Client, WorkflowExecution}
  alias TemporalGettingStarted.Workflows.ContinueAsNewWorkflow

  @shortdoc "Runs Temporal's Continue As New workflow"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    {:ok, we} =
      Client.execute_workflow(client, ContinueAsNewWorkflow, [],
        id: "continue-as-new",
        task_queue: "continue-as-new-workflows"
      )

    {:ok, result} = WorkflowExecution.get(we)
    IO.puts("Workflow result: #{inspect(result)}")
  end
end
