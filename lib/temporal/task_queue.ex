defmodule Temporal.TaskQueue do
  defstruct [:queue_name, :client, default_workflow_opts: [], default_worker_opts: []]

  import TemporalEngine.Client
  import TemporalEngine.Data.RetryPolicy, only: [policy: 1]
  import TemporalEngine.Data.Priority, only: [priority: 1]

  alias Temporal.Client
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkflowStartOptions
  alias Temporal.Workflows.WorkflowName
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload

  @workflow_opts_schema NimbleOptions.new!(
                          task_queue: [
                            required: true,
                            type: :string,
                            doc: "The task queue to run the workflow on."
                          ],
                          workflow_id: [
                            required: true,
                            type: :string,
                            doc: "The workflow ID."
                          ],
                          id_reuse_policy: [
                            default: :unspecified,
                            type:
                              {:in,
                               [
                                 :unspecified,
                                 :allow_duplicate,
                                 :allow_duplicate_failed_only,
                                 :reject_duplicate,
                                 :terminate_if_running
                               ]},
                            type_doc:
                              "**`:unspecified | :allow_duplicate | :allow_duplicate_failed_only | :reject_duplicate | :terminate_if_running`**",
                            doc:
                              "Defines whether to allow re-using a workflow id from a previously closed workflow. If the request is denied, the server returns a `WorkflowExecutionAlreadyStartedFailure` error. See `WorkflowIdConflictPolicy` for handling workflow id duplication with a running workflow."
                          ],
                          id_conflict_policy: [
                            default: :unspecified,
                            type:
                              {:in, [:unspecified, :fail, :use_existing, :terminate_existing]},
                            type_doc:
                              "**`:unspecified | :fail | :use_existing | :terminate_existing`**",
                            doc:
                              "Set the policy for how to resolve conflicts with running policies. NOTE: This is ignored for child workflows."
                          ],
                          execution_timeout: [
                            required: false,
                            type:
                              {:tuple,
                               [
                                 :pos_integer,
                                 {:in, [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                               ]},
                            type_doc:
                              "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                            doc:
                              "Optionally set the execution timeout for the workflow https://docs.temporal.io/workflows/#workflow-execution-timeout"
                          ],
                          run_timeout: [
                            required: false,
                            type:
                              {:tuple,
                               [
                                 :pos_integer,
                                 {:in, [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                               ]},
                            type_doc:
                              "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                            doc: "Optionally indicates the default run timeout for a workflow run"
                          ],
                          task_timeout: [
                            required: false,
                            type:
                              {:tuple,
                               [
                                 :pos_integer,
                                 {:in, [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
                               ]},
                            type_doc:
                              "[Duration.t/0](`t:TemporalEngine.Data.Duration.duration/0`)",
                            doc:
                              "Optionally indicates the default task timeout for a workflow run"
                          ],
                          cron_schedule: [
                            required: false,
                            type: :string,
                            doc: "Optionally set a cron schedule for the workflow"
                          ],
                          search_attributes: [
                            required: false,
                            type: {:map, :string, :any},
                            doc: "Optionally associate extra search attributes with a workflow"
                          ],
                          enable_eager_workflow_start: [
                            required: false,
                            type: {:map, :string, :any},
                            doc:
                              "Optionally enable Eager Workflow Start, a latency optimization using local workers NOTE: Experimental"
                          ],
                          retry_policy: [
                            required: false,
                            type: :keyword_list,
                            doc: "Optionally set a retry policy for the workflow",
                            keys: [
                              initial_interval: [
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
                                      [:weeks, :days, :hours, :minutes, :seconds, :millseconds]}
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
                          start_signal: [
                            required: false,
                            type: :keyword_list,
                            doc:
                              "A signal to send atomically when starting a workflow. Use with WorkflowStartOptions::start_signal to achieve signal-with-start behavior.",
                            keys: [
                              signal_name: [
                                required: true,
                                type: :string,
                                doc: "Name of the signal to send."
                              ],
                              inputs: [
                                required: false,
                                type: {:list, :any},
                                doc: "Payload for the signal."
                              ],
                              header: [
                                required: false,
                                type: {:map, :string, :any},
                                doc: "Headers for the signal."
                              ]
                            ]
                          ],
                          start_signal: [
                            required: false,
                            type: :keyword_list,
                            doc:
                              "A signal to send atomically when starting a workflow. Use with WorkflowStartOptions::start_signal to achieve signal-with-start behavior.",
                            keys: [
                              signal_name: [
                                required: true,
                                type: :string,
                                doc: "Name of the signal to send."
                              ],
                              inputs: [
                                required: false,
                                type: {:list, :any},
                                doc: "Payload for the signal."
                              ],
                              header: [
                                required: false,
                                type: {:map, :string, :any},
                                doc: "Headers for the signal."
                              ]
                            ]
                          ],
                          priority: [
                            required: false,
                            type: :keyword_list,
                            doc: "Priority for the workflow. Defaults to all-inherited (empty).",
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
                          ],
                          header: [
                            required: false,
                            type: {:map, :string, :any},
                            doc: "Headers to include with the start request."
                          ],
                          static_summary: [
                            required: false,
                            type: :string,
                            doc:
                              "Single-line static summary for the workflow, shown in the Temporal UI."
                          ],
                          static_details: [
                            required: false,
                            type: :string,
                            doc:
                              "Multi-line static details for the workflow, shown in the Temporal UI."
                          ]
                        )

  @type t() :: %__MODULE__{
          queue_name: String.t(),
          client: Client.t(),
          default_workflow_opts: WorkflowStartOptions.opts()
        }

  @type opts :: [
          {:default_workflow_opts, WorkflowStartOptions.opts()}
          | {:default_worker_opts, WorkerOpts.opts()}
        ]

  @typedoc "Supported options:\n#{NimbleOptions.docs(@workflow_opts_schema)}"
  @type workflow_opts :: unquote(NimbleOptions.option_typespec(@workflow_opts_schema))

  @spec new(Client.t(), queue_name :: String.t(), opts()) :: t()
  def new(client, queue_name, opts \\ []) do
    %__MODULE__{
      client: client,
      queue_name: queue_name,
      default_workflow_opts: Keyword.get(opts, :default_workflow_opts, []),
      default_worker_opts: Keyword.get(opts, :default_worker_opts, [])
    }
  end

  @spec start_workflow(
          t(),
          workflow_id :: String.t(),
          workflow_name :: WorkflowName.t(),
          inputs :: [term()],
          opts :: workflow_opts()
        ) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def start_workflow(queue, workflow_id, workflow_name, inputs, opts \\ []) do
    wf_server_name =
      case workflow_name do
        {workflow_name, execute_fn} ->
          WorkflowName.server_recognized_name(workflow_name, execute_fn)

        _ ->
          WorkflowName.server_recognized_name(workflow_name, :execute)
      end

    workflow_def = definition(name: wf_server_name)
    inputs = Enum.map(inputs, &Payload.record_from_value/1)

    opts = queue.default_workflow_opts ++ opts
    opts = opts ++ [workflow_id: workflow_id, task_queue: queue.queue_name]

    with {:ok, opts} <- NimbleOptions.validate(opts, @workflow_opts_schema) do
      start_opts =
        workflow_start_opts(
          task_queue: opts[:task_queue],
          workflow_id: opts[:workflow_id],
          id_reuse_policy: opts[:id_reuse_policy],
          id_conflict_policy: opts[:id_conflict_policy],
          execution_timeout: if(d = opts[:execution_timeout], do: Duration.from_tuple(d)),
          run_timeout: if(d = opts[:run_timeout], do: Duration.from_tuple(d)),
          task_timeout: if(d = opts[:task_timeout], do: Duration.from_tuple(d)),
          cron_schedule: opts[:cron_schedule],
          search_attributes:
            if(attribs = opts[:search_attributes],
              do: Map.new(attribs, &{&1, Payload.record_from_value(&2)})
            ),
          enable_eager_workflow_start: opts[:enable_eager_workflow_start],
          retry_policy:
            if(policy = opts[:retry_policy],
              do:
                policy(
                  initial_interval: if(d = policy[:initial_interval], do: Duration.from_tuple(d)),
                  backoff_coefficient: policy[:backoff_coefficient],
                  maximum_interval: if(d = policy[:maximum_interval], do: Duration.from_tuple(d)),
                  maximum_attempts: policy[:maximum_attempts],
                  non_retryable_error_types: policy[:non_retryable_error_types]
                )
            ),
          start_signal:
            if(s = opts[:start_signal],
              do:
                start_signal(
                  signal_name: s[:signal_name],
                  inputs: Enum.map(s[:inputs], &Payload.record_from_value/1),
                  header: Map.new(s[:header], &{&1, Payload.record_from_value(&2)})
                )
            ),
          priority:
            priority(
              priority_key: opts[:priority][:priority_key],
              fairness_key: opts[:priority][:fairness_key],
              fairness_weight: opts[:priority][:fairness_weight]
            ),
          header: opts[:header],
          static_summary: opts[:static_summary],
          static_details: opts[:static_details]
        )

      with {:ok, core_client} <- CoreClient.existing_for_identity(queue.client.identity),
           :ok <- validate_workflow_inputs(workflow_name, inputs) do
        TemporalEngine.Client.start_workflow(core_client.core, workflow_def, inputs, start_opts)
      end
    end
  end

  @spec validate_workflow_inputs(WorkflowName.t(), [term()]) :: :ok | {:error, term()}
  defp validate_workflow_inputs(workflow_name, inputs) do
    {workflow_name, execute_fn} =
      case workflow_name do
        {name, execute} when is_atom(execute) ->
          {name, execute}

        workflow_name ->
          {workflow_name, :execute}
      end

    case WorkflowName.execution_arities(workflow_name, execute_fn) do
      {:ok, arities} ->
        given_arity = Enum.count(inputs)
        arity_with_ctx = given_arity + 1

        if Enum.member?(arities, arity_with_ctx) do
          :ok
        else
          server_name =
            case workflow_name do
              {workflow_name, execute_fn} ->
                WorkflowName.server_recognized_name(workflow_name, execute_fn)

              workflow_name ->
                WorkflowName.server_recognized_name(workflow_name, :execute)
            end

          {:error, "#{server_name} workflow does not implement execute/#{given_arity + 1}"}
        end

      {:error, :unknown} ->
        :ok
    end
  end
end
