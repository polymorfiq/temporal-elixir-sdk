defmodule Temporal.Workflow.WorkflowComms do
  use GenStage

  require Logger
  require Record
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.ActivationCompletion
  import TemporalEngine.Data.Commands

  alias Temporal.Workflow.WorkflowExecution
  alias TemporalEngine.Data.Activation
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.Timestamp
  alias TemporalEngine.Worker

  Record.defrecordp(:comms_state, [
    :run_id,
    :workflow_type,
    :worker,
    :exec,
    :namespace,
    activations_received: 1,
    completions_sent: 0,
    replaying: false,
    scheduled_activities: %{},
    started_timers: %{}
  ])

  @typep comms_state ::
           record(:comms_state,
             run_id: String.t(),
             workflow_type: String.t(),
             exec: pid(),
             namespace: String.t(),
             replaying: boolean(),
             activations_received: non_neg_integer(),
             completions_sent: non_neg_integer(),
             scheduled_activities: %{integer() => map()},
             started_timers: %{integer() => map()},
             worker: Worker.t()
           )

  @doc false
  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @doc false
  @spec init(
          {run_id :: String.t(), workflow_type :: String.t(), namespace :: String.t(), Worker.t(),
           exec_args :: term()}
        ) ::
          {:consumer, comms_state(), keyword()}
  def init({run_id, workflow_type, namespace, worker, exec_args}) do
    Process.set_label({:workflow_comms, workflow_type, run_id})
    {:ok, exec} = WorkflowExecution.start_link(exec_args)

    {:consumer,
     comms_state(
       run_id: run_id,
       workflow_type: workflow_type,
       worker: worker,
       namespace: namespace,
       exec: exec
     ), subscribe_to: [exec]}
  end

  @spec activate(pid(), Activation.activation()) :: :ok
  def activate(pid, activation), do: GenStage.cast(pid, activation)

  def handle_cast(
        activation(jobs: [job(variant: remove_from_cache(reason: reason, message: message))]),
        state
      ) do
    run_id = comms_state(state, :run_id)
    worker = comms_state(state, :worker)

    :ok =
      Worker.complete_workflow_activation(
        worker,
        completion(run_id: run_id, status: success(commands: []))
      )

    type = comms_state(state, :workflow_type)

    Logger.debug(
      "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) - removing from cache (#{inspect(reason)} - #{inspect(message)})."
    )

    {:stop, :normal, inc_activations(state)}
  end

  def handle_cast(activation() = activate, state) do
    job_variants = activation(activate, :jobs) |> Enum.map(&job(&1, :variant))

    future_state =
      Enum.reduce(job_variants, {:ok, state}, fn
        fire_timer(seq: seq), {:ok, state} ->
          started = comms_state(state, :started_timers) |> Map.delete(seq)
          {:ok, comms_state(state, started_timers: started)}

        resolve_activity(seq: seq), {:ok, state} ->
          scheduled = comms_state(state, :scheduled_activities) |> Map.delete(seq)
          {:ok, comms_state(state, scheduled_activities: scheduled)}

        _, {:ok, state} ->
          {:ok, state}
      end)

    with {:ok, state} <- future_state do
      exec = comms_state(state, :exec)
      ts = activation(activate, :timestamp)
      WorkflowExecution.set_current_timestamp(exec, Timestamp.to_native(ts))

      is_replaying? = activation(activate, :is_replaying)

      if is_replaying? != comms_state(state, :replaying) do
        WorkflowExecution.set_is_replaying(exec, is_replaying?)
      end

      WorkflowExecution.activation_started(exec)
      activation(activate, :jobs) |> Enum.each(&WorkflowExecution.process_job(exec, &1))
      WorkflowExecution.activation_completed(exec)

      {:noreply, [], state |> inc_activations() |> comms_state(replaying: is_replaying?)}
    else
      {:error, err} ->
        {:stop, err, inc_activations(state)}
    end
  end

  @spec handle_events([ActivationCompletion.status()], {pid(), reference()}, comms_state()) ::
          {:noreply, [], comms_state()}

  def handle_events([success(commands: commands) = status], _, state) do
    variants = Enum.map(commands, fn cmd -> command(cmd, :variant) end)

    run_id = comms_state(state, :run_id)

    future_state =
      Enum.reduce(variants, {:ok, state}, fn
        schedule_activity(seq: seq), {:ok, state} ->
          scheduled =
            comms_state(state, :scheduled_activities)
            |> Map.put(seq, %{scheduled: DateTime.utc_now()})

          {:ok, comms_state(state, scheduled_activities: scheduled)}

        schedule_local_activity(seq: seq), {:ok, state} ->
          scheduled =
            comms_state(state, :scheduled_activities)
            |> Map.put(seq, %{scheduled: DateTime.utc_now()})

          {:ok, comms_state(state, scheduled_activities: scheduled)}

        start_timer(seq: seq), {:ok, state} ->
          started_timers =
            comms_state(state, :started_timers)
            |> Map.put(seq, %{started: DateTime.utc_now()})

          {:ok, comms_state(state, started_timers: started_timers)}

        _, {:ok, state} ->
          {:ok, state}
      end)

    with {:ok, new_state} <- future_state do
      worker = comms_state(state, :worker)

      :ok =
        Worker.complete_workflow_activation(worker, completion(run_id: run_id, status: status))

      {:noreply, [], inc_completions(new_state)}
    else
      {:error, err} ->
        {:stop, {:unexpected_command, err}, inc_completions(state)}
    end
  end

  defp inc_activations(state) do
    comms_state(state, activations_received: comms_state(state, :activations_received) + 1)
  end

  defp inc_completions(state) do
    comms_state(state, completions_sent: comms_state(state, :completions_sent) + 1)
  end
end
