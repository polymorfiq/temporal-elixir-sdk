# Set up your local with the Elixir SDK

> Configure your local development environment to get started developing with Temporal

# Quickstart

Configure your local development environment to get started developing with Temporal.

## Install Elixir

Make sure you have Elixir installed. These tutorials were produced using `Erlang/OTP 28` and `Elixir 1.19.4`. Check your version of Elixir with the
following command:

This will return your installed Elixir version.

```bash
elixir -v
```

```bash
Erlang/OTP 28 [erts-16.2] [source] [64-bit] [smp:10:10] [ds:10:10:10] [async-threads:1] [jit] [dtrace]

Elixir 1.19.4 (compiled with Erlang/OTP 28)
```

## Install the Temporal Elixir SDK

If you are creating a new project using the Temporal Elixir SDK, you can start by creating a new directory via `mix new --sup temporal_getting_started`.

Next, switch to the new directory (`cd temporal_getting_started`).

Add the following to your `mix.exs` dependencies:
```elixir
def deps do
  [
      {:temporal, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal", ref: "7ebcb29"},
      {:temporal_engine, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal_engine", ref: "7ebcb29", override: true},
      {:temporal_engine_nif, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal_engine_nif", ref: "7ebcb29"},
      ...
  ]
end
```

Finally, install the Temporal SDK with `mix deps.get`.

## Install Temporal CLI and start the development server

The fastest way to get a development version of the Temporal Service running on your local machine is to use
[Temporal CLI](https://docs.temporal.io/cli).

Choose your operating system to install Temporal CLI:

```bash
brew install temporal
```

```bash
sudo mv temporal /usr/local/bin
```

## Start the development server

Once you've installed Temporal CLI and added it to your PATH, open a new Terminal window and run the following command.

This command starts a local Temporal Service. It starts the Web UI, creates the default Namespace, and uses an in-memory
database.

The Temporal Service will be available on localhost:7233. The Temporal Web UI will be available at
http://localhost:8233.

Leave the local Temporal Service running as you work through tutorials and other projects. You can stop the Temporal
Service at any time by pressing CTRL+C.

Once you have everything installed, you're ready to build apps with Temporal on your local machine.

```bash
temporal server start-dev
```

```bash
temporal server start-dev --ui-port 8080
```

## Run Hello World: Test Your Installation

Now let's verify your setup is working by creating and running a complete Temporal application with both a Workflow and
Activity.

This test will confirm that:

- The Temporal Elixir SDK is properly installed
- Your local Temporal Service is running
- You can successfully create and execute Workflows and Activities
- The communication between components is functioning correctly

### 1. Create the Activity

An Activity is a normal function or method that executes a single, well-defined action (either short- or long-running)
that is typically prone to failure. Examples include any action that interacts with the outside world, such as sending
emails, making network requests, writing to a database, or calling an API. If an Activity fails, Temporal automatically
retries it based on your configuration.

Create an Activity file (`lib/temporal_getting_started/greeting.ex`):

```elixir
defmodule TemporalGettingStarted.Greeting do
  @moduledoc "Activities for producing greetings"
  
  @spec greet(name :: String.t()) :: {:ok, String.t()} | {:error, term()}
  def greet(name) do
    {:ok, "Hello #{name}"}
  end
end
```

### 2. Create the Workflow

Workflows orchestrate Activities and contain the application logic. Temporal Workflows are resilient. They can run—and
keep running—for years, even if the underlying infrastructure fails. If the application itself crashes, Temporal will
automatically recreate its pre-failure state so it can continue right where it left off.

Create a Workflow file (`lib/temporal_getting_started/greeting/say_hello_workflow.ex`):

```elixir
defmodule TemporalGettingStarted.Greeting.SayHelloWorkflow do
  use Temporal.Workflow
  
  alias Temporal.{Workflow, WorkflowContext}
  alias TemporalGettingStarted.Greeting
  
  @spec execute(WorkflowContext.t(), name :: String.t()) :: {:ok, String.t()} | {:error, term()}
  def execute(ctx, name) do
    ctx = Workflow.with_activity_opts(ctx, start_to_close_timeout: {10, :seconds})
    
    with  {:ok, activity} <- Workflow.execute_activity(ctx, &Greeting.greet/1, [name]) do
      Workflow.get(ctx, activity)
    end
  end
end
```

### 3. Create and Run the Worker

With your Activity and Workflow defined, you need a Worker to execute them. A Worker polls a Task Queue, that you
configure it to poll, looking for work to do. Once the Worker dequeues a Workflow or Activity task from the Task Queue,
it then executes that task.

Workers are a crucial part of your Temporal application as they're what actually execute the tasks defined in your
Workflows and Activities. For more information on Workers, see
[Understanding Temporal](https://docs.temporal.io/evaluate/understanding-temporal#workers) and a [deep dive into Workers](https://docs.temporal.io/workers).

Register a Worker in your supervision tree (`lib/temporal_getting_started/application.ex`):

```elixir
defmodule TemporalGettingStarted.Application do
  @moduledoc false

  use Application

  alias Temporal.Client
  alias TemporalGettingStarted.{Greeting, Workflow}

  @impl true
  def start(_type, _args) do
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    children = [
       {Temporal.Worker, [
         client: client,
         workflows: [Workflow],
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
```

Run the Worker:

```bash
mix run --no-halt
```

### 4. Execute the Workflow

Now that your Worker is running, it's time to start a Workflow Execution.

Create a separate file called (`lib/mix/tasks/start/greeting.exs`):

```elixir
defmodule Mix.Tasks.Start.Greeting do
  use Mix.Task

  alias TemporalGettingStarted.Greeting

  @shortdoc "Runs Temporal's Getting Started workflow"
  @moduledoc """
  Tells Temporal Server to run the Getting Started workflow we created.

  Temporal Server looks for running workers that can execute the workflow and relevant tasks, to durably complete the request.
  """

  @impl Mix.Task
  def run(args) do
    client = Client.new!("localhost:7233", engine: TemporalEngineNif.Engine)

    {:ok, _wf_handle} = Client.execute_workflow(client, Greeting.SayHelloWorkflow, ["World"], [
      id: "greeting-workflow",
      task_queue: "my-task-queue"
    ])
  end
end
```

Then run:

```bash
go run start/main.go Temporal
```

### Verify Success

If everything is working correctly, you should see:

- Worker processing the workflow and activity
- Output: `Workflow result: Hello Temporal`
- Workflow Execution details in the [Temporal Web UI](http://localhost:8233)

- [Run your first Temporal Application](https://learn.temporal.io/getting_started/go/first_program_in_go/): Create a basic Workflow and run it with the Temporal Go SDK

- [Take a Temporal 101 course](https://learn.temporal.io/courses/): Learn Temporal concepts and build your first application with a guided course
