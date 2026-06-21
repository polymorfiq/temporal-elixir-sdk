defmodule Temporal.Comms.Worker do
  use GenStage

  @moduledoc """
  An agent that polls the Temporal Server (Namespace, Task Queue) for work to do, workflows and activities to run.

  When new work is received, the worker performs the work while informing the Temporal Server of progress and needed resources.
  """

  import TemporalEngine.Config
  import TemporalEngine.Data.Activation
  require Record

  alias Temporal.Comms.Client
  alias Temporal.Comms.Pollers.{ActivityTaskPoller, NexusTaskPoller, WorkflowActivationPoller}
  alias Temporal.Workflows.{ActivityName, WorkflowName}
  alias TemporalEngine.Config

  @global_store Temporal.Storage.global_store()

  Record.defrecordp(:worker, [
    :id,
    pid: nil
  ])

  Record.defrecordp(:worker_state, [
    :id,
    :client,
    :worker,
    :config,
    :activation_poller,
    :activity_poller,
    :nexus_poller
  ])

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
  def init({client, config}) do
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
          client: client,
          worker: worker,
          config: config,
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
  def handle_events(events, {activation_p, _}, worker_state(activation_poller: activation_p) = state) do
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

  def handle_cast(activation(run_id: _run_id, jobs: jobs), state) do
    jobs |> IO.inspect(label: "jobs")

    {:noreply, [], state}
  end
end
