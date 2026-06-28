defmodule Temporal.Workflow.WorkflowExecution do
  use GenStage

  require TemporalEngine.Data.Activation
  require TemporalEngine.Data.Failure
  import Temporal.WorkflowContext
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivationCompletion

  alias Temporal.WorkflowContext
  alias TemporalEngine.Data.Activation
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  @await_check_delay 300

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
    running_query_handlers: %{},
    running_update_handlers: %{},
    running_signal_handlers: %{},
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
             context: WorkflowContext.workflow_context(),
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
             exec_ref: reference() | nil,
             exec_pid: pid() | nil,
             activity_results: %{integer() => term()},
             running_query_handlers: %{pid() => reference()},
             running_update_handlers: %{pid() => reference()},
             running_signal_handlers: %{pid() => reference()},
             queued_commands: [Commands.command()],
             demand: integer(),
             seq: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(
          {run_id :: String.t(), task_queue :: String.t(), namespace :: String.t(),
           module :: module(), exec_fn :: atom(), config :: Jobs.initialize_workflow(),
           Activation.activation()}
        ) :: {:producer, workflow_state()}
  def init({run_id, task_queue, namespace, module, exec_fn, config, activate}) do
    Process.set_label({:workflow, run_id})

    {:ok, ctx_pid} = GenServer.start_link(WorkflowContext, activate)

    context =
      workflow_context(
        execution: self(),
        context: ctx_pid,
        task_queue: task_queue,
        namespace: namespace,
        run_id: run_id,
        workflow_id: initialize_workflow(config, :workflow_id),
        initialize_config: config
      )

    {:producer,
     workflow_state(
       workflow_type: initialize_workflow(config, :workflow_type),
       arguments:
         initialize_workflow(config, :arguments) |> Enum.map(&Payload.value_from_record/1),
       run_id: run_id,
       context: context,
       workflow_id: initialize_workflow(config, :workflow_id),
       task_queue: task_queue,
       namespace: namespace,
       module: module,
       exec_fn: exec_fn,
       initialize_config: config
     )}
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
  @spec handle_demand(integer(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_demand(demand, state) when demand > 0 do
    existing_demand = workflow_state(state, :demand)
    GenStage.async_info(self(), :execute_if_not_already)

    {:noreply, [], workflow_state(state, demand: existing_demand + demand)}
  end

  @doc false
  @spec handle_call(term(), {pid(), term()}, workflow_state()) ::
          {:noreply, list(), workflow_state()}

  def handle_call({:await, await_check}, from, state) do
    awaiting = workflow_state(state, :awaiting_checks)

    cond do
      await_check.() ->
        GenStage.reply(from, :ok)
        {:noreply, [], state}

      Enum.any?(awaiting) ->
        send(self(), :flush_queued_commands)

        {:noreply, [],
         workflow_state(state, awaiting_checks: Map.put(awaiting, from, await_check))}

      true ->
        send(self(), :flush_queued_commands)
        Process.send_after(self(), :perform_await_checks, @await_check_delay)

        {:noreply, [],
         workflow_state(state, awaiting_checks: Map.put(awaiting, from, await_check))}
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

    WorkflowContext.handler_started(workflow_state(state, :context))
    parent = self()

    {query_pid, query_ref} =
      spawn_monitor(fn ->
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

        GenStage.cast(
          parent,
          {:query_response, self(),
           [command(variant: respond_to_query(query_id: query_id, variant: variant))]}
        )
      end)

    running = workflow_state(state, :running_query_handlers)
    unlocked = workflow_state(state, :unlocked_in_activation) + 1

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       running_query_handlers: Map.put(running, query_pid, query_ref)
     )}
  end

  def handle_cast(job(variant: signal_workflow(signal_name: signal_name, input: args)), state) do
    args = Enum.map(args, &Payload.value_from_record/1)
    handlers = workflow_state(state, :signal_handlers)
    ctx = workflow_state(state, :context)

    WorkflowContext.handler_started(workflow_state(state, :context))

    parent = self()

    {signal_pid, signal_ref} =
      spawn_monitor(fn ->
        resp =
          if handler = Map.get(handlers, {"#{signal_name}", Enum.count(args) + 1}) do
            try do
              apply(handler, [ctx | args])
            rescue
              err ->
                {:error, {:exception, err, __STACKTRACE__}}
            end
          else
            {:error, :handler_not_found}
          end

        with :ok <- resp do
          GenStage.cast(parent, {:signal_response, self(), :ok})
        else
          {:error, err} ->
            Logger.warning("Error when processing signal: #{inspect(err)}")
            GenStage.cast(parent, {:signal_response, self(), {:error, err}})

          other ->
            Logger.warning(
              "Unexpected response when processing signal: '#{inspect(other)}' - Expected ':ok'"
            )

            GenStage.cast(parent, {:signal_response, self(), {:error, {:unexpected, other}}})
        end
      end)

    running = workflow_state(state, :running_signal_handlers)
    unlocked = workflow_state(state, :unlocked_in_activation) + 1

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       running_signal_handlers: Map.put(running, signal_pid, signal_ref)
     )}
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

    WorkflowContext.handler_started(workflow_state(state, :context))

    parent = self()

    {update_pid, update_ref} =
      spawn_monitor(fn ->
        resp =
          if details = Map.get(handlers, {"#{update_name}", Enum.count(args) + 1}) do
            try do
              if validate? && details.validator do
                apply(details.validator, [ctx | args])
              else
                :ok
              end
            rescue
              err ->
                {:error, {:exception, err, __STACKTRACE__}}
            end
          else
            {:error, :handler_not_found}
          end

        validator_resp =
          with :ok <- resp do
            update_accepted()
          else
            {:error, :handler_not_found} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message:
                      "Update handler (#{inspect(update_name)}/#{Enum.count(args) + 1}) not found.",
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info:
                      Failure.application(failure_type: "HandlerNotFound", non_retryable: true)
                  )
              )

            {:error, Failure.application() = app_error} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: Failure.application(app_error, :failure_type),
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info: app_error
                  )
              )

            {:error, {:exception, Failure.application() = app_error, stacktrace}} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: Failure.application(app_error, :failure_type),
                    source: "elixir-sdk",
                    stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                    failure_info: app_error
                  )
              )

            {:error, {:exception, %ex_type{} = exception, stacktrace}} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: inspect(exception),
                    source: "elixir-sdk",
                    stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                    failure_info: Failure.application(failure_type: "#{ex_type}")
                  )
              )

            {:error, err} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: "{:error, #{inspect(err)}}",
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info:
                      Failure.application(
                        failure_type: "ValidationReturnedError",
                        non_retryable: true
                      )
                  )
              )
          end

        handler_resp =
          case validator_resp do
            update_accepted() ->
              if details = Map.get(handlers, {"#{update_name}", Enum.count(args) + 1}) do
                try do
                  apply(details.handler, [ctx | args])
                rescue
                  err ->
                    {:error, {:exception, err, __STACKTRACE__}}
                end
              else
                {:error, :handler_not_found}
              end

            _ ->
              {:error, :failed_validation}
          end

        update_resp =
          with {:ok, result} <- handler_resp do
            update_completed(payload: Payload.record_from_value(result))
          else
            {:error, :failed_validation} ->
              nil

            {:error, :handler_not_found} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message:
                      "Update handler (#{inspect(update_name)}/#{Enum.count(args) + 1}) not found.",
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info:
                      Failure.application(failure_type: "HandlerNotFound", non_retryable: true)
                  )
              )

            {:error, Failure.application() = app_error} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: Failure.application(app_error, :failure_type),
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info: app_error
                  )
              )

            {:error, {:exception, Failure.application() = app_error, stacktrace}} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: Failure.application(app_error, :failure_type),
                    source: "elixir-sdk",
                    stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                    failure_info: app_error
                  )
              )

            {:error, {:exception, %ex_type{} = exception, stacktrace}} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: inspect(exception),
                    source: "elixir-sdk",
                    stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
                    failure_info: Failure.application(failure_type: "#{ex_type}")
                  )
              )

            {:error, err} ->
              update_rejected(
                failure:
                  Failure.failure(
                    message: "{:error, #{inspect(err)}}",
                    source: "elixir-sdk",
                    stack_trace: "",
                    failure_info:
                      Failure.application(
                        failure_type: "ValidationReturnedError",
                        non_retryable: true
                      )
                  )
              )
          end

        commands =
          if update_resp do
            [
              command(
                variant:
                  update_response(protocol_instance_id: protocol_id, response: validator_resp)
              ),
              command(
                variant: update_response(protocol_instance_id: protocol_id, response: update_resp)
              )
            ]
          else
            command(
              variant:
                update_response(protocol_instance_id: protocol_id, response: validator_resp)
            )
          end

        GenStage.cast(parent, {:update_response, self(), commands})
      end)

    running = workflow_state(state, :running_update_handlers)
    unlocked = workflow_state(state, :unlocked_in_activation) + 1

    {:noreply, [],
     workflow_state(state,
       unlocked_in_activation: unlocked,
       running_update_handlers: Map.put(running, update_pid, update_ref)
     )}
  end

  def handle_cast({:activation_started, activate}, state) do
    ctx = workflow_state(state, :context)
    WorkflowContext.update_for_activation(ctx, activate)

    {:noreply, [], workflow_state(state, unlocked_in_activation: 0)}
  end

  def handle_cast(:activation_completed, state) do
    unlocked = workflow_state(state, :unlocked_in_activation)

    if unlocked == 0 && awaiting_process_count(state) >= running_threads(state) do
      send(self(), :flush_queued_commands)
    end

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

  def handle_cast({:query_response, _pid, cmds}, state) do
    {:noreply, [success(commands: cmds)], state}
  end

  def handle_cast({:update_response, _pid, cmds}, state) do
    {:noreply, [success(commands: cmds)], state}
  end

  def handle_cast({:signal_response, _pid, _resp}, state) do
    send(self(), :flush_queued_commands)
    {:noreply, [], state}
  end

  def handle_cast({:workflow_completed, resp}, state) do
    resp =
      case resp do
        :ok -> {:ok, nil}
        other -> other
      end

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

      {:error, Commands.continue_as_new_workflow_execution() = continue_as_new} ->
        status = success(commands: [command(variant: continue_as_new)])
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

      other ->
        failure =
          Failure.failure(
            message:
              "Unexpected response: '#{inspect(other)}' - expected {:ok, ...} or {:error, ...}",
            source: "elixir-sdk",
            stack_trace: "",
            failure_info:
              Failure.application(
                failure_type: "InvalidReturnError",
                details: [Payload.record_from_value(other)]
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

    ctx = workflow_state(state, :context)
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

  def handle_info(:perform_await_checks, state) do
    new_awaiting =
      workflow_state(state, :awaiting_checks)
      |> Enum.reduce(%{}, fn {from, await_check}, acc ->
        if await_check.() do
          GenStage.reply(from, :ok)
          acc
        else
          Map.put(acc, from, await_check)
        end
      end)

    if Enum.any?(new_awaiting),
      do: Process.send_after(self(), :perform_await_checks, @await_check_delay)

    {:noreply, [], workflow_state(state, awaiting_checks: new_awaiting)}
  end

  def handle_info(
        {:DOWN, _, :process, query_pid, :normal},
        workflow_state(running_query_handlers: handlers) = state
      )
      when is_map_key(handlers, query_pid) do
    WorkflowContext.handler_finished(workflow_state(state, :context))

    running = workflow_state(state, :running_query_handlers)
    {:noreply, [], workflow_state(state, running_query_handlers: Map.delete(running, query_pid))}
  end

  def handle_info(
        {:DOWN, _, :process, update_pid, :normal},
        workflow_state(running_update_handlers: handlers) = state
      )
      when is_map_key(handlers, update_pid) do
    WorkflowContext.handler_finished(workflow_state(state, :context))

    running = workflow_state(state, :running_update_handlers)

    {:noreply, [],
     workflow_state(state, running_update_handlers: Map.delete(running, update_pid))}
  end

  def handle_info(
        {:DOWN, _, :process, signal_pid, :normal},
        workflow_state(running_signal_handlers: handlers) = state
      )
      when is_map_key(handlers, signal_pid) do
    WorkflowContext.handler_finished(workflow_state(state, :context))

    running = workflow_state(state, :running_signal_handlers)

    {:noreply, [],
     workflow_state(state, running_signal_handlers: Map.delete(running, signal_pid))}
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

  defp running_threads(state) do
    query_threads = workflow_state(state, :running_query_handlers)
    update_threads = workflow_state(state, :running_update_handlers)
    signal_threads = workflow_state(state, :running_signal_handlers)

    1 + Enum.count(query_threads) + Enum.count(update_threads) + Enum.count(signal_threads)
  end
end
