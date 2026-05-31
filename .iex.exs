alias Temporal.DialClient
alias Temporal.Protos.Temporal.Api.Deployment.V1, as: Deployment
alias Temporal.Protos.Temporal.Api.Worker.V1, as: Worker
alias Temporal.Protos.Temporal.Api.Workmflowservice.V1, as: Workflows

{:ok, client} = DialClient.new(host_port: "localhost:7233")
{:ok, worker} = Temporal.Worker.new(client, "default")