defmodule TemporalGettingStarted.Application do
  @moduledoc false

  use Application

  alias Temporal.Client
  alias TemporalGettingStarted.Greeting

  @impl true
  def start(_type, _args) do
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    children = [
       {Temporal.Worker, [
         client: client,
         workflows: [Greeting.SayHelloWorkflow],
         activities: [&Greeting.greet/1],
         task_queue: "my-task-queue",
         server_opts: [name: TemporalGettingStarted.MyWorker]
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TemporalGettingStarted.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
