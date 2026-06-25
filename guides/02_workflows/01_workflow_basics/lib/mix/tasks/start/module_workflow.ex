defmodule Mix.Tasks.Start.ModuleWorkflow do
  use Mix.Task

  alias Temporal.{Client, WorkflowExecution}
  alias TemporalGettingStarted.Workflows.ModuleBasedWorkflow

  @shortdoc "Runs Temporal's Getting Started workflow"
  @moduledoc """
  Tells Temporal Server to run the Getting Started workflow we created.

  Temporal Server looks for running workers that can execute the workflow and relevant tasks, to durably complete the request.
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    params = case args do
      [a] ->
        %ModuleBasedWorkflow.Params{multiply_me: String.to_integer(a)}
      [a, b] ->
        %ModuleBasedWorkflow.Params{multiply_me: String.to_integer(a), multiply_by: String.to_integer(b)}
    end

    {:ok, we} = Client.execute_workflow(client, ModuleBasedWorkflow, [params], [
      id: "module-based-workflow",
      task_queue: "workflow-basics"
    ])

    {:ok, result} = WorkflowExecution.get(we)
    IO.puts("Workflow result: #{result}")
  end
end