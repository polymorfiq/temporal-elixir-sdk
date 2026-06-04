alias Temporal.Client
alias Temporal.Worker
alias Temporal.CoreSdk.CoreWorker
alias Temporal.Comms.Worker.TaskQueueComms
alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: WorkflowsSvcApi
alias Temporal.Protos.Temporal.Api.Taskqueue.V1, as: TaskQueueApi
alias Temporal.Protos.Temporal.Api.Enums.V1, as: EnumsApi
alias Temporal.Protos.Temporal.Api.Common.V1, as: CommonApi
alias Temporal.Protos.Temporal.Api.Deployment.V1, as: DeploymentApi

defmodule SampleWorkflow do
  def execute(_ctx, input) do
    {:ok, "Hello, #{input}"}
  end
end

{:ok, runtime} = Temporal.CoreSdk.CoreRuntime.new()
{:ok, client} = Temporal.Client.new("localhost:7233")
{:ok, worker} = Temporal.Worker.new(client, "default")

#{:ok, client} = Temporal.dial_client("localhost:7233")
#{:ok, worker.ex} = Temporal.Worker.new(client, "default")

#Worker.register_workflow(worker.ex, SampleWorkflow)