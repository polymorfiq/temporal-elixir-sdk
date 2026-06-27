defmodule Temporal.Workflow.WorkflowExecution do
  use GenStage

  require TemporalEngine.Data.Failure
  import Temporal.WorkflowContext
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivationCompletion

  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Timestamp

  require Logger
  require Record

  Record.defrecordp(:workflow_state, [
    :workflow_type,
    :arguments,
    :run_id,
    :workflow_id,
    :task_queue,
    :namespace,
    :module,
    :exec_fn,
    :timestamp,
    unlocked_in_activation: 0,
    query_handlers: %{},
    awaiting_activity: %{},
    activity_results: %{},
    awaiting_timer: %{},
    fired_timers: %{},
    awaiting_child_workflow_starts: %{},
    child_workflow_starts: %{},
    awaiting_child_workflows: %{},
    child_workflow_results: %{},
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
             namespace: String.t(),
             module: module(),
             exec_fn: atom(),
             timestamp: DateTime.t(),
             unlocked_in_activation: non_neg_integer(),
             query_handlers: %{String.t() => fun()},
             awaiting_activity: %{integer() => [pid()]},
             activity_results: %{integer() => term()},
             awaiting_timer: %{integer() => [pid()]},
             fired_timers: %{integer() => boolean()},
             awaiting_child_workflow_starts: %{integer() => [pid()]},
             child_workflow_starts: %{integer() => {:ok, String.t()} | {:error, term()}},
             exec_ref: reference() | nil,
             exec_pid: pid() | nil,
             activity_results: %{integer() => term()},
             queued_commands: [Commands.command()],
             demand: integer(),
             seq: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(
          {run_id :: String.t(), task_queue :: String.t(), namespace :: String.t(),
           module :: module(), exec_fn :: atom(), config :: Jobs.initialize_workflow()}
        ) :: {:producer, workflow_state()}
  def init({run_id, task_queue, namespace, module, exec_fn, config}) do
    Process.set_label({:workflow, run_id})

    {:producer,
     workflow_state(
       workflow_type: initialize_workflow(config, :workflow_type),
       arguments:
         initialize_workflow(config, :arguments) |> Enum.map(&Payload.value_from_record/1),
       run_id: run_id,
       workflow_id: initialize_workflow(config, :workflow_id),
       task_queue: task_queue,
       namespace: namespace,
       module: module,
       exec_fn: exec_fn,
       timestamp: initialize_workflow(config, :start_time) |> Timestamp.to_native()
     )}
  end

  @spec process_job(pid(), Jobs.job()) :: :ok
  def process_job(pid, job), do: GenStage.cast(pid, job)

  @spec activation_started(pid()) :: :ok
  def activation_started(pid), do: GenStage.cast(pid, :activation_started)

  @spec activation_completed(pid()) :: :ok
  def activation_completed(pid), do: GenStage.cast(pid, :activation_completed)

  @spec queue_commands(pid(), Commands.command()) :: {:ok, Commands.command()} | {:error, term()}
  def queue_command(pid, command) do
    with {:ok, cmds} <- queue_commands(pid, [command]) do
      {:ok, List.first(cmds)}
    end
  end

  @spec set_is_replaying(pid(), boolean()) :: :ok
  def set_is_replaying(pid, replaying), do: GenStage.cast(pid, {:set_is_replaying, replaying})

  @spec set_current_timestamp(pid(), DateTime.t()) :: :ok
  def set_current_timestamp(pid, ts), do: GenStage.cast(pid, {:set_current_timestamp, ts})

  @spec get_current_timestamp(pid()) :: DateTime.t()
  def get_current_timestamp(pid), do: GenStage.call(pid, :get_current_timestamp, :infinity)

  @spec set_query_handler(pid(), name :: String.t(), handler :: fun()) :: :ok
  def set_query_handler(pid, name, handler) do
    GenStage.cast(pid, {:set_query_handler, name, handler})
  end

  @spec queue_commands(pid(), [Commands.command()]) ::
          {:ok, [Commands.command()]} | {:error, term()}
  def queue_commands(pid, commands),
    do: GenStage.call(pid, {:queue_commands, commands}, :infinity)

  @spec get_activity_results(pid(), seq :: pos_integer()) :: {:ok, term()} | {:error, term()}
  def get_activity_results(pid, seq) do
    GenStage.call(pid, {:get_activity_results, seq}, :infinity)
  end

  @spec get_child_workflow_result(pid(), seq :: pos_integer()) :: {:ok, term()} | {:error, term()}
  def get_child_workflow_result(pid, seq),
    do: GenStage.call(pid, {:get_child_workflow_result, seq}, :infinity)

  @spec get_child_workflow(pid(), seq :: pos_integer()) :: {:ok, term()} | {:error, term()}
  def get_child_workflow(pid, seq),
    do: GenStage.call(pid, {:get_child_workflow, seq}, :infinity)

  @spec wait_for_timer(pid(), seq :: pos_integer()) :: :ok | {:error, term()}
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

        start_child_workflow_execution() = cmd, {cmds, seq} ->
          {cmds ++ [start_child_workflow_execution(cmd, seq: seq)], seq + 1}

        other, {cmds, seq} ->
          {cmds ++ [other], seq}
      end)

    queued = workflow_state(state, :queued_commands)
    GenStage.reply(from, {:ok, commands})

    wrapped = Enum.map(commands, &command(variant: &1))

    {:noreply, [], workflow_state(state, seq: seq, queued_commands: queued ++ wrapped)}
  end

  def handle_call(:get_current_timestamp, _from, state) do
    {:reply, workflow_state(state, :timestamp), [], state}
  end

  def handle_call({:get_activity_results, seq}, from, state) do
    results = workflow_state(state, :activity_results)

    if Map.has_key?(results, seq) do
      GenStage.reply(from, Map.fetch!(results, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_activity)
      awaiting = Map.get(all_awaiting, seq, [])

      send(self(), :flush_queued_commands)

      {:noreply, [],
       workflow_state(state, awaiting_activity: Map.put(all_awaiting, seq, [from | awaiting]))}
    end
  end

  def handle_call({:get_child_workflow, seq}, from, state) do
    starts = workflow_state(state, :child_workflow_starts)

    if Map.has_key?(starts, seq) do
      GenStage.reply(from, Map.fetch!(starts, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_child_workflow_starts)
      awaiting = Map.get(all_awaiting, seq, [])

      send(self(), :flush_queued_commands)

      {:noreply, [],
       workflow_state(state,
         awaiting_child_workflow_starts: Map.put(all_awaiting, seq, [from | awaiting])
       )}
    end
  end

  def handle_call({:get_child_workflow_result, seq}, from, state) do
    results = workflow_state(state, :child_workflow_results)

    if Map.has_key?(results, seq) do
      GenStage.reply(from, Map.fetch!(results, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_child_workflows)
      awaiting = Map.get(all_awaiting, seq, [])

      send(self(), :flush_queued_commands)

      {:noreply, [],
       workflow_state(state,
         awaiting_child_workflows: Map.put(all_awaiting, seq, [from | awaiting])
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
      send(self(), :flush_queued_commands)

      {:noreply, [],
       workflow_state(state, awaiting_timer: Map.put(all_awaiting, seq, [from | awaiting]))}
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

    unlocked = workflow_state(state, :unlocked_in_activation) + Enum.count(awaiting_this)

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
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

    unlocked = workflow_state(state, :unlocked_in_activation) + Enum.count(awaiting_this)

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       fired_timers: fired,
       awaiting_timer: Map.delete(all_awaiting, seq)
     )}
  end

  def handle_cast(
        job(variant: resolve_child_workflow_execution_start(seq: seq, status: status)),
        state
      ) do
    all_awaiting = workflow_state(state, :awaiting_child_workflow_starts)
    awaiting_this = Map.get(all_awaiting, seq, [])

    resp =
      case status do
        child_workflow_start_succeeded(run_id: run_id) ->
          {:ok, run_id}

        child_workflow_start_failed(cause: cause) ->
          {:error, cause}

        child_workflow_start_cancelled(failure: failure) ->
          {:error, Failure.to_map(failure)}
      end

    Enum.each(awaiting_this, fn awaiter ->
      GenStage.reply(awaiter, resp)
    end)

    starts = workflow_state(state, :child_workflow_starts)
    starts = Map.put(starts, seq, resp)
    unlocked = workflow_state(state, :unlocked_in_activation) + Enum.count(awaiting_this)

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       child_workflow_starts: starts,
       awaiting_child_workflow_starts: Map.delete(all_awaiting, seq)
     )}
  end

  def handle_cast(job(variant: resolve_child_workflow_execution(seq: seq, status: status)), state) do
    all_awaiting = workflow_state(state, :awaiting_child_workflows)
    awaiting_this = Map.get(all_awaiting, seq, [])

    resp =
      case status do
        child_workflow_result(status: child_workflow_completed(result: result)) ->
          {:ok, Payload.value_from_record(result)}

        child_workflow_result(status: child_workflow_failed(failure: failure)) ->
          {:error, Failure.to_map(failure)}

        child_workflow_result(status: child_workflow_cancelled(failure: failure)) ->
          {:error, Failure.to_map(failure)}
      end

    Enum.each(awaiting_this, fn awaiter ->
      GenStage.reply(awaiter, resp)
    end)

    results = workflow_state(state, :child_workflow_results)
    results = Map.put(results, seq, resp)
    unlocked = workflow_state(state, :unlocked_in_activation) + Enum.count(awaiting_this)

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       child_workflow_results: results,
       awaiting_child_workflows: Map.delete(all_awaiting, seq)
     )}
  end

  def handle_cast(
        job(variant: query_workflow(query_id: query_id, query_type: query_type, arguments: args)),
        state
      ) do
    args = Enum.map(args, &Payload.value_from_record/1)
    handlers = workflow_state(state, :query_handlers)

    resp =
      if handler = Map.get(handlers, {"#{query_type}", Enum.count(args)}) do
        try do
          apply(handler, args)
        rescue
          err ->
            {:error, {:exception, err, __STACKTRACE__}}
        end
      else
        {:error, :handler_not_found}
      end

    variant =
      with {:ok, result} <- resp do
        query_success(response: Payload.record_from_value(result))
      else
        {:error, :handler_not_found} ->
          Failure.failure(
            message: "Query handler (#{inspect(query_type)}/#{Enum.count(args)}) not found.",
            source: "elixir-sdk",
            stack_trace: "",
            failure_info:
              Failure.application(failure_type: "HandlerNotFound", non_retryable: true)
          )

        {:error, Failure.application() = app_error} ->
          query_success(
            response:
              Payload.record_from_value(
                {:error,
                 Failure.failure(
                   message: Failure.application(app_error, :failure_type),
                   source: "elixir-sdk",
                   stack_trace: "",
                   failure_info: app_error
                 )}
              )
          )

        {:error, {:exception, Failure.application() = app_error, stacktrace}} ->
          query_success(
            response:
              Payload.record_from_value(
                {:error,
                 Failure.failure(
                   message: Failure.application(app_error, :failure_type),
                   source: "elixir-sdk",
                   stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                   failure_info: app_error
                 )}
              )
          )

        {:error, {:exception, %ex_type{} = exception, stacktrace}} ->
          query_success(
            response:
              Payload.record_from_value(
                {:error,
                 Failure.failure(
                   message: inspect(exception),
                   source: "elixir-sdk",
                   stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                   failure_info: Failure.application(failure_type: "#{ex_type}")
                 )}
              )
          )

        {:error, err} ->
          query_success(response: Payload.record_from_value({:error, err}))
      end

    status =
      success(
        commands: [command(variant: respond_to_query(query_id: query_id, variant: variant))]
      )

    {:noreply, [status], state}
  end

  def handle_cast(:activation_started, state) do
    {:noreply, [], workflow_state(state, unlocked_in_activation: 0)}
  end

  def handle_cast(:activation_completed, state) do
    unlocked = workflow_state(state, :unlocked_in_activation)

    if unlocked == 0 && awaiting_process_count(state) > 0 do
      send(self(), :flush_queued_commands)
    end

    {:noreply, [], state}
  end

  def handle_cast({:set_is_replaying, replaying}, state) do
    if replaying, do: Logger.disable(self()), else: Logger.enable(self())
    {:noreply, [], state}
  end

  def handle_cast({:set_current_timestamp, ts}, state) do
    {:noreply, [], workflow_state(state, timestamp: ts)}
  end

  def handle_cast({:set_query_handler, name, handler}, state) do
    handlers = workflow_state(state, :query_handlers)
    {:arity, arity} = Function.info(handler, :arity)

    handlers = Map.put(handlers, {"#{name}", arity}, handler)
    {:noreply, [], workflow_state(state, query_handlers: handlers)}
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
        namespace: workflow_state(state, :namespace),
        run_id: workflow_state(state, :run_id),
        workflow_id: workflow_state(state, :workflow_id)
      )

    parent = self()

    {exec_pid, exec_ref} =
      spawn_monitor(fn ->
        resp =
          try do
            apply(module, exec_fn, [ctx | arguments])
          rescue
            err ->
              {:error, err}
          end

        GenStage.cast(parent, {:workflow_completed, resp})
      end)

    {:noreply, [], workflow_state(state, exec_pid: exec_pid, exec_ref: exec_ref)}
  end

  def handle_info(:flush_queued_commands, state) do
    queued_commands = workflow_state(state, :queued_commands)

    {:noreply,
     [
       success(commands: queued_commands)
     ], workflow_state(state, queued_commands: []), :hibernate}
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

  defp awaiting_process_count(state) do
    awaiting_activities =
      workflow_state(state, :awaiting_activity)
      |> Enum.flat_map(fn {_seq, awaiting} -> awaiting end)

    awaiting_timers =
      workflow_state(state, :awaiting_timer) |> Enum.flat_map(fn {_seq, awaiting} -> awaiting end)

    awaiting_child_starts =
      workflow_state(state, :awaiting_child_workflow_starts)
      |> Enum.flat_map(fn {_seq, awaiting} -> awaiting end)

    awaiting_children =
      workflow_state(state, :awaiting_child_workflows)
      |> Enum.flat_map(fn {_seq, awaiting} -> awaiting end)

    Enum.count(awaiting_activities) + Enum.count(awaiting_timers) +
      Enum.count(awaiting_child_starts) + Enum.count(awaiting_children)
  end
end
