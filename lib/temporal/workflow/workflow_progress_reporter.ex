defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  require TemporalEngine.Data.ActivationCompletion

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.Jobs
  import TemporalEngine.Data.Priority, only: [priority: 1]
  import TemporalEngine.Data.RetryPolicy, only: [policy: 1]

  alias Temporal.Worker
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.Duration
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Workflow.WorkflowFlowController

  require Logger
  require Record

  Record.defrecordp(:progress_state, [
    :run_id,
    :workflow_id,
    :worker_id,
    :task_queue,
    :next_seq,
    :runtime,
    :core_worker,
    command_batch: [],
    sequences: %{}
  ])

  @type progress_state() :: term()

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    Process.flag(:trap_exit, true)
    Process.set_label({:workflow_progress_reporter, exec_ctx.run_id})

    {:ok,
     progress_state(
       run_id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       task_queue: exec_ctx.task_queue,
       next_seq: 1,
       runtime: exec_ctx.runtime,
       core_worker: exec_ctx.core_worker
     )}
  end

  @spec request_start_timer(pid(), Duration.duration()) :: :ok | {:error, term()}
  def request_start_timer(reporter, duration),
    do:
      GenServer.call(
        reporter,
        {:command, start_timer(start_to_fire_timeout: Duration.from_tuple(duration))},
        :infinity
      )

  @schedule_activity_schema NimbleOptions.new!(
                              schedule_to_close_timeout: [
                                required: false,
                                type:
                                  {:tuple,
                                   [
                                     :pos_integer,
                                     {:in,
                                      [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                                   ]},
                                type_doc:
                                  "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                doc:
                                  "Indicates how long the caller is willing to wait for an activity completion. Limits how long retries will be attempted. Either this or start_to_close_timeout_seconds must be specified. When not specified defaults to the workflow execution timeout."
                              ],
                              schedule_to_start_timeout: [
                                required: false,
                                type:
                                  {:tuple,
                                   [
                                     :pos_integer,
                                     {:in,
                                      [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                                   ]},
                                type_doc:
                                  "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                doc:
                                  "Limits time an activity task can stay in a task queue before a worker picks it up. This timeout is always non retryable as all a retry would achieve is to put it back into the same queue. Defaults to `schedule_to_close_timeout` or workflow execution timeout if not specified."
                              ],
                              start_to_close_timeout: [
                                required: false,
                                type:
                                  {:tuple,
                                   [
                                     :pos_integer,
                                     {:in,
                                      [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                                   ]},
                                type_doc:
                                  "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                doc:
                                  "Maximum time an activity is allowed to execute after a pick up by a worker. This timeout is always retryable. Either this or schedule_to_close_timeout must be specified."
                              ],
                              heartbeat_timeout: [
                                required: false,
                                type:
                                  {:tuple,
                                   [
                                     :pos_integer,
                                     {:in,
                                      [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                                   ]},
                                type_doc:
                                  "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                doc: "Maximum time allowed between successful worker heartbeats."
                              ],
                              retry_policy: [
                                required: false,
                                type: :keyword_list,
                                doc:
                                  "Activities are provided by a default retry policy controlled through the service dynamic configuration. Retries are happening up to schedule_to_close_timeout. To disable retries set retry_policy.maximum_attempts to 1.",
                                keys: [
                                  initial_interval: [
                                    required: false,
                                    type:
                                      {:tuple,
                                       [
                                         :pos_integer,
                                         {:in,
                                          [
                                            :weeks,
                                            :days,
                                            :hours,
                                            :minutes,
                                            :seconds,
                                            :millseconds
                                          ]}
                                       ]},
                                    type_doc:
                                      "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                    doc:
                                      "Interval of the first retry. If retryBackoffCoefficient is 1.0 then it is used for all retries."
                                  ],
                                  backoff_coefficient: [
                                    default: 2.0,
                                    type: :float,
                                    doc:
                                      "Coefficient used to calculate the next retry interval. The next retry interval is previous interval multiplied by the coefficient. Must be 1 or larger."
                                  ],
                                  maximum_interval: [
                                    required: false,
                                    type:
                                      {:tuple,
                                       [
                                         :pos_integer,
                                         {:in,
                                          [
                                            :weeks,
                                            :days,
                                            :hours,
                                            :minutes,
                                            :seconds,
                                            :millseconds
                                          ]}
                                       ]},
                                    type_doc:
                                      "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                                    doc:
                                      "Maximum interval between retries. Exponential backoff leads to interval increase. This value is the cap of the increase. Default is 100x of the initial interval."
                                  ],
                                  maximum_attempts: [
                                    default: 0,
                                    type: :pos_integer,
                                    doc:
                                      "Maximum number of attempts. When exceeded the retries stop even if not expired yet. 1 disables retries. 0 means unlimited (up to the timeouts)"
                                  ],
                                  non_retryable_error_types: [
                                    default: [],
                                    type: {:list, :string},
                                    doc:
                                      "Non-Retryable errors types. Will stop retrying if the error type matches this list. Note that this is not a substring match, the error type (not message) must match exactly."
                                  ]
                                ]
                              ],
                              cancellation_type: [
                                default: :try_cancel,
                                type:
                                  {:in, [:try_cancel, :wait_cancellation_completed, :abandon]},
                                type_doc:
                                  "`:try_cancel` | `:wait_cancellation_completed` | `:abandon`",
                                doc:
                                  "Defines how the workflow will wait (or not) for cancellation of the activity to be confirmed"
                              ],
                              do_not_eagerly_execute: [
                                default: false,
                                type: :boolean,
                                doc:
                                  "If set, the worker will not tell the service that it can immediately start executing this activity. When unset/default, workers will always attempt to do so if activity execution slots are available."
                              ],
                              versioning_intent: [
                                default: :default,
                                type: {:in, [:unspecified, :compatible, :default]},
                                type_doc: "`:unspecified` | `:compatible` | `:default`",
                                doc:
                                  "Whether this activity should run on a worker with a compatible build id or not."
                              ],
                              priority: [
                                required: false,
                                type: :keyword_list,
                                doc: "The Priority to use for this activity",
                                keys: [
                                  priority_key: [
                                    required: false,
                                    type: :pos_integer,
                                    doc:
                                      "Priority key is a positive integer from 1 to n, where smaller integers correspond to higher priorities (tasks run sooner). In general, tasks in a queue should be processed in close to priority order, although small deviations are possible. The maximum priority value (minimum priority) is determined by server configuration, and defaults to 5. The server default priority is (min + max) / 2. With the default max of 5 and min of 1, that comes out to 3. None means inherit from the calling workflow or use the server default."
                                  ],
                                  fairness_key: [
                                    required: false,
                                    type: :string,
                                    doc:
                                      ~s|Fairness key is a short string that’s used as a key for a fairness balancing mechanism. It may correspond to a tenant id, or to a fixed string like “high” or “low”. The fairness mechanism attempts to dispatch tasks for a given key in proportion to its weight. For example, using a thousand distinct tenant ids, each with a weight of 1.0 (the default) will result in each tenant getting a roughly equal share of task dispatch throughput. (Note: this does not imply equal share of worker capacity! Fairness decisions are made based on queue statistics, not current worker load.) As another example, using keys “high” and “low” with weight 9.0 and 1.0 respectively will prefer dispatching “high” tasks over “low” tasks at a 9:1 ratio, while allowing either key to use all worker capacity if the other is not present. All fairness mechanisms, including rate limits, are best-effort and probabilistic. The results may not match what a “perfect” algorithm with infinite resources would produce. The more unique keys are used, the less accurate the results will be. Fairness keys are limited to 64 bytes. `None` means inherit from the calling workflow or use the server default (empty string).|
                                  ],
                                  fairness_weight: [
                                    required: false,
                                    type: :float,
                                    doc:
                                      "Fairness weight for a task can come from multiple sources for flexibility. From highest to lowest precedence: \n1. Weights for a small set of keys can be overridden in task queue configuration with an API. \n2. It can be attached to the workflow/activity in this field. \n3.The server default weight of 1.0 will be used.\n\nWeight values are clamped by the server to the range [0.001, 1000].\n\n`None` means inherit from the calling workflow or use the server default (1.0)."
                                  ]
                                ]
                              ]
                            )

  @typedoc "Supported options:\n#{NimbleOptions.docs(@schedule_activity_schema)}"
  @type schedule_activity_opts ::
          unquote(NimbleOptions.option_typespec(@schedule_activity_schema))

  @type priority_opts :: [
          {:priority_key, integer()} | {:fairness_key, String.t()} | {:fairness_weight, float()}
        ]

  @type retry_opts :: [
          {:initial_interval, Duration.duration()}
          | {:backoff_coefficient, float()}
          | {:maximum_interval, Duration.duration()}
          | {:maximum_attempts, pos_integer()}
          | {:non_retryable_error_types, [String.t()]}
        ]

  @spec schedule_activity(
          pid(),
          activity_type :: String.t(),
          args :: [term()],
          schedule_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_activity(reporter, activity_type, args, opts \\ []) do
    with {:ok, opts} <- NimbleOptions.validate(opts, @schedule_activity_schema) do
      command =
        schedule_activity(
          activity_type: activity_type,
          arguments: Enum.map(args, &Payload.record_from_value/1),
          schedule_to_close_timeout:
            if(tm = opts[:schedule_to_close_timeout], do: Duration.from_tuple(tm)),
          schedule_to_start_timeout:
            if(tm = opts[:schedule_to_start_timeout], do: Duration.from_tuple(tm)),
          start_to_close_timeout:
            if(tm = opts[:start_to_close_timeout], do: Duration.from_tuple(tm)),
          heartbeat_timeout: if(tm = opts[:heartbeat_timeout], do: Duration.from_tuple(tm)),
          retry_policy:
            if(policy = opts[:retry_policy],
              do:
                policy(
                  initial_interval:
                    if(tm = policy[:initial_interval], do: Duration.from_tuple(tm)),
                  backoff_coefficient: policy[:backoff_coefficient],
                  maximum_interval:
                    if(tm = policy[:maximum_interval], do: Duration.from_tuple(tm)),
                  maximum_attempts: policy[:maximum_attempts],
                  non_retryable_error_types: policy[:non_retryable_error_types]
                )
            ),
          cancellation_type: opts[:cancellation_type],
          do_not_eagerly_execute: opts[:do_not_eagerly_execute],
          versioning_intent: opts[:versioning_intent],
          priority:
            if(priority = opts[:priority],
              do:
                priority(
                  priority_key: priority[:priority_key],
                  fairness_key: priority[:fairness_key],
                  fairness_weight: priority[:fairness_weight]
                )
            )
        )

      GenServer.call(reporter, {:command, command}, :infinity)
    end
  end

  def process_activation(activation(run_id: run_id) = activation) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.call(reporter, {:process_activation, activation}, :infinity)
    end
  end

  def report_completed_success(reporter, result) do
    output = Payload.record_from_value(result)
    GenServer.call(reporter, {:report_completed_success, output}, :infinity)
  end

  @failure_opts_schema NimbleOptions.new!(
                         message: [
                           required: true,
                           type: :string,
                           doc: "Error message to report with the failure"
                         ],
                         stack_trace: [
                           default: "",
                           type: :string,
                           doc: "Stack Trace associated with the failure, if applicable"
                         ],
                         cause: [
                           required: false,
                           type: :any,
                           doc: "Failure that led to this failure"
                         ],
                         info: [
                           required: false,
                           type: :any,
                           type_doc: "`TemporalEngine.Data.Failure.info/0`",
                           doc: "More detailed information about the type of failure"
                         ]
                       )

  @typedoc "Supported options:\n#{NimbleOptions.docs(@failure_opts_schema)}"
  @type failure_opts :: unquote(NimbleOptions.option_typespec(@failure_opts_schema))

  @spec report_completed_failure(pid(), failure_opts()) :: :ok | {:error, term()}
  def report_completed_failure(reporter, opts) do
    import TemporalEngine.Data.Failure

    with {:ok, opts} <- NimbleOptions.validate(opts, @failure_opts_schema) do
      GenServer.call(
        reporter,
        {:report_completed_failure,
         failure(
           message: opts[:message],
           stack_trace: opts[:stack_trace],
           cause: opts[:cause],
           failure_info: opts[:info]
         )},
        :infinity
      )
    end
  end

  def send_heartbeat_for_id(run_id) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(run_id) do
      GenServer.cast(reporter, :heartbeat)
    end
  end

  def handle_call({:command, start_timer() = cmd}, _from, state) do
    next_seq = progress_state(state, :next_seq)
    sequences = progress_state(state, :sequences)

    {:reply, {:ok, "#{next_seq}"},
     progress_state(state,
       sequences: Map.put(sequences, next_seq, cmd),
       command_batch: progress_state(state, :command_batch) ++ [start_timer(cmd, seq: next_seq)],
       next_seq: next_seq + 1
     )}
  end

  def handle_call({:command, schedule_activity() = cmd}, _from, state) do
    next_seq = progress_state(state, :next_seq)
    activity_id = "#{next_seq}"

    cmd =
      schedule_activity(cmd,
        seq: next_seq,
        activity_id: "#{next_seq}",
        task_queue: progress_state(state, :task_queue).queue_name
      )

    {:reply, {:ok, activity_id},
     progress_state(state,
       command_batch: progress_state(state, :command_batch) ++ [cmd],
       next_seq: next_seq + 1
     )}
  end

  def handle_call({:process_activation, activation(run_id: run_id) = activation}, _from, state) do
    jobs = activation(activation, :jobs)

    activity_resolve_jobs =
      jobs
      |> Enum.filter(&match?(resolve_activity(), &1))

    sequences = progress_state(state, :sequences)

    {:ok, {locked?, will_unlock_anything?}} =
      WorkflowFlowController.will_resolutions_unlock?(
        run_id,
        Enum.map(activity_resolve_jobs, fn resolve_activity(seq: seq) ->
          schedule_activity(activity_id: activity_id) = sequences[seq]
          activity_id
        end)
      )

    Logger.debug("Will resolution unlock? #{inspect(will_unlock_anything?)}")

    # These are in a specific order
    # https://typescript.temporal.io/api/classes/proto.coresdk.workflow_activation.WorkflowActivation
    {patch_updates, jobs} =
      Enum.split_with(jobs, fn
        {:set_patch_marker, _} -> true
        _ -> false
      end)

    {update_seeds, jobs} =
      Enum.split_with(jobs, fn
        {:update_random_seed, _} -> true
        _ -> false
      end)

    {signals_updates, jobs} =
      Enum.split_with(jobs, fn
        {:signal_workflow, _} -> true
        {:resolve_signal_external_workflow, _} -> true
        {:do_update, _} -> true
        _ -> false
      end)

    {timer_resolutions, jobs} =
      Enum.split_with(jobs, fn
        fire_timer() -> true
        _ -> false
      end)

    {:ok, state} = resolve_timers(timer_resolutions, activation, state)

    {activity_resolutions, jobs} =
      Enum.split_with(jobs, fn
        resolve_activity() -> true
        _ -> false
      end)

    {:ok, state} = resolve_activities(activity_resolutions, activation, state)

    {queries, jobs} =
      Enum.split_with(jobs, fn
        {:query_workflow, _} -> true
        _ -> false
      end)

    {evictions, jobs} =
      Enum.split_with(jobs, fn
        {:remove_from_cache, _reason, _message} -> true
        _ -> false
      end)

    everything =
      patch_updates ++ update_seeds ++ signals_updates ++ queries ++ evictions ++ jobs

    processed =
      everything
      |> Enum.reduce({:ok, state}, fn
        job, {:ok, state} ->
          Logger.error("Received unexpected job (#{inspect(job)}")
          {:ok, state}

        _, {:error, err} ->
          {:error, err}
      end)

    with {:ok, new_state} <- processed do
      if locked? && !will_unlock_anything? do
        {:reply, :ok, new_state, {:continue, :heartbeat}}
      else
        {:reply, :ok, new_state}
      end
    else
      {:error, err} ->
        Logger.error("Error when processing activation: #{inspect(err)}")
        {:reply, {:error, err}, state, {:continue, :heartbeat}}
    end
  end

  def handle_call({:report_completed_success, output}, _from, state) do
    report_successful_completion(state, [complete_workflow_execution(result: output)])
    |> case do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        Logger.error("Error reporting workflow completion - #{inspect(err)}")
        {:reply, {:error, err}, state}
    end
  end

  def handle_call({:report_completed_failure, failure}, _from, state) do
    report_successful_completion(state, [fail_workflow_execution(failure: failure)])
    |> case do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {{:error, err}, _} ->
        Logger.error("Error reporting workflow completion - #{inspect(err)}")
        {:reply, {:error, err}, state}
    end
  end

  def handle_cast(:heartbeat, state) do
    report_successful_completion(state, [])
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:noreply, state}
    end
  end

  def handle_continue(:heartbeat, state) do
    report_successful_completion(state, [])
    |> case do
      {:ok, new_state} ->
        {:noreply, new_state}

      {{:error, err}, _} ->
        Logger.error("Workflow heartbeat error: #{inspect(err)}")
        {:noreply, state}
    end
  end

  defp resolve_activities(activities, _activation, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    Enum.each(activities, fn resolve_activity(seq: seq) ->
      cmd = sequences[seq]

      Logger.debug(
        "Job: resolve_activity (#{schedule_activity(cmd, :activity_type)} - #{schedule_activity(cmd, :activity_id)}) for #{run_id}"
      )
    end)

    results =
      Enum.map(activities, fn resolve_activity(seq: seq, result: result) ->
        activity = sequences[seq]

        output =
          case result do
            activity_completed(result: value) ->
              {:ok, value |> Payload.value_from_record()}

            activity_failed(failure: failure) ->
              {:error, failure}

            activity_cancelled(failure: failure) ->
              {:error, {:cancelled, failure}}

            activity_backoff(backoff_duration: _duration) ->
              {:error,
               {:not_implemented,
                "TODO: Local Activity backoff (https://docs.rs/temporalio-common/0.4.0/temporalio_common/protos/coresdk/activity_result/struct.DoBackoff.html) not yet implemented."}}
          end

        {schedule_activity(activity, :activity_id), output}
      end)

    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(run_id),
         :ok <-
           WorkflowFlowController.activity_tasks_resolved(
             flow_control,
             results
           ) do
      {:ok, state}
    else
      {:error, err} ->
        Logger.error("Error resolving activities #{inspect(err)}")
        {:error, "Error resolving activities #{inspect(err)}"}
    end
  end

  defp resolve_timers(timers, _activation, state) do
    sequences = progress_state(state, :sequences)
    run_id = progress_state(state, :run_id)

    timer_ids =
      Enum.map(timers, fn fire_timer(seq: seq) ->
        cmd = sequences[seq]

        Logger.debug(
          "Job: fire_timer (#{start_timer(cmd, :seq)} - #{inspect(start_timer(cmd, :start_to_fire_timeout))}) for #{run_id}"
        )

        "#{seq}"
      end)

    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(run_id),
         :ok <- WorkflowFlowController.timers_resolved(flow_control, timer_ids) do
      {:ok, state}
    else
      {:error, err} ->
        Logger.error("Error resolving timers #{inspect(err)}")
        {:error, "Error resolving timers #{inspect(err)}"}
    end
  end

  @spec report_successful_completion(progress_state(), ActivationCompletion.success()) ::
          {:ok, state :: term()} | {:error, term()}
  defp report_successful_completion(state, commands) do
    commands = progress_state(state, :command_batch) ++ (commands || [])
    state = progress_state(state, command_batch: [])

    state =
      Enum.reduce(commands, state, fn
        schedule_activity(seq: seq) = cmd, state ->
          sequences = progress_state(state, :sequences)

          progress_state(state,
            sequences: Map.put(sequences, seq, cmd)
          )

        _, state ->
          state
      end)

    resp =
      send_successful_activation_completion(
        progress_state(state, :run_id),
        progress_state(state, :core_worker).core,
        commands
      )

    {resp, state}
  end

  @spec send_successful_activation_completion(
          run_id :: String.t(),
          worker :: Worker.t(),
          commands :: [term()]
        ) :: :ok | {:error, term()}
  def send_successful_activation_completion(run_id, worker, commands) do
    Logger.debug("Completed Activation: #{run_id}")

    TemporalEngine.Worker.complete_workflow_activation(
      worker,
      ActivationCompletion.completion(
        run_id: run_id,
        result: ActivationCompletion.success(commands: commands)
      )
    )
  end

  @spec send_failure_activation_completion(
          run_id :: String.t(),
          worker :: Worker.t(),
          ActivationCompletion.failure()
        ) :: :ok | {:error, term()}
  def send_failure_activation_completion(run_id, worker, completion) do
    Logger.debug("Failed Activation: #{run_id}")

    TemporalEngine.Worker.complete_workflow_activation(
      worker,
      ActivationCompletion.completion(run_id: run_id, result: completion)
    )
  end

  def handle_info({:EXIT, _, :normal}, state) do
    {:noreply, state}
  end

  def terminate(reason, state) do
    run_id = progress_state(state, :run_id)
    Logger.debug("Workflow (#{run_id}) terminating: #{inspect(reason)}")

    reason
  end
end
