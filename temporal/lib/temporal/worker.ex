defmodule Temporal.Worker do
  use GenStage

  @moduledoc """
  An agent that polls the Temporal Server (Namespace, Task Queue) for work to do, workflows and activities to run.

  When new work is received, the worker performs the work while informing the Temporal Server of progress and needed resources.
  """

  import TemporalEngine.Config
  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Common, only: [workflow_execution: 2]
  require Logger
  require Record
  require TemporalEngine.Data.Jobs

  alias Temporal.Client
  alias Temporal.Pollers.{ActivityTaskPoller, NexusTaskPoller, WorkflowActivationPoller}
  alias Temporal.Activity.ActivityComms
  alias Temporal.Workflow.WorkflowComms
  alias Temporal.Workflows.{ActivityName, WorkflowName}
  alias TemporalEngine.Config
  alias TemporalEngine.Worker, as: EngineWorker

  @global_store Temporal.Storage.global_store()

  Record.defrecordp(:worker, [
    :id,
    pid: nil
  ])

  Record.defrecordp(:worker_state, [
    :id,
    :task_queue,
    :client,
    :worker,
    :namespace,
    :activation_poller,
    :activity_poller,
    :nexus_poller,
    workflows: %{},
    activities: %{},
    pollers_shutdown: []
  ])

  @typep worker_state ::
           record(:worker_state,
             id: String.t(),
             task_queue: String.t(),
             client: Client.t(),
             worker: EngineWorker.t(),
             namespace: String.t(),
             activation_poller: pid(),
             activity_poller: pid(),
             nexus_poller: pid(),
             workflows: %{pid() => String.t()},
             activities: %{pid() => {String.t(), String.t()}},
             pollers_shutdown: [atom()]
           )

  @opaque t() :: record(:worker, id: String.t(), pid: pid() | nil)
  @type extra_opt :: {:workflows, [WorkflowName.t()]} | {:activities, [ActivityName.t()]}

  def child_spec(opts) do
    client = Keyword.fetch!(opts, :client)
    server_opts = Keyword.get(opts, :server_opts)
    {_, opts} = Keyword.split(opts, [:client, :server_opts])

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [client, opts, server_opts]},
      restart: :transient,
      shutdown: 5000,
      type: :worker
    }
  end

  @spec new(Client.t(), [Config.worker_config_opt() | extra_opt()]) ::
          {:ok, t()} | {:error, term()}
  def new(client, opts \\ []) do
    identity = opts[:client_identity_override] || TemporalEngine.Client.id(client)
    {_, config_opts} = Keyword.split(opts, [:workflows, :activities])

    with {:ok, config} <- worker_config_from_opts(config_opts),
         id <- "#{identity}_#{worker_config(config, :namespace)}" do
      server_opts = [name: {:via, Registry, {Temporal.TemporalRegistry, {:worker, id}}}]

      worker_started =
        DynamicSupervisor.start_child(Temporal.Workers, %{
          id: :worker,
          start: {__MODULE__, :start_link, [client, opts, server_opts]},
          restart: :transient
        })

      with {:ok, pid} <- worker_started do
        {:ok, worker(id: id, pid: pid)}
      else
        {:error, {:already_started, pid}} ->
          {:ok, worker(id: id, pid: pid)}
      end
    end
  end

  @doc false
  def start_link(client, opts \\ [], server_opts \\ []) do
    {extra_opts, opts} = Keyword.split(opts, [:workflows, :activities])
    workflows = Keyword.get(extra_opts, :workflows, [])
    activities = Keyword.get(extra_opts, :activities, [])
    identity = opts[:client_identity_override] || TemporalEngine.Client.id(client)

    with {:ok, config} <- worker_config_from_opts(opts),
         id <- "#{identity}_#{worker_config(config, :namespace)}",
         :ok <- register_workflows(worker(id: id), workflows),
         :ok <- register_activities(worker(id: id), activities) do
      config = worker_config(config, id: id)

      GenStage.start_link(__MODULE__, {client, config}, server_opts)
    end
  end

  @spec id(t()) :: String.t()
  def id(worker), do: worker(worker, :id)

  @spec shutdown(t()) :: :ok
  def shutdown(worker), do: GenStage.cast(worker(worker, :pid), :shutdown)

  @spec register_workflows(t(), [WorkflowName.t()]) :: :ok | {:error, term()}
  def register_workflows(worker(id: worker_id) = worker, workflow_names) do
    all_activities =
      Enum.reduce(workflow_names, {:ok, []}, fn wf_name, acc ->
        with {:ok, activities} <- acc,
             {:ok, wf_activities} <- WorkflowName.activities(wf_name) do
          {:ok, activities ++ wf_activities}
        end
      end)

    all_workflows =
      Enum.reduce(workflow_names, {:ok, []}, fn wf_name, acc ->
        with {:ok, workflows} <- acc,
             {:ok, name} <- WorkflowName.server_recognized_name(wf_name),
             {:ok, module} <- WorkflowName.workflow_module(wf_name),
             {:ok, execute_fn} <- WorkflowName.execute_fn(wf_name),
             {:ok, execute_arities} <- WorkflowName.execution_arities(wf_name) do
          {:ok, [{name, module, execute_fn, execute_arities} | workflows]}
        end
      end)

    with {:ok, workflows} <- all_workflows,
         {:ok, activities} <- all_activities,
         :ok <- register_activities(worker, activities) do
      Enum.each(workflows, fn {name, module, execute_fn, execute_arities} ->
        Enum.each(execute_arities, fn arity ->
          workflow_id = {:workflow, worker_id, name, arity}
          workflow_def = {module, execute_fn}
          :ets.insert(@global_store, {workflow_id, workflow_def})
        end)
      end)

      :ok
    end
  end

  @spec register_activities(t(), [ActivityName.t()]) :: :ok | {:error, term()}
  def register_activities(worker(id: worker_id), activity_names) do
    all_activities =
      Enum.reduce(activity_names, {:ok, []}, fn activity_name, acc ->
        with {:ok, activities} <- acc,
             {:ok, name} <- ActivityName.server_recognized_name(activity_name),
             {:ok, activity_module} <- ActivityName.activity_module(activity_name),
             {:ok, activity_fn} <- ActivityName.activity_fn(activity_name),
             {:ok, arities} <- ActivityName.activity_arities(activity_name) do
          {:ok, [{name, activity_module, activity_fn, arities} | activities]}
        end
      end)

    with {:ok, activities} <- all_activities do
      Enum.each(activities, fn {name, activity_module, activity_fn, arities} ->
        Enum.each(arities, fn arity ->
          activity_id = {:activity, worker_id, name, arity}
          activity_def = {activity_module, activity_fn}
          :ets.insert(@global_store, {activity_id, activity_def})
        end)
      end)

      :ok
    end
  end

  @doc false
  @spec init({Client.t(), Config.worker_config()}) :: {:consumer, worker_state(), keyword()}
  def init({client, config}) do
    Process.flag(:trap_exit, true)

    identity =
      worker_config(config, :client_identity_override) || TemporalEngine.Client.id(client)

    Process.set_label({:worker, worker_config(config, :namespace), identity})

    with {:ok, worker} <- TemporalEngine.Client.create_worker(client, config) do
      {:ok, activation_poller} = WorkflowActivationPoller.start_link(worker)
      {:ok, activity_poller} = ActivityTaskPoller.start_link(worker)
      {:ok, nexus_poller} = NexusTaskPoller.start_link(worker)

      state =
        worker_state(
          id: worker_config(config, :id),
          task_queue: worker_config(config, :task_queue),
          client: client,
          worker: worker,
          namespace: worker_config(config, :namespace),
          activation_poller: activation_poller,
          activity_poller: activity_poller,
          nexus_poller: nexus_poller
        )

      {:consumer, state,
       subscribe_to: [
         {activation_poller, [cancel: :transient]},
         {activity_poller, [cancel: :transient]},
         {nexus_poller, [cancel: :transient]}
       ]}
    else
      {:error, err} ->
        {:stop, err}
    end
  end

  @doc false
  @spec handle_events(list(), {pid(), reference()}, worker_state()) ::
          {:noreply, list(), worker_state()}
  def handle_events(
        activations,
        {activation_p, _},
        worker_state(activation_poller: activation_p) = state
      ) do
    state =
      Enum.reduce(activations, state, fn
        activation(run_id: run_id, jobs: [job(variant: initialize_workflow() = init)]), state ->
          worker_id = worker_state(state, :id)
          workflow_type = initialize_workflow(init, :workflow_type)
          arity = Enum.count(initialize_workflow(init, :arguments)) + 1

          found =
            case :ets.lookup(@global_store, {:workflow, worker_id, workflow_type, arity}) do
              [{_, wf_def}] ->
                {:ok, wf_def}

              _ ->
                {:error,
                 "Workflow not found for Worker (#{inspect(worker_id)}: #{workflow_type}/#{arity}"}
            end

          task_queue = worker_state(state, :task_queue)

          with {:ok, {wf_module, wf_exec_fn}} <- found,
               exec_args <-
                 {run_id, task_queue, worker_state(state, :namespace), wf_module, wf_exec_fn,
                  init},
               {:ok, comms} <-
                 WorkflowComms.start_link(
                   {run_id, workflow_type, worker_state(state, :namespace),
                    worker_state(state, :worker), exec_args}
                 ) do
            workflows = worker_state(state, :workflows) |> Map.put(comms, run_id)
            worker_state(state, workflows: workflows)
          else
            {:error, err} ->
              Logger.error("Error starting workflow: #{inspect(err)}")
              state
          end

        activation(run_id: run_id) = activate, state ->
          {workflow, _} =
            worker_state(state, :workflows)
            |> Enum.find(fn {_, wf_run_id} -> wf_run_id == run_id end)

          if workflow do
            WorkflowComms.activate(workflow, activate)
          else
            Logger.error("Sent an activation for unknown workflow: (Run ID: #{inspect(run_id)})")
          end

          state
      end)

    {:noreply, [], state}
  end

  def handle_events(events, {activity_p, _}, worker_state(activity_poller: activity_p) = state) do
    state =
      Enum.reduce(events, state, fn
        activity_task(variant: start_activity() = start, task_token: task_token), state ->
          worker_id = worker_state(state, :id)
          activity_type = start_activity(start, :activity_type)
          arity = Enum.count(start_activity(start, :input))

          found =
            case :ets.lookup(@global_store, {:activity, worker_id, activity_type, arity}) do
              [{_, activity_def}] ->
                {:ok, activity_def}

              _ ->
                {:error,
                 "Activity not found for Worker (#{inspect(worker_id)}: #{activity_type}/#{arity}"}
            end

          with {:ok, {activity_module, activity_exec_fn}} <- found,
               exec_args <- {activity_module, activity_exec_fn, start},
               {:ok, comms} <-
                 ActivityComms.start_link(
                   {worker_state(state, :worker), start, exec_args, task_token}
                 ) do
            workflow_exec = start_activity(start, :workflow_execution)
            run_id = workflow_execution(workflow_exec, :run_id)
            activity_id = start_activity(start, :activity_id)

            activities = worker_state(state, :activities) |> Map.put(comms, {run_id, activity_id})
            worker_state(state, activities: activities)
          else
            {:error, err} ->
              Logger.error("Error starting activity: #{inspect(err)}")
              state
          end

        activity_task(variant: cancel_activity(), task_token: task_token), state ->
          case Registry.lookup(Temporal.TemporalRegistry, {:activity, task_token}) do
            [{comms, _info}] ->
              Process.exit(comms, :normal)
              activities = worker_state(state, :activities) |> Map.delete(comms)
              worker_state(state, activities: activities)

            [] ->
              state
          end
      end)

    {:noreply, [], state}
  end

  def handle_events(events, {nexus_p, _}, worker_state(nexus_poller: nexus_p) = state) do
    Enum.each(events, &GenStage.cast(self(), &1))

    {:noreply, [], state}
  end

  def handle_cast(:shutdown, state) do
    worker = worker_state(state, :worker)
    TemporalEngine.Worker.initiate_shutdown(worker)

    {:noreply, [], state}
  end

  def handle_info({:DOWN, _, :process, _pid, :normal}, state) do
    {:noreply, [], state}
  end

  def handle_info({:DOWN, _, :process, pid, reason}, state) do
    Logger.warning("Worker saw unexpected PID go down: #{inspect(pid)}: #{inspect(reason)}")
    {:noreply, [], state}
  end

  def handle_info({:EXIT, workflow, reason}, worker_state(workflows: workflows) = state)
      when is_map_key(workflows, workflow) do
    # Workflow exited
    workflows = worker_state(state, :workflows)
    run_id = Map.get(workflows, workflow)

    if reason != :normal do
      Logger.warning(
        "Workflow (Run ID: #{inspect(run_id)}) down for unexpected reason: #{inspect(reason)}"
      )
    end

    {:noreply, [], worker_state(state, workflows: Map.delete(workflows, workflow))}
  end

  def handle_info({:EXIT, activity, reason}, worker_state(activities: activities) = state)
      when is_map_key(activities, activity) do
    # Workflow exited
    activities = worker_state(state, :activities)
    run_id = Map.get(activities, activity)

    if reason != :normal do
      Logger.warning(
        "Activity (Run ID: #{inspect(run_id)}) down for unexpected reason: #{inspect(reason)}"
      )
    end

    {:noreply, [], worker_state(state, activities: Map.delete(activities, activity))}
  end

  def handle_info(
        {:EXIT, activation_poller, :normal},
        worker_state(activation_poller: activation_poller) = state
      ) do
    record_shutdown(state, :activation)
  end

  def handle_info(
        {:EXIT, nexus_poller, :normal},
        worker_state(nexus_poller: nexus_poller) = state
      ) do
    record_shutdown(state, :nexus)
  end

  def handle_info(
        {:EXIT, activity_poller, :normal},
        worker_state(activity_poller: activity_poller) = state
      ) do
    record_shutdown(state, :activity)
  end

  def handle_info({:EXIT, pid, reason}, state) do
    Logger.warning("Worker saw unexpected PID exit: #{inspect(pid)}: #{inspect(reason)}")
    {:noreply, [], state}
  end

  defp record_shutdown(state, poller) do
    pollers_shutdown = [poller | worker_state(state, :pollers_shutdown)]
    state = worker_state(state, pollers_shutdown: pollers_shutdown)

    if Enum.member?(pollers_shutdown, :activity) && Enum.member?(pollers_shutdown, :activation) &&
         Enum.member?(pollers_shutdown, :nexus) do
      Logger.debug(
        "All pollers shutdown for Worker (#{inspect(worker_state(state, :id))}). Shutting down..."
      )

      worker_state(state, :worker)
      |> TemporalEngine.Worker.finalize_shutdown()

      {:stop, :normal, state}
    else
      {:noreply, [], state}
    end
  end
end
