alias Temporal.Client
alias Temporal.Worker
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

client_opts = %Temporal.CoreSdk.Data.ClientOpts{
  target_host: "localhost:7233",
  client_name: "temporal-elixir",
  client_version: "0.0.1",
  identity: "iex-repl",
  rpc_retry: %Temporal.CoreSdk.Data.ClientRetryOpts{
    initial_interval_secs: 30.0,
    randomization_factor: 5.0,
    multiplier: 2.0,
    max_interval_secs: 60.0,
    max_elapsed_time_secs: 60.0,
    max_retries: 30
  }
}

{:ok, client} = Temporal.CoreSdk.CoreClient.new(runtime, client_opts)


#{:ok, client} = Temporal.dial_client("localhost:7233")
#{:ok, worker} = Temporal.Worker.new(client, "default")

#Worker.register_workflow(worker, SampleWorkflow)