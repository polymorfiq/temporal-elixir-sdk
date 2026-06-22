defmodule Temporal.Workflow.WorkflowExecution do
  use GenStage

  require TemporalEngine.Data.Failure
  import Temporal.Workflow.WorkflowContext
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivationCompletion

  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  Record.defrecordp(:workflow_state, [
    :workflow_type,
    :arguments,
    :run_id,
    :workflow_id,
    :task_queue,
    :module,
    :exec_fn,
    awaiting_activity: %{},
    activity_results: %{},
    awaiting_timer: %{},
    fired_timers: %{},
    exec_ref: nil,
    exec_pid: nil,
    queued_commands: [],
    demand: 0,
    seq: 1
  ])

  @typep workflow_state ::
           record(:workflow_state,
             workflow_type: String.t(),
             arguments: [term()],
             run_id: String.t(),
             workflow_id: String.t(),
             task_queue: String.t(),
             module: module(),
             exec_fn: atom(),
             awaiting_activity: %{integer() => [pid()]},
             activity_results: %{integer() => term()},
             awaiting_timer: %{integer() => [pid()]},
             fired_timers: %{integer() => boolean()},
             exec_ref: reference() | nil,
             exec_pid: pid() | nil,
             activity_results: %{integer() => term()},
             queued_commands: [Commands.command()],
             demand: integer(),
             seq: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(
          {run_id :: String.t(), task_queue :: String.t(), module :: module(), exec_fn :: atom(),
           config :: Jobs.initialize_workflow()}
        ) :: {:producer, workflow_state()}
  def init({run_id, task_queue, module, exec_fn, config}) do
    Process.set_label({:workflow, run_id})

    {:producer,
     workflow_state(
       workflow_type: initialize_workflow(config, :workflow_type),
       arguments:
         initialize_workflow(config, :arguments) |> Enum.map(&Payload.value_from_record/1),
       run_id: run_id,
       workflow_id: initialize_workflow(config, :workflow_id),
       task_queue: task_queue,
       module: module,
       exec_fn: exec_fn
     )}
  end

  @spec process_job(pid(), Jobs.job()) :: :ok
  def process_job(pid, job), do: GenStage.cast(pid, job)

  @spec queue_commands(pid(), Commands.command()) :: {:ok, Commands.command()} | {:error, term()}
  def queue_command(pid, command) do
    with {:ok, cmds} <- queue_commands(pid, [command]) do
      {:ok, List.first(cmds)}
    end
  end

  @spec queue_commands(pid(), [Commands.command()]) ::
          {:ok, [Commands.command()]} | {:error, term()}
  def queue_commands(pid, commands),
    do: GenStage.call(pid, {:queue_commands, commands}, :infinity)

  @spec get_activity_results(pid(), seq :: pos_integer()) :: {:ok, term()} | {:error, term()}
  def get_activity_results(pid, seq),
    do: GenStage.call(pid, {:get_activity_results, seq}, :infinity)

  @spec wait_for_timer(pid(), seq :: pos_integer()) :: {:ok, term()} | {:error, term()}
  def wait_for_timer(pid, seq),
    do: GenStage.call(pid, {:wait_for_timer, seq}, :infinity)

  @doc false
  @spec handle_demand(integer(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_demand(demand, state) when demand > 0 do
    existing_demand = workflow_state(state, :demand)
    GenStage.async_info(self(), :execute_if_not_already)

    {:noreply, [], workflow_state(state, demand: existing_demand + demand)}
  end

  @doc false
  @spec handle_call(term(), {pid(), term()}, workflow_state()) ::
          {:noreply, list(), workflow_state()}
  def handle_call({:queue_commands, commands}, from, state) do
    seq = workflow_state(state, :seq)

    {commands, seq} =
      Enum.reduce(commands, {[], seq}, fn
        start_timer() = cmd, {cmds, seq} ->
          {cmds ++ [start_timer(cmd, seq: seq)], seq + 1}

        schedule_activity() = cmd, {cmds, seq} ->
          {cmds ++ [schedule_activity(cmd, seq: seq, activity_id: "#{seq}")], seq + 1}

        schedule_local_activity() = cmd, {cmds, seq} ->
          {cmds ++ [schedule_local_activity(cmd, seq: seq, activity_id: "#{seq}")], seq + 1}

        other, {cmds, seq} ->
          {cmds ++ [other], seq}
      end)

    queued = workflow_state(state, :queued_commands)
    GenStage.reply(from, {:ok, commands})

    wrapped = Enum.map(commands, &command(variant: &1))

    {:noreply, [], workflow_state(state, seq: seq, queued_commands: queued ++ wrapped)}
  end

  def handle_call({:get_activity_results, seq}, from, state) do
    results = workflow_state(state, :activity_results)

    if Map.has_key?(results, seq) do
      GenStage.reply(from, Map.fetch!(results, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_activity)
      awaiting = Map.get(all_awaiting, seq, [])
      queued_commands = workflow_state(state, :queued_commands)

      # If we're waiting to schedule events or something, let's tell Temporal Server.
      # If we're not, don't send an update to Temporal Server.
      events =
        if Enum.any?(queued_commands),
          do: [success(commands: queued_commands)],
          else: []

      {:noreply, events,
       workflow_state(state,
         queued_commands: [],
         awaiting_activity: Map.put(all_awaiting, seq, [from | awaiting])
       )}
    end
  end

  def handle_call({:wait_for_timer, seq}, from, state) do
    fired = workflow_state(state, :fired_timers)

    if Map.has_key?(fired, seq) do
      GenStage.reply(from, :ok)
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_timer)
      awaiting = Map.get(all_awaiting, seq, [])
      queued_commands = workflow_state(state, :queued_commands)

      {:noreply, [success(commands: queued_commands)],
       workflow_state(state,
         queued_commands: [],
         awaiting_timer: Map.put(all_awaiting, seq, [from | awaiting])
       )}
    end
  end

  def handle_cast(
        job(variant: resolve_activity(seq: seq, result: activity_resolution(status: status))),
        state
      ) do
    all_awaiting = workflow_state(state, :awaiting_activity)
    awaiting_this = Map.get(all_awaiting, seq, [])

    result =
      case status do
        activity_completed(result: result) ->
          {:ok, Payload.value_from_record(result)}

        activity_failed(failure: failure) ->
          {:error, Failure.failure(failure, :message)}

        activity_cancelled(failure: failure) ->
          {:error, {:cancelled, Failure.failure(failure, :message)}}
      end

    Enum.each(awaiting_this, fn awaiter ->
      GenStage.reply(awaiter, result)
    end)

    results = workflow_state(state, :activity_results)
    results = Map.put(results, seq, result)

    {:noreply, [],
     workflow_state(state,
       activity_results: results,
       awaiting_activity: Map.delete(all_awaiting, seq)
     )}
  end

  def handle_cast(job(variant: fire_timer(seq: seq)), state) do
    all_awaiting = workflow_state(state, :awaiting_timer)
    awaiting_this = Map.get(all_awaiting, seq, [])

    Enum.each(awaiting_this, fn awaiter ->
      GenStage.reply(awaiter, :ok)
    end)

    fired = workflow_state(state, :fired_timers)
    fired = Map.put(fired, seq, true)

    {:noreply, [],
     workflow_state(state, fired_timers: fired, awaiting_timer: Map.delete(all_awaiting, seq))}
  end

  def handle_cast({:workflow_completed, resp}, state) do
    with {:ok, result} <- resp do
      status =
        success(
          commands: [
            command(
              variant: complete_workflow_execution(result: Payload.record_from_value(result))
            )
          ]
        )

      {:noreply, [status], state}
    else
      {:error, Failure.application() = app_error} ->
        failure =
          Failure.failure(
            message: "Returned {:error, ApplicationFailure}",
            source: "elixir-sdk",
            stack_trace: "",
            failure_info: app_error
          )

        status = success(commands: [command(variant: fail_workflow_execution(failure: failure))])
        {:noreply, [status], state}

      {:error, err} ->
        failure =
          Failure.failure(
            message: "{:error, #{inspect(err)}}",
            source: "elixir-sdk",
            stack_trace: "",
            failure_info:
              Failure.application(
                failure_type: "ReturnedError",
                details: [Payload.record_from_value(err)]
              )
          )

        status = success(commands: [command(variant: fail_workflow_execution(failure: failure))])
        {:noreply, [status], state}
    end
  end

  @doc false
  @spec handle_info(term(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_info(:execute_if_not_already, workflow_state(exec_ref: ref) = state)
      when is_reference(ref) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, workflow_state(demand: 0) = state) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, state) do
    module = workflow_state(state, :module)
    exec_fn = workflow_state(state, :exec_fn)
    arguments = workflow_state(state, :arguments)

    ctx =
      workflow_context(
        execution: self(),
        task_queue: workflow_state(state, :task_queue),
        run_id: workflow_state(state, :run_id),
        workflow_id: workflow_state(state, :workflow_id)
      )

    parent = self()

    {exec_pid, exec_ref} =
      spawn_monitor(fn ->
        resp = apply(module, exec_fn, [ctx | arguments])

        GenStage.cast(parent, {:workflow_completed, resp})
      end)

    {:noreply, [], workflow_state(state, exec_pid: exec_pid, exec_ref: exec_ref)}
  end

  def handle_info(
        {:DOWN, exec_ref, :process, _, :normal},
        workflow_state(exec_ref: exec_ref) = state
      ) do
    type = workflow_state(state, :workflow_type)
    workflow_id = workflow_state(state, :workflow_id)
    run_id = workflow_state(state, :run_id)

    Logger.debug(
      "Workflow execution halted: (#{inspect(type)}, Run: #{inspect(run_id)}, ID: #{inspect(workflow_id)})"
    )

    {:noreply, [], workflow_state(state, exec_pid: nil, exec_ref: nil)}
  end

  def handle_info(
        {:DOWN, exec_ref, :process, _, {%error_type{} = err, stacktrace}},
        workflow_state(exec_ref: exec_ref) = state
      ) do
    failure =
      Failure.failure(
        message: Exception.message(err),
        source: "elixir-sdk",
        stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
        failure_info: Failure.application(failure_type: "#{error_type}")
      )

    status = success(commands: [command(variant: fail_workflow_execution(failure: failure))])
    {:noreply, [status], workflow_state(state, exec_pid: nil, exec_ref: nil)}
  end
end
