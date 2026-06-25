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

If you are creating a new project using the Temporal Elixir SDK, you can start by creating a new directory via `mix new temporal_getting_started`.

Next, switch to the new directory (`cd temporal_getting_started`).

Add the following to your `mix.exs` dependencies:
```elixir
def deps do
  [
      {:temporal, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal", ref: "893551c"},
      {:temporal_engine, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal_engine", ref: "893551c", override: true},
      {:temporal_engine_nif, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal_engine_nif", ref: "893551c"},
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

Create a Workflow file (`lib/temporal_getting_started/workflow.ex`):

```elixir
defmodule TemporalGettingStarted.Workflow do
  use Temporal.Workflow
  
  alias Temporal.{Workflow, WorkflowContext}
  
  @spec say_hello_workflow()
  def say_hello_workflow(ctx, name) do
  end
end

package greeting

import (
	"time"

	"go.temporal.io/sdk/workflow"
)

func SayHelloWorkflow(ctx workflow.Context, name string) (string, error) {
	ao := workflow.ActivityOptions{
		StartToCloseTimeout: time.Second * 10,
	}
	ctx = workflow.WithActivityOptions(ctx, ao)

	var result string
	err := workflow.ExecuteActivity(ctx, Greet, name).Get(ctx, &result)
	if err != nil {
		return "", err
	}

	return result, nil
}

```

### 3. Create and Run the Worker

With your Activity and Workflow defined, you need a Worker to execute them. A Worker polls a Task Queue, that you
configure it to poll, looking for work to do. Once the Worker dequeues a Workflow or Activity task from the Task Queue,
it then executes that task.

Workers are a crucial part of your Temporal application as they're what actually execute the tasks defined in your
Workflows and Activities. For more information on Workers, see
[Understanding Temporal](/evaluate/understanding-temporal#workers) and a [deep dive into Workers](/workers).

Create a Worker file (worker/main.go):

```go
package main

import (
	"log"

	"my-org/greeting"

	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"
)

func main() {
	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalln("Unable to create client", err)
	}
	defer c.Close()

	w := worker.New(c, "my-task-queue", worker.Options{})

	w.RegisterWorkflow(greeting.SayHelloWorkflow)
	w.RegisterActivity(greeting.Greet)

	err = w.Run(worker.InterruptCh())
	if err != nil {
		log.Fatalln("Unable to start worker", err)
	}
}
```

Run the Worker:

```bash
go run worker/main.go
```

### 4. Execute the Workflow

Now that your Worker is running, it's time to start a Workflow Execution.

Create a separate file called start/main.go:

```go
package main

import (
	"context"
	"log"
	"os"

	greeting "my-org/greeting"

	"go.temporal.io/sdk/client"
)

func main() {
	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalln("Unable to create client", err)
	}
	defer c.Close()

	options := client.StartWorkflowOptions{
		ID:        "greeting-workflow",
		TaskQueue: "my-task-queue",
	}

	we, err := c.ExecuteWorkflow(context.Background(), options, greeting.SayHelloWorkflow, os.Args[1])
	if err != nil {
		log.Fatalln("Unable to execute workflow", err)
	}
	log.Println("Started workflow", "WorkflowID", we.GetID(), "RunID", we.GetRunID())

	var result string
	err = we.Get(context.Background(), &result)
	if err != nil {
		log.Fatalln("Unable get workflow result", err)
	}
	log.Println("Workflow result:", result)
}
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
