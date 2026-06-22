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
  alias TemporalEngine.Worker

  Record.defrecordp(:comms_state, [
    :run_id,
    :workflow_type,
    :worker,
    :exec,
    scheduled_activities: %{},
    started_timers: %{},
    state: nil
  ])

  @typep comms_state ::
           record(:comms_state,
             run_id: String.t(),
             workflow_type: String.t(),
             exec: pid(),
             scheduled_activities: %{integer() => map()},
                                                     started_timers: %{integer() => map()},
             state:
               :initialized
               | :scheduled_activities
               | :resolved_activities
               | :all_activities_resolved
               | :cache_removed
               | :completed,
             worker: Worker.t()
           )

  @doc false
  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @doc false
  @spec init({run_id :: String.t(), workflow_type :: String.t(), Worker.t(), exec_args :: term()}) ::
          {:consumer, comms_state(), keyword()}
  def init({run_id, workflow_type, worker, exec_args}) do
    Process.set_label({:workflow_comms, workflow_type, run_id})
    {:ok, exec} = WorkflowExecution.start_link(exec_args)

    {:consumer,
     comms_state(
       run_id: run_id,
       workflow_type: workflow_type,
       worker: worker,
       state: :initialized,
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

    {:stop, :normal, comms_state(state, state: :cache_removed)}
  end

  def handle_cast(activation() = activate, state) do
    job_variants = activation(activate, :jobs) |> Enum.map(&job(&1, :variant))

    run_id = comms_state(state, :run_id)
    type = comms_state(state, :workflow_type)

    future_state =
      Enum.reduce(job_variants, {:ok, state}, fn
        fire_timer(seq: seq), {:ok, state} ->
          started = comms_state(state, :started_timers) |> Map.delete(seq)

          if Enum.any?(started) do
            {:ok,
              comms_state(state, started_timers: started)}
          else
            Logger.debug(
              "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) resolved all timers."
            )

            {:ok,
              comms_state(state, started_timers: started)}
          end

        resolve_activity(seq: seq), {:ok, state} ->
          scheduled = comms_state(state, :scheduled_activities) |> Map.delete(seq)

          if Enum.any?(scheduled) do
            {:ok,
             comms_state(state, state: :resolved_activities, scheduled_activities: scheduled)}
          else
            Logger.debug(
              "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) resolved all activities."
            )

            {:ok,
             comms_state(state, state: :all_activities_resolved, scheduled_activities: scheduled)}
          end
      end)

    with {:ok, state} <- future_state do
      exec = comms_state(state, :exec)
      activation(activate, :jobs) |> Enum.each(&WorkflowExecution.process_job(exec, &1))

      {:noreply, [], state}
    else
      {:error, err} ->
        {:stop, err, state}
    end
  end

  @spec handle_events([ActivationCompletion.status()], {pid(), reference()}, comms_state()) ::
          {:noreply, [], comms_state()}
  def handle_events([success(commands: [])], _, comms_state(state: :initialized) = state) do
    Logger.error(
      "Unexpected completion: No commands on initialization. Should have some commands."
    )

    {:stop, {:unexpected_noop, "No commands on initialization. Should have some commands."},
     state}
  end

  def handle_events([success(commands: commands) = status], _, state) do
    variants = Enum.map(commands, fn cmd -> command(cmd, :variant) end)

    run_id = comms_state(state, :run_id)
    type = comms_state(state, :workflow_type)

    future_state =
      Enum.reduce(variants, {:ok, state}, fn
        _, {:ok, comms_state(state: :failed)} ->
          Logger.warning(
            "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) tried to send command after failure."
          )

          {:error, "Tried to send command after failure."}

        _, {:ok, comms_state(state: :completed)} ->
          Logger.warning(
            "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) tried to send command after completion."
          )

          {:error, "Tried to send command after completion."}

        _, {:ok, comms_state(state: :cache_removed)} ->
          Logger.warning(
            "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) tried to send command after cache removal."
          )

          {:error, "Tried to send command after cache removal."}

        fail_workflow_execution(), {:ok, comms_state(state: :initialized) = state} ->
          Logger.warning(
            "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) failed on initialization."
          )

          {:ok, comms_state(state, state: :failed)}

        complete_workflow_execution(), {:ok, comms_state(state: :initialized) = state} ->
          Logger.debug(
            "Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) completed after initialization."
          )

          {:ok, comms_state(state, state: :completed)}

        schedule_activity(seq: seq), {:ok, state} ->
          scheduled =
            comms_state(state, :scheduled_activities)
            |> Map.put(seq, %{scheduled: DateTime.utc_now()})

          {:ok, comms_state(state, state: :scheduled_activities, scheduled_activities: scheduled)}

        start_timer(seq: seq), {:ok, state} ->
          started_timers =
            comms_state(state, :started_timers)
            |> Map.put(seq, %{started: DateTime.utc_now()})

          {:ok, comms_state(state, started_timers: started_timers)}

        fail_workflow_execution(), {:ok, state} ->
          Logger.debug("Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) failed.")
          {:ok, comms_state(state, state: :failed)}

        complete_workflow_execution(), {:ok, state} ->
          Logger.debug("Workflow (#{inspect(type)}, Run ID: #{inspect(run_id)}) completed.")
          {:ok, comms_state(state, state: :completed)}

        _, {:error, err} ->
          {:error, err}
      end)

    with {:ok, new_state} <- future_state do
      worker = comms_state(state, :worker)

      :ok =
        Worker.complete_workflow_activation(worker, completion(run_id: run_id, status: status))

      {:noreply, [], new_state}
    else
      {:error, err} ->
        {:stop, {:unexpected_command, err}}
    end
  end
end
