defmodule TemporalEngineNif.Client do
  defstruct [:id, :core, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Client, for: TemporalEngineNif.Client do
  import TemporalEngine.Client
  import TemporalEngine.Data.Priority

  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.Priority
  alias TemporalEngineNif.Data.RetryPolicy
  alias TemporalEngineNif.Data.WorkerOpts
  alias TemporalEngineNif.Data.WorkerDeploymentOpts
  alias TemporalEngineNif.Data.WorkerDeploymentVersion
  alias TemporalEngineNif.Data.WorkerPollerAutoscalingOpts
  alias TemporalEngineNif.Data.WorkerPollerSimpleMaximumOpts
  alias TemporalEngineNif.Data.WorkerTunerOpts
  alias TemporalEngineNif.Data.WorkerTunerResourceOpts
  alias TemporalEngineNif.Data.WorkflowArguments
  alias TemporalEngineNif.Data.WorkflowDefinition
  alias TemporalEngineNif.Data.WorkflowStartOptions
  alias TemporalEngineNif.Runtime
  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngineNif.Worker

  @impl true
  def id(client), do: client.id

  @impl true
  def create_worker(client, opts) do
    parent = self()

    types = worker_opts(opts, :task_types)

    worker_opts = %WorkerOpts{
      namespace: worker_opts(opts, :namespace),
      task_queue: worker_opts(opts, :task_queue),
      deployment_options: worker_opts(opts, :deployment_options) |> maybe_opts(),
      max_cached_workflows: worker_opts(opts, :max_cached_workflows),
      nonsticky_to_sticky_poll_ratio: worker_opts(opts, :nonsticky_to_sticky_poll_ratio),
      enable_workflows: task_types(types, :enable_workflows),
      enable_local_activities: task_types(types, :enable_local_activities),
      enable_remote_activities: task_types(types, :enable_remote_activities),
      enable_nexus: task_types(types, :enable_nexus),
      sticky_queue_schedule_to_start_timeout:
        Duration.from_record(worker_opts(opts, :sticky_queue_schedule_to_start_timeout)),
      max_heartbeat_throttle_interval:
        Duration.from_record(worker_opts(opts, :max_heartbeat_throttle_interval)),
      default_heartbeat_throttle_interval:
        Duration.from_record(worker_opts(opts, :default_heartbeat_throttle_interval)),
      graceful_shutdown_period:
        Duration.from_record(worker_opts(opts, :graceful_shutdown_period)),
      nondeterminism_as_workflow_fail: worker_opts(opts, :nondeterminism_as_workflow_fail),
      tuner: worker_opts(opts, :tuner) |> maybe_opts(),
      nondeterminism_as_workflow_fail_for_types:
        worker_opts(opts, :nondeterminism_as_workflow_fail_for_types),
      plugins: worker_opts(opts, :plugins),
      max_worker_activities_per_second: worker_opts(opts, :max_worker_activities_per_second),
      max_task_queue_activities_per_second:
        worker_opts(opts, :max_task_queue_activities_per_second),
      identity_override: worker_opts(opts, :identity_override),
      workflow_task_poller_behavior:
        worker_opts(opts, :workflow_task_poller_behavior) |> maybe_opts(),
      activity_task_poller_behavior:
        worker_opts(opts, :activity_task_poller_behavior) |> maybe_opts()
    }

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_worker(client.runtime.core, client.core, worker_opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize worker from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, worker} ->
            with :ok <- validate(worker, client.runtime) do
              send(
                parent,
                {self(),
                 {:ok,
                  %Worker{
                    id: worker_opts(opts, :id),
                    core: worker,
                    client: client,
                    runtime: client.runtime
                  }}}
              )
            else
              {:error, err} ->
                send(parent, {self(), {:error, err}})
            end

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  @spec validate(worker_ref :: term(), Runtime.t()) :: :ok | {:error, term()}
  def validate(worker_ref, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._validate_worker(runtime.core, worker_ref, self())
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not validate worker via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, _} ->
            send(parent, {self(), :ok})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    validate_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case validate_resp do
      :ok -> :ok
      {:error, err} -> {:error, "Validation error: #{inspect(err)}"}
    end
  end

  @impl true
  def start_workflow(client, definition, args, opts) do
    parent = self()

    wf_def = %WorkflowDefinition{name: definition(definition, :name)}
    inputs = %WorkflowArguments{args: Enum.map(args, &Payload.from_record/1)}

    start_opts = %WorkflowStartOptions{
      task_queue: workflow_start_opts(opts, :task_queue),
      workflow_id: workflow_start_opts(opts, :workflow_id),
      id_reuse_policy: workflow_start_opts(opts, :id_reuse_policy),
      id_conflict_policy: workflow_start_opts(opts, :id_conflict_policy),
      enable_eager_workflow_start: workflow_start_opts(opts, :enable_eager_workflow_start),
      priority: workflow_start_opts(opts, :priority) |> maybe_opts(),
      links: if(links = workflow_start_opts(opts, :links), do: Enum.map(links, &maybe_opts/1)),
      completion_callbacks:
        if(cbs = workflow_start_opts(opts, :completion_callbacks),
          do: Enum.map(cbs, &maybe_opts/1)
        ),
      execution_timeout: Duration.from_record(workflow_start_opts(opts, :execution_timeout)),
      run_timeout: Duration.from_record(workflow_start_opts(opts, :run_timeout)),
      task_timeout: Duration.from_record(workflow_start_opts(opts, :task_timeout)),
      cron_schedule: workflow_start_opts(opts, :cron_schedule),
      search_attributes: workflow_start_opts(opts, :search_attributes) |> maybe_opts,
      retry_policy: RetryPolicy.from_record(workflow_start_opts(opts, :retry_policy)),
      start_signal: workflow_start_opts(opts, :start_signal) |> maybe_opts(),
      header: workflow_start_opts(opts, :header),
      static_summary: workflow_start_opts(opts, :static_summary),
      static_details: workflow_start_opts(opts, :static_details)
    }

    {pid, ref} =
      spawn_monitor(fn ->
        Core._client_start_workflow(
          client.runtime.core,
          client.core,
          wf_def,
          inputs,
          start_opts,
          self()
        )
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not start workflow via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, workflow_handle} ->
            send(
              parent,
              {self(),
               {:ok,
                %WorkflowHandle{
                  client: client,
                  core: workflow_handle,
                  workflow_name: definition(definition, :name),
                  workflow_id: workflow_start_opts(opts, :workflow_id),
                  task_queue: workflow_start_opts(opts, :task_queue)
                }}}
            )

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  defp maybe_opts(nil), do: nil

  defp maybe_opts(deployment() = deploy) do
    %WorkerDeploymentOpts{
      version: deployment(deploy, :version) |> maybe_opts(),
      use_worker_versioning: deployment(deploy, :use_worker_versioning),
      default_versioning_behavior: deployment(deploy, :default_versioning_behavior)
    }
  end

  defp maybe_opts(version() = vers) do
    %WorkerDeploymentVersion{
      build_id: version(vers, :build_id),
      deployment_name: version(vers, :deployment_name)
    }
  end

  defp maybe_opts(priority() = p) do
    %Priority{
      priority_key: priority(p, :priority_key),
      fairness_key: priority(p, :fairness_key),
      fairness_weight: priority(p, :fairness_weight)
    }
  end

  defp maybe_opts(tuner() = tuner_opts) do
    %WorkerTunerOpts{
      workflow_slot_supplier: tuner(tuner_opts, :workflow_slot_supplier) |> maybe_opts(),
      activity_slot_supplier: tuner(tuner_opts, :workflow_slot_supplier) |> maybe_opts(),
      local_activity_slot_supplier: tuner(tuner_opts, :workflow_slot_supplier) |> maybe_opts()
    }
  end

  defp maybe_opts(fixed() = supplier) do
    {:fixed_size, fixed(supplier, :size)}
  end

  defp maybe_opts(resource() = supplier) do
    {:resource_based,
     %WorkerTunerResourceOpts{
       target_mem_usage: resource(supplier, :target_mem_usage),
       target_cpu_usage: resource(supplier, :target_cpu_usage),
       min_slots: resource(supplier, :min_slots),
       max_slots: resource(supplier, :max_slots),
       ramp_throttle: resource(supplier, :ramp_throttle)
     }}
  end

  defp maybe_opts(autoscaling_poller() = poller) do
    {:autoscaling_poller,
     %WorkerPollerAutoscalingOpts{
       minimum: autoscaling_poller(poller, :minimum),
       maximum: autoscaling_poller(poller, :maximum),
       initial: autoscaling_poller(poller, :initial)
     }}
  end

  defp maybe_opts(simple_maximum_poller() = poller) do
    {:simple_maximum,
     %WorkerPollerSimpleMaximumOpts{
       simple_maximum: simple_maximum_poller(poller, :simple_maximum)
     }}
  end
end
