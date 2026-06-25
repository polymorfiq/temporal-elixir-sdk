defmodule Mix.Tasks.Start.Greeting do
  use Mix.Task

  alias Temporal.{Client, WorkflowExecution}
  alias TemporalGettingStarted.Greeting

  @shortdoc "Runs Temporal's Getting Started workflow"
  @moduledoc """
  Tells Temporal Server to run the Getting Started workflow we created.

  Temporal Server looks for running workers that can execute the workflow and relevant tasks, to durably complete the request.
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    {:ok, we} = Client.execute_workflow(client, Greeting.SayHelloWorkflow, args, [
      id: "greeting-workflow",
      task_queue: "my-task-queue"
    ])

    {:ok, result} = WorkflowExecution.get(we)
    IO.puts("Workflow result: #{result}")
  end
end