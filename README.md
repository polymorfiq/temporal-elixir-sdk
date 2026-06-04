# Temporal Elixir SDK

**This is an (in progress, unofficial) Temporal Language SDK for the Elixir programming language, that utilizes an NIF of the [Temporal Core SDK](https://github.com/temporalio/sdk-rust#temporal-core-sdk).**

**This SDK is not yet tested or fit for production usage.**

Though, it's MIT Licensed so feel free to fork it and go crazy in making it production-ready!

# Installation

```elixir
defp deps do
  [
    ...
    {:temporal, "~> 0.0.1", github: "polymorfiq/temporal-elixir-sdk", branch: "main"}
  ]
end
```

# Usage

I'm still learning how the Core SDK works, and so below I'll note what's working and my current understanding of the purpose each interaction serves.

I'm building a more Supervision-Tree-Friendly layer over the Core SDK for a more Elixir-friendly interaction, but the initialization and basic communication with the Rust Core is working and being improved.


## Starting a workflow

```elixir
{:ok, client} = Temporal.Client.new("localhost:7233")
{:ok, worker} = Temporal.Worker.new(client, "default")

Temporal.Client.start_workflow(
  client,
  "default",
  "my-workflow-id-v3",
  "MySpecialWorkflow",
  [
    WorkflowInput.new(123),
    WorkflowInput.new("456"),
    WorkflowInput.new(789.10),
    WorkflowInput.new(%{arbitrary: "map"}),
    WorkflowInput.bytes(<<1, 2, 3>>)
  ]
)
```

## Initializing the runtime

From my current understanding, this orchestrates the asynchronous threads/fibers used within the Temporal Client.

```elixir
{:ok, runtime} = Temporal.CoreSdk.CoreRuntime.new()
```

## Initializing the Client

The client is in charge of the overall connection with, messages passed back and forth, between the process and the gRPC Temporal Server.

```elixir
client_opts = %Temporal.CoreSdk.Data.ClientOpts{
  target_host: "localhost:7233",
  namespace: "default",
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
```

## Initializing a Worker

A worker polls various task queues (Workflow Activations, Activity Tasks, Nexus) for work to do, executes the work and responds via the Client to the Temporal Server with the results of those activities.

```elixir
worker_opts = %Temporal.CoreSdk.Data.WorkerOpts{
  namespace: "default",
  task_queue: "default",
  deployment_options: %Temporal.CoreSdk.Data.WorkerDeploymentOpts{
    version: %Temporal.CoreSdk.Data.WorkerDeploymentVersion{
      build_id: "0.0.1",
      deployment_name: "iex-repl-deploy"
    },
    use_worker_versioning: false,
    default_versioning_behavior: 0
  },
  max_cached_workflows: 100,
  nonsticky_to_sticky_poll_ratio: 0.5,
  enable_workflows: true,
  enable_local_activities: true,
  enable_remote_activities: true,
  enable_nexus: true,
  sticky_queue_schedule_to_start_timeout_secs: 300.0,
  max_heartbeat_throttle_interval_secs: 60.00,
  default_heartbeat_throttle_interval_secs: 30.0,
  graceful_shutdown_period_secs: 5.0,
  nondeterminism_as_workflow_fail: true,
  tuner: %Temporal.CoreSdk.Data.WorkerTunerOpts{
    workflow_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    },
    activity_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    },
    local_activity_slot_supplier: %Temporal.CoreSdk.Data.WorkerSlotSupplierOpts{
      fixed_size: 10
    }
  },
  nondeterminism_as_workflow_fail_for_types: [],
  plugins: [],
  max_worker_activities_per_second: 60,
  max_task_queue_activities_per_second: 60,
  identity_override: nil,
  workflow_task_poller_behavior: %Temporal.CoreSdk.Data.WorkerPollerOpts{
    simple_maximum: %Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
  },
  activity_task_poller_behavior:  %Temporal.CoreSdk.Data.WorkerPollerOpts{
    simple_maximum: %Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts{simple_maximum: 5}
  }
}

{:ok, worker} = Temporal.CoreSdk.CoreWorker.new(runtime, client, worker_opts)
```

## Polling Workflow Activations

This allows the worker to pull Workflows and changes to their state from the Task Queue of the Temporal Server.

It is worth noting that the Core SDK has internal tracking that **prevents duplicate workflow activations**. This is important to know, if any activations get discarded by the Lang SDK without being properly responded to. Restarting the OS process clears this internal state and allows you to re-process the Workflow from the beginning.

```elixir
Temporal.CoreSdk.CoreWorker.poll_workflow_activations(worker, runtime)
```

## Polling Activity Tasks

```elixir
Temporal.CoreSdk.CoreWorker.poll_activity_tasks(worker, runtime)
```

# Useful Vocabulary

Some vocabulary (and my understanding of that vocabulary) that I am picking up through the process of building the SDK.

**Workflow Activations**: Work for the worker to do in progressing forward the state of a Workflow. The worker retrieves Activations from its polling of the Temporal Server and responds with Activation Completions to tell the server how it has handled those Activations.

**Workflow Activation Completions**: The worker sends these back to the Server to inform the server of progress throughout the Workflow.

**Activity Tasks**: Work for the worker to do that involves Starting or Cancelling of a specific Activity.

**Activity Task Completions**: The worker sends these to the Temporal Server to report the progress on the Task Activities it received.

# References (for building Lang SDKs)

**A collection of useful references I've found so far, for building Temporal Lang SDKs**

The [Core SDK Architecture Document](https://github.com/temporalio/sdk-rust/blob/main/ARCHITECTURE.md) is the best resource for understanding the relationship between your Lang SDK, the Core SDK, and the Temporal Server.

Once you know the vocabulary around working with the Temporal Server, the [Temporal SDK Core](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/index.html) docs are by far the most helpful resource for understanding the internal workings of the Core SDK.

The [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby/tree/main/temporalio/ext/src) utilizes the Core SDK and so is a good example of how to utilize it in a production environment.



