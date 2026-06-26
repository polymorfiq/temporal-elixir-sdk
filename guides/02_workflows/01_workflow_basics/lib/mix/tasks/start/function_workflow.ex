defmodule Mix.Tasks.Start.FunctionWorkflow do
  use Mix.Task

  alias Temporal.{Client, WorkflowExecution}
  alias TemporalGettingStarted.Workflows.FunctionBasedWorkflow

  @shortdoc "Runs Temporal's Getting Started workflow"
  @moduledoc """
  Tells Temporal Server to run the Getting Started workflows we created.

  Temporal Server looks for running workers that can execute the workflow and relevant tasks, to durably complete the request.

  You can call a function-based workflow by either passing in the handle to the workflow function or the string-based name of the workflow function itself.
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    {a, b, we} = case args do
      [a] ->
        {:ok, we} = Client.execute_workflow(client, &FunctionBasedWorkflow.function_based_workflow/2, Enum.map([a], &String.to_integer/1), [
          id: "function-based-workflow-1",
          task_queue: "workflow-basics"
        ])

        {a, 30, we}

      [a, b] ->
        {:ok, we} = Client.execute_workflow(client, "FunctionBasedWorkflow.another_function_based_workflow", Enum.map([a, b], &String.to_integer/1), [
          id: "function-based-workflow-2",
          task_queue: "workflow-basics"
        ])

        {a, b, we}
    end

    {:ok, result} = WorkflowExecution.get(we)
    IO.puts("Workflow result: #{a} x #{b} = #{result}")
  end
end