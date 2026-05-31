alias Temporal.Client
alias Temporal.Worker
alias Temporal.Protos.Temporal.Api.Deployment.V1, as: Deployment
alias Temporal.Protos.Temporal.Api.Worker.V1, as: Worker
alias Temporal.Protos.Temporal.Api.Workmflowservice.V1, as: Workflows

{:ok, client} = Temporal.dial_client("localhost:7233")
{:ok, worker} = Temporal.Worker.new(client, "default")