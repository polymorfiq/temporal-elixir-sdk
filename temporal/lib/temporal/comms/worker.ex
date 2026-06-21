defmodule Temporal.Comms.Worker do
  use GenStage

  @moduledoc """
  An agent that polls the Temporal Server (Namespace, Task Queue) for work to do, workflows and activities to run.

  When new work is received, the worker performs the work while informing the Temporal Server of progress and needed resources.
  """

  import TemporalEngine.Config
  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Jobs
  require Logger
  require Record
  require TemporalEngine.Data.Jobs

  alias Temporal.Comms.Client
  alias Temporal.Comms.Pollers.{ActivityTaskPoller, NexusTaskPoller, WorkflowActivationPoller}
  alias Temporal.Comms.Workflow.WorkflowExecution
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
    :activation_poller,
    :activity_poller,
    :nexus_poller,
    workflows: %{}
  ])

  @typep worker_state ::
           record(:worker_state,
             id: String.t(),
             task_queue: String.t(),
             client: Client.t(),
             worker: EngineWorker.t(),
             activation_poller: pid(),
             activity_poller: pid(),
             nexus_poller: pid()
           )

  @opaque t() :: record(:worker, id: String.t(), pid: pid() | nil)
  @type extra_opt :: {:workflows, [WorkflowName.t()]} | {:activities, [ActivityName.t()]}

  @spec new(Client.t(), [Config.worker_config_opt() | extra_opt()]) ::
          {:ok, t()} | {:error, term()}
  def new(client, opts \\ []) do
    {extra_opts, opts} = Keyword.split(opts, [:workflows, :activities])
    workflows = Keyword.get(extra_opts, :workflows, [])
    activities = Keyword.get(extra_opts, :activities, [])
    identity = opts[:client_identity_override] || TemporalEngine.Client.id(client)

    with {:ok, config} <- worker_config_from_opts(opts),
         id <- "#{identity}_#{worker_config(config, :namespace)}",
         :ok <- register_workflows(worker(id: id), workflows),
         :ok <- register_activities(worker(id: id), activities) do
      config = worker_config(config, id: id)
      name = {:via, Registry, {Temporal.TemporalRegistry, {:worker, id}}}

      worker_started =
        DynamicSupervisor.start_child(Temporal.Workers, {__MODULE__, {name, client, config}})

      with {:ok, pid} <- worker_started do
        {:ok, worker(id: id, pid: pid)}
      else
        {:error, {:already_started, pid}} ->
          {:ok, worker(id: id, pid: pid)}
      end
    end
  end

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
  def start_link({name, client, config}),
    do: GenStage.start_link(__MODULE__, {client, config}, name: name)

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
          activation_poller: activation_poller,
          activity_poller: activity_poller,
          nexus_poller: nexus_poller
        )

      {:consumer, state,
       subscribe_to: [
         activation_poller,
         activity_poller,
         nexus_poller
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
        events,
        {activation_p, _},
        worker_state(activation_poller: activation_p) = state
      ) do
    Enum.each(events, &GenStage.cast(self(), &1))

    {:noreply, [], state}
  end

  def handle_events(events, {activity_p, _}, worker_state(activity_poller: activity_p) = state) do
    Enum.each(events, &GenStage.cast(self(), &1))

    {:noreply, [], state}
  end

  def handle_events(events, {nexus_p, _}, worker_state(nexus_poller: nexus_p) = state) do
    Enum.each(events, &GenStage.cast(self(), &1))

    {:noreply, [], state}
  end

  @doc false
  @spec handle_cast(term(), worker_state()) :: {:noreply, list(), worker_state()}
  def handle_cast(
        activation(run_id: run_id, jobs: [job(variant: initialize_workflow() = init)]),
        state
      ) do
    worker_id = worker_state(state, :id)
    workflow_name = initialize_workflow(init, :workflow_type)
    arity = Enum.count(initialize_workflow(init, :arguments)) + 1

    found =
      case :ets.lookup(@global_store, {:workflow, worker_id, workflow_name, arity}) do
        [{_, wf_def}] ->
          {:ok, wf_def}

        _ ->
          {:error,
           "Workflow not found for Worker (#{inspect(worker_id)}: #{workflow_name}/#{arity}"}
      end

    task_queue = worker_state(state, :task_queue)

    with {:ok, {wf_module, wf_exec_fn}} <- found,
         {:ok, exec} =
           WorkflowExecution.start_link({run_id, task_queue, wf_module, wf_exec_fn, init}) do
      Logger.debug(
        "Started workflow #{inspect(workflow_name)} (#{inspect(run_id)})... Subscribing..."
      )

      GenStage.async_subscribe(self(), to: exec, cancel: :temporary)

      workflows = worker_state(state, :workflows) |> Map.put(exec, run_id)
      {:noreply, [], worker_state(state, workflows: workflows)}
    else
      {:error, err} ->
        Logger.error("Error starting workflow: #{inspect(err)}")
        {:noreply, [], state}
    end
  end

  def handle_info({:DOWN, _, :process, pid, reason}, worker_state(workflows: workflows) = state)
      when is_map_key(workflows, pid) do
    {pid, reason} |> IO.inspect(label: "Workflow down")
    {:noreply, [], state}
  end

  def handle_info({:DOWN, _, :process, pid, reason}, state) do
    {pid, reason} |> IO.inspect(label: "Something down?")
    {:noreply, [], state}
  end

  def handle_info({:EXIT, workflow, reason}, worker_state(workflows: workflows) = state)
      when is_map_key(workflows, workflow) do
    {workflow, reason} |> IO.inspect(label: "Workflow down?")
    {:noreply, [], state}
  end
end
