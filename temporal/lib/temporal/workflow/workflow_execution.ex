defmodule Temporal.Workflow.WorkflowExecution do
  use GenStage

  require TemporalEngine.Data.Activation
  require TemporalEngine.Data.Failure
  import Temporal.WorkflowContext
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivationCompletion

  alias Temporal.WorkflowContext
  alias Temporal.Workflow.WorkflowRuntime
  alias TemporalEngine.Data.Activation
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  @type update_handler_opts :: [{:validator, (... -> :ok | {:error, term()})}]

  Record.defrecordp(:workflow_state, [
    :workflow_type,
    :arguments,
    :run_id,
    :workflow_id,
    :task_queue,
    :namespace,
    :module,
    :exec_fn,
    :initialize_config,
    :context,
    :runtime,
    :started_at,
    runtime_sub: nil,
    current_task_metadata: nil,
    unlocked_in_activation: 0,
    query_handlers: %{},
    update_handlers: %{},
    signal_handlers: %{},
    awaiting_checks: %{},
    awaiting_activity: %{},
    activity_results: %{},
    awaiting_timer: %{},
    fired_timers: %{},
    awaiting_child_workflow_starts: %{},
    child_workflow_starts: %{},
    awaiting_child_workflows: %{},
    child_workflow_results: %{},
    executing: false,
    queued_commands: [],
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
             context: WorkflowContext.workflow_context(),
             runtime: pid(),
             started_at: DateTime.t(),
             runtime_sub: {pid(), reference()} | nil,
             initialize_config: Jobs.initialize_workflow(),
             unlocked_in_activation: non_neg_integer(),
             query_handlers: %{String.t() => fun()},
             update_handlers: %{String.t() => %{handler: fun(), validator: fun() | nil}},
             signal_handlers: %{String.t() => fun()},
             awaiting_checks: %{pid() => (-> boolean())},
             awaiting_activity: %{integer() => [pid()]},
             activity_results: %{integer() => term()},
             awaiting_timer: %{integer() => [pid()]},
             fired_timers: %{integer() => boolean()},
             awaiting_child_workflow_starts: %{integer() => [pid()]},
             child_workflow_starts: %{integer() => {:ok, String.t()} | {:error, term()}},
             executing: boolean(),
             activity_results: %{integer() => term()},
             queued_commands: [Commands.command()],
             seq: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(
          {run_id :: String.t(), task_queue :: String.t(), namespace :: String.t(),
           module :: module(), exec_fn :: atom(), config :: Jobs.initialize_workflow(),
           Activation.activation()}
        ) :: {:producer_consumer, workflow_state(), keyword()}
  def init({run_id, task_queue, namespace, module, exec_fn, config, activate}) do
    Process.set_label({:workflow, run_id})

    {:ok, ctx_pid} = GenServer.start_link(WorkflowContext, activate)
    {:ok, runtime} = GenStage.start_link(WorkflowRuntime, self())

    context =
      workflow_context(
        execution: self(),
        context: ctx_pid,
        runtime: runtime,
        task_queue: task_queue,
        namespace: namespace,
        run_id: run_id,
        workflow_id: initialize_workflow(config, :workflow_id),
        initialize_config: config
      )

    {:producer_consumer,
     workflow_state(
       workflow_type: initialize_workflow(config, :workflow_type),
       arguments:
         initialize_workflow(config, :arguments) |> Enum.map(&Payload.value_from_record/1),
       run_id: run_id,
       context: context,
       runtime: runtime,
       workflow_id: initialize_workflow(config, :workflow_id),
       task_queue: task_queue,
       namespace: namespace,
       module: module,
       exec_fn: exec_fn,
       initialize_config: config,
       started_at: DateTime.utc_now()
     ), [subscribe_to: [runtime]]}
  end

  @spec process_job(pid(), Jobs.job()) :: :ok
  def process_job(pid, job), do: GenStage.cast(pid, job)

  @spec activation_started(pid(), Activation.activation()) :: :ok
  def activation_started(pid, activation),
    do: GenStage.cast(pid, {:activation_started, activation})

  @spec activation_completed(pid()) :: :ok
  def activation_completed(pid), do: GenStage.cast(pid, :activation_completed)

  @spec queue_commands(pid(), Commands.command()) :: {:ok, Commands.command()} | {:error, term()}
  def queue_command(pid, command) do
    with {:ok, cmds} <- queue_commands(pid, [command]) do
      {:ok, List.first(cmds)}
    end
  end

  @spec await(pid(), (-> boolean())) :: :ok
  def await(pid, await_check) do
    GenStage.call(pid, {:await, await_check}, :infinity)
  end

  @spec unlocked_await_checks(pid()) :: [{pid(), reference()}]
  def unlocked_await_checks(pid) do
    GenStage.call(pid, :unlocked_await_checks, :infinity)
  end

  @spec set_current_task_metadata(pid(), map()) :: :ok
  def set_current_task_metadata(pid, metadata),
    do: GenStage.cast(pid, {:set_current_task_metadata, metadata})

  @spec set_query_handler(pid(), name :: String.t(), handler :: fun()) :: :ok
  def set_query_handler(pid, name, handler) do
    GenStage.cast(pid, {:set_query_handler, name, handler})
  end

  @spec set_update_handler(pid(), name :: String.t(), handler :: fun(), update_handler_opts()) ::
          :ok
  def set_update_handler(pid, name, handler, opts) do
    GenStage.cast(pid, {:set_update_handler, name, handler, opts})
  end

  @spec set_signal_handler(pid(), name :: String.t(), handler :: fun()) :: :ok
  def set_signal_handler(pid, name, handler) do
    GenStage.cast(pid, {:set_signal_handler, name, handler})
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
  @spec handle_call(term(), {pid(), term()}, workflow_state()) ::
          {:noreply, list(), workflow_state()}

  def handle_call({:await, await_check}, from, state) do
    awaiting = workflow_state(state, :awaiting_checks)

    runtime = workflow_state(state, :runtime)

    if await_check.() do
      GenStage.reply(from, :ok)
      {:noreply, [], state}
    else
      WorkflowRuntime.locked(runtime, from)

      {:noreply, [], workflow_state(state, awaiting_checks: Map.put(awaiting, from, await_check))}
    end
  end

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

  def handle_call({:get_activity_results, seq}, from, state) do
    results = workflow_state(state, :activity_results)

    runtime = workflow_state(state, :runtime)

    if Map.has_key?(results, seq) do
      GenStage.reply(from, Map.fetch!(results, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_activity)
      awaiting = Map.get(all_awaiting, seq, [])
      WorkflowRuntime.locked(runtime, from)

      {:noreply, [],
       workflow_state(state, awaiting_activity: Map.put(all_awaiting, seq, [from | awaiting]))}
    end
  end

  def handle_call({:get_child_workflow, seq}, from, state) do
    starts = workflow_state(state, :child_workflow_starts)

    runtime = workflow_state(state, :runtime)

    if Map.has_key?(starts, seq) do
      GenStage.reply(from, Map.fetch!(starts, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_child_workflow_starts)
      awaiting = Map.get(all_awaiting, seq, [])
      WorkflowRuntime.locked(runtime, from)

      {:noreply, [],
       workflow_state(state,
         awaiting_child_workflow_starts: Map.put(all_awaiting, seq, [from | awaiting])
       )}
    end
  end

  def handle_call({:get_child_workflow_result, seq}, from, state) do
    results = workflow_state(state, :child_workflow_results)

    runtime = workflow_state(state, :runtime)

    if Map.has_key?(results, seq) do
      GenStage.reply(from, Map.fetch!(results, seq))
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_child_workflows)
      awaiting = Map.get(all_awaiting, seq, [])
      WorkflowRuntime.locked(runtime, from)

      {:noreply, [],
       workflow_state(state,
         awaiting_child_workflows: Map.put(all_awaiting, seq, [from | awaiting])
       )}
    end
  end

  def handle_call({:wait_for_timer, seq}, from, state) do
    fired = workflow_state(state, :fired_timers)

    runtime = workflow_state(state, :runtime)

    if Map.has_key?(fired, seq) do
      GenStage.reply(from, :ok)
      {:noreply, [], state}
    else
      all_awaiting = workflow_state(state, :awaiting_timer)
      awaiting = Map.get(all_awaiting, seq, [])
      WorkflowRuntime.locked(runtime, from)

      {:noreply, [],
       workflow_state(state, awaiting_timer: Map.put(all_awaiting, seq, [from | awaiting]))}
    end
  end

  def handle_call(:unlocked_await_checks, from, state) do
    {new_awaiting, unlocked} =
      workflow_state(state, :awaiting_checks)
      |> Enum.reduce({%{}, []}, fn {awaiter, await_check}, {awaiting, unlocked} ->
        if await_check.() do
          {awaiting, [awaiter | unlocked]}
        else
          {Map.put(awaiting, awaiter, await_check), unlocked}
        end
      end)

    GenStage.reply(from, unlocked)

    {:noreply, [], workflow_state(state, awaiting_checks: new_awaiting)}
  end

  def handle_cast(job(variant: initialize_workflow()), state) do
    {:noreply, [], state}
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

    runtime = workflow_state(state, :runtime)

    Enum.each(awaiting_this, fn awaiter ->
      WorkflowRuntime.unlocked(runtime, awaiter, result)
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

  def handle_cast(job(variant: update_random_seed()), state) do
    Logger.warning("update_random_seed called when not yet implemented.")
    {:noreply, [], state}
  end

  def handle_cast(job(variant: fire_timer(seq: seq)), state) do
    all_awaiting = workflow_state(state, :awaiting_timer)
    awaiting_this = Map.get(all_awaiting, seq, [])

    runtime = workflow_state(state, :runtime)

    Enum.each(awaiting_this, fn awaiter ->
      WorkflowRuntime.unlocked(runtime, awaiter, :ok)
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

    runtime = workflow_state(state, :runtime)

    Enum.each(awaiting_this, fn awaiter ->
      WorkflowRuntime.unlocked(runtime, awaiter, resp)
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

    runtime = workflow_state(state, :runtime)

    Enum.each(awaiting_this, fn awaiter ->
      WorkflowRuntime.unlocked(runtime, awaiter, resp)
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
    runtime = workflow_state(state, :runtime)

    WorkflowRuntime.register(
      runtime,
      :query,
      fn ->
        if handler = Map.get(handlers, {"#{query_type}", Enum.count(args)}) do
          apply(handler, args)
        else
          {:error, :handler_not_found}
        end
      end,
      on_crash: fn
        %ex_type{} = exception, stacktrace ->
          [
            command(
              variant:
                respond_to_query(
                  query_id: query_id,
                  variant:
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
                )
            )
          ]
      end,
      on_complete: fn
        {:ok, result} ->
          [
            command(
              variant:
                respond_to_query(
                  query_id: query_id,
                  variant: query_success(response: Payload.record_from_value(result))
                )
            )
          ]

        {:error, err} ->
          [
            command(
              variant:
                respond_to_query(
                  query_id: query_id,
                  variant: query_success(response: Payload.record_from_value({:error, err}))
                )
            )
          ]
      end
    )

    {:noreply, [], state}
  end

  def handle_cast(job(variant: signal_workflow(signal_name: signal_name, input: args)), state) do
    args = Enum.map(args, &Payload.value_from_record/1)
    handlers = workflow_state(state, :signal_handlers)
    ctx = workflow_state(state, :context)
    runtime = workflow_state(state, :runtime)

    WorkflowRuntime.register(
      runtime,
      :signal,
      fn ->
        if handler = Map.get(handlers, {"#{signal_name}", Enum.count(args) + 1}) do
          apply(handler, [ctx | args])
        else
          {:error, :handler_not_found}
        end
      end,
      on_crash: fn
        exception, stacktrace ->
          Logger.warning(
            "Signal #{inspect(signal_name)} crashed: #{inspect(exception)}\n#{Exception.format_stacktrace(stacktrace)}"
          )

          []
      end,
      on_complete: fn _response -> [] end
    )

    {:noreply, [], state}
  end

  def handle_cast(
        job(
          variant:
            do_update(
              protocol_instance_id: protocol_id,
              name: update_name,
              input: args,
              run_validator: validate?
            )
        ),
        state
      ) do
    args = Enum.map(args, &Payload.value_from_record/1)
    handlers = workflow_state(state, :update_handlers)
    ctx = workflow_state(state, :context)

    runtime = workflow_state(state, :runtime)

    WorkflowRuntime.register(
      runtime,
      :update,
      fn ->
        if details = Map.get(handlers, {"#{update_name}", Enum.count(args) + 1}) do
          validate_resp =
            try do
              if validate? && details.validator do
                apply(details.validator, [ctx | args])
              else
                :ok
              end
            rescue
              exception ->
                {:error, {:exception, exception, __STACKTRACE__}}
            end

          with :ok <- validate_resp do
            apply(details.handler, [ctx | args])
          else
            {:error, err} ->
              {:error, {:validation_error, err}}
          end
        else
          {:error, :handler_not_found}
        end
      end,
      on_crash: fn
        %ex_type{} = exception, stacktrace ->
          [
            command(
              variant:
                update_response(protocol_instance_id: protocol_id, response: update_accepted())
            ),
            command(
              variant:
                update_response(
                  protocol_instance_id: protocol_id,
                  response:
                    update_rejected(
                      failure:
                        Failure.failure(
                          message: inspect(exception),
                          source: "elixir-sdk",
                          stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                          failure_info: Failure.application(failure_type: "#{ex_type}")
                        )
                    )
                )
            )
          ]
      end,
      on_complete: fn
        {:ok, result} ->
          [
            command(
              variant:
                update_response(protocol_instance_id: protocol_id, response: update_accepted())
            ),
            command(
              variant:
                update_response(
                  protocol_instance_id: protocol_id,
                  response: update_completed(payload: Payload.record_from_value(result))
                )
            )
          ]

        {:error, {:validation_error, {:exception, exception, stacktrace}}} ->
          [
            command(
              variant:
                update_response(
                  protocol_instance_id: protocol_id,
                  response:
                    update_rejected(
                      failure:
                        Failure.failure(
                          message: Exception.message(exception),
                          source: "elixir-sdk",
                          stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                          failure_info:
                            Failure.application(
                              failure_type: "ValidationException",
                              non_retryable: true
                            )
                        )
                    )
                )
            )
          ]

        {:error, {:validation_error, err}} ->
          [
            command(
              variant:
                update_response(
                  protocol_instance_id: protocol_id,
                  response:
                    update_rejected(
                      failure:
                        Failure.failure(
                          message: "{:validation_error, #{inspect(err)}}",
                          source: "elixir-sdk",
                          stack_trace: "",
                          failure_info:
                            Failure.application(
                              failure_type: "ValidationReturnedError",
                              details: [Payload.record_from_value({:error, err})],
                              non_retryable: true
                            )
                        )
                    )
                )
            )
          ]

        {:error, err} ->
          [
            command(
              variant:
                update_response(protocol_instance_id: protocol_id, response: update_accepted())
            ),
            command(
              variant:
                update_response(
                  protocol_instance_id: protocol_id,
                  response:
                    update_rejected(
                      failure:
                        Failure.failure(
                          message: "{:error, #{inspect(err)}}",
                          source: "elixir-sdk",
                          stack_trace: "",
                          failure_info:
                            Failure.application(
                              failure_type: "UpdateReturnedError",
                              details: [Payload.record_from_value({:error, err})]
                            )
                        )
                    )
                )
            )
          ]
      end
    )

    {:noreply, [], state}
  end

  def handle_cast({:activation_started, activate}, state) do
    ctx = workflow_state(state, :context)
    WorkflowContext.update_for_activation(ctx, activate)

    {:noreply, [], workflow_state(state, unlocked_in_activation: 0)}
  end

  def handle_cast(:activation_completed, state) do
    GenStage.async_info(self(), {:demand_from_runtime, 1})
    {:noreply, [], state}
  end

  def handle_cast({:set_current_task_metadata, metadata}, state) do
    if metadata[:is_replaying], do: Logger.disable(self()), else: Logger.enable(self())

    {:noreply, [], workflow_state(state, current_task_metadata: metadata)}
  end

  def handle_cast({:set_query_handler, name, handler}, state) do
    handlers = workflow_state(state, :query_handlers)
    {:arity, arity} = Function.info(handler, :arity)

    handlers = Map.put(handlers, {"#{name}", arity}, handler)
    {:noreply, [], workflow_state(state, query_handlers: handlers)}
  end

  def handle_cast({:set_update_handler, name, handler, opts}, state) do
    handlers = workflow_state(state, :update_handlers)
    {:arity, arity} = Function.info(handler, :arity)

    validator =
      if validator = Keyword.get(opts, :validator) do
        {:arity, validator_arity} = Function.info(validator, :arity)

        if validator_arity != arity,
          do:
            "Invalid Update Handler Validator (#{inspect(name)}) - Expected arity (#{arity}) but got arity (#{validator_arity})"

        validator
      end

    handlers = Map.put(handlers, {"#{name}", arity}, %{handler: handler, validator: validator})
    {:noreply, [], workflow_state(state, update_handlers: handlers)}
  end

  def handle_cast({:set_signal_handler, name, handler}, state) do
    handlers = workflow_state(state, :signal_handlers)
    {:arity, arity} = Function.info(handler, :arity)

    handlers = Map.put(handlers, {"#{name}", arity}, handler)
    {:noreply, [], workflow_state(state, signal_handlers: handlers)}
  end

  def handle_subscribe(
        :producer,
        _options,
        {runtime, _} = from,
        workflow_state(runtime: runtime) = state
      ) do
    GenStage.async_info(self(), :execute_if_not_already)

    {:manual, workflow_state(state, runtime_sub: from)}
  end

  def handle_subscribe(_, _options, _from, state) do
    {:automatic, state}
  end

  def handle_events(command_batches, _, state) do
    queued_commands = workflow_state(state, :queued_commands)
    commands = queued_commands ++ Enum.flat_map(command_batches, & &1)
    {:noreply, [success(commands: commands)], workflow_state(state, queued_commands: [])}
  end

  @doc false
  @spec handle_info(term(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_info(:execute_if_not_already, workflow_state(executing: true) = state) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, state) do
    runtime = workflow_state(state, :runtime)
    :ok = GenStage.async_subscribe(self(), to: runtime)

    module = workflow_state(state, :module)
    exec_fn = workflow_state(state, :exec_fn)
    arguments = workflow_state(state, :arguments)

    ctx = workflow_state(state, :context)
    runtime = workflow_state(state, :runtime)

    execution = self()

    WorkflowRuntime.register(
      runtime,
      :workflow,
      fn ->
        apply(module, exec_fn, [ctx | arguments])
      end,
      on_crash: fn
        %ex_type{} = exception, stacktrace ->
          failure =
            Failure.failure(
              message: Exception.message(exception),
              source: "elixir-sdk",
              stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
              failure_info:
                Failure.application(
                  failure_type: "#{ex_type}",
                  details: [Payload.record_from_value(exception)]
                )
            )

          GenStage.async_info(execution, :execution_complete)
          [command(variant: fail_workflow_execution(failure: failure))]
      end,
      on_complete: fn
        {:ok, result} ->
          GenStage.async_info(execution, :execution_complete)

          init = workflow_state(state, :initialize_config)
          started_at = workflow_state(state, :started_at)

          :telemetry.execute(
            [:temporalio, :workflow, :completed],
            %{
              duration_microsecs: DateTime.diff(started_at, DateTime.utc_now(), :microsecond)
            },
            %{
              workflow_type: workflow_state(state, :workflow_type),
              namespace: workflow_state(state, :namespace),
              run_id: workflow_state(state, :run_id),
              workflow_id: initialize_workflow(init, :workflow_id),
              arguments: workflow_state(state, :arguments),
              result: result
            }
          )

          [
            command(
              variant: complete_workflow_execution(result: Payload.record_from_value(result))
            )
          ]

        {:error, Commands.continue_as_new_workflow_execution() = cmd} ->
          init = workflow_state(state, :initialize_config)
          started_at = workflow_state(state, :started_at)

          :telemetry.execute(
            [:temporalio, :workflow, :continue_as_new],
            %{
              duration_microsecs: DateTime.diff(started_at, DateTime.utc_now(), :microsecond)
            },
            %{
              workflow_type: workflow_state(state, :workflow_type),
              namespace: workflow_state(state, :namespace),
              run_id: workflow_state(state, :run_id),
              workflow_id: initialize_workflow(init, :workflow_id),
              arguments: workflow_state(state, :arguments),
              continue_as_new_arguments: Commands.continue_as_new_workflow_execution(cmd, :arguments) |> Enum.map(&Payload.record_from_value/1)
            }
          )

          GenStage.async_info(execution, :execution_complete)
          [command(variant: cmd)]

        {:error, Failure.application() = app_failure} ->
          failure =
            Failure.failure(
              message: "{:error, #{inspect(app_failure)}}",
              source: "elixir-sdk",
              stack_trace: "",
              failure_info: app_failure
            )

          init = workflow_state(state, :initialize_config)
          started_at = workflow_state(state, :started_at)

          :telemetry.execute(
            [:temporalio, :workflow, :failed],
            %{
              duration_microsecs: DateTime.diff(started_at, DateTime.utc_now(), :microsecond)
            },
            %{
              workflow_type: workflow_state(state, :workflow_type),
              namespace: workflow_state(state, :namespace),
              run_id: workflow_state(state, :run_id),
              workflow_id: initialize_workflow(init, :workflow_id),
              arguments: workflow_state(state, :arguments),
              failure: failure
            }
          )

          GenStage.async_info(execution, :execution_complete)
          [command(variant: fail_workflow_execution(failure: failure))]

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

          init = workflow_state(state, :initialize_config)
          started_at = workflow_state(state, :started_at)

          :telemetry.execute(
            [:temporalio, :workflow, :failed],
            %{
              duration_microsecs: DateTime.diff(started_at, DateTime.utc_now(), :microsecond)
            },
            %{
              workflow_type: workflow_state(state, :workflow_type),
              namespace: workflow_state(state, :namespace),
              run_id: workflow_state(state, :run_id),
              workflow_id: initialize_workflow(init, :workflow_id),
              arguments: workflow_state(state, :arguments),
              failure: failure
            }
          )

          GenStage.async_info(execution, :execution_complete)
          [command(variant: fail_workflow_execution(failure: failure))]
      end
    )

    GenStage.async_info(self(), {:demand_from_runtime, 1})

    {:noreply, [], workflow_state(state, executing: true)}
  end

  def handle_info({:demand_from_runtime, demand}, state) do
    runtime_sub = workflow_state(state, :runtime_sub)
    GenStage.ask(runtime_sub, demand)

    {:noreply, [], state}
  end

  def handle_info(:execution_complete, state) do
    {:noreply, [], workflow_state(state, executing: false)}
  end
end
