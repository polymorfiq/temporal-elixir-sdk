defmodule Temporal.CoreSdk.Data.WorkflowStartOptions do
  defstruct [
    :task_queue,
    :workflow_id,
    id_reuse_policy: :unspecified,
    id_conflict_policy: :unspecified,
    enable_eager_workflow_start: false,
    priority: [priority_key: 0, fairness_key: "", fairness_weight: 1.0],
    links: [],
    completion_callbacks: [],
    execution_timeout: nil,
    run_timeout: nil,
    task_timeout: nil,
    cron_schedule: nil,
    search_attributes: nil,
    retry_policy: nil,
    start_signal: nil,
    header: nil,
    static_summary: nil,
    static_details: nil
  ]

  alias Temporal.CoreSdk.Data
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Duration
  alias Temporal.Comms.Shared.Priority
  alias Temporal.Comms.Shared.RetryPolicy

  @type id_conflict_policy :: :unspecified | :fail | :use_existing | :terminate_existing
  @type id_reuse_policy ::
          :unspecified
          | :allow_duplicate
          | :allow_duplicate_failed_only
          | :reject_duplicate
          | :terminate_if_running

  @type t :: %__MODULE__{
          task_queue: String.t(),
          workflow_id: String.t(),
          id_reuse_policy: id_reuse_policy(),
          id_conflict_policy: id_conflict_policy(),
          execution_timeout: Duration.t() | nil,
          run_timeout: Duration.t() | nil,
          task_timeout: Duration.t() | nil,
          cron_schedule: String.t() | nil,
          search_attributes: %{String.t() => Payload.t()} | nil,
          enable_eager_workflow_start: bool(),
          retry_policy: RetryPolicy.t() | nil,
          start_signal: Data.WorkflowStartSignal.t() | nil,
          links: [Data.Link.t()],
          completion_callbacks: [Data.Callback.t()],
          priority: Priority.t(),
          header: Data.Header.t() | nil,
          static_summary: String.t() | nil,
          static_details: String.t() | nil
        }

  @type opts :: [
          {:task_queue, String.t()}
          | {:workflow_id, String.t()}
          | {:execution_timeout, Duration.duration()}
          | {:run_timeout, Duration.duration()}
          | {:task_timeout, Duration.duration()}
          | {:cron_schedule, String.t()}
          | {:search_attributes, %{String.t() => Payload.payload()}}
          | {:retry_policy, RetryPolicy.retry_policy()}
          | {:start_signal, Data.WorkflowStartSignal.opts()}
          | {:static_summary, String.t()}
          | {:static_details, String.t()}
          | {:id_reuse_policy, id_reuse_policy()}
          | {:id_conflict_policy, id_conflict_policy()}
          | {:enable_eager_workflow_start, bool()}
          | {:links, [Link.opts()]}
          | {:header, Data.Header.opts()}
          | {:completion_callbacks, [Callback.opts()]}
          | {:priority, Priority.priority()}
        ]

  def with_opts!(opts) do
    start_opts = struct!(__MODULE__, opts)
    start_opts = update_in(start_opts, [Access.key(:priority)], &Priority.send_to_engine/1)

    start_opts =
      update_in(start_opts, [Access.key(:links)], fn links ->
        Enum.map(links, &Data.Link.with_opts!/1)
      end)

    start_opts =
      update_in(start_opts, [Access.key(:completion_callbacks)], fn callbacks ->
        Enum.map(callbacks, &Data.Callback.with_opts!/1)
      end)

    start_opts =
      if opts[:header] do
        update_in(start_opts, [Access.key(:header)], &Data.Header.with_opts!/1)
      else
        start_opts
      end

    start_opts =
      if opts[:execution_timeout] do
        update_in(start_opts, [Access.key(:execution_timeout)], &Duration.send_to_engine/1)
      else
        start_opts
      end

    start_opts =
      if opts[:run_timeout] do
        update_in(start_opts, [Access.key(:run_timeout)], &Duration.send_to_engine/1)
      else
        start_opts
      end

    start_opts =
      if opts[:task_timeout] do
        update_in(start_opts, [Access.key(:task_timeout)], &Duration.send_to_engine/1)
      else
        start_opts
      end

    start_opts =
      if opts[:retry_policy] do
        update_in(start_opts, [Access.key(:retry_policy)], &RetryPolicy.send_to_engine/1)
      else
        start_opts
      end

    start_opts =
      if opts[:start_signal] do
        update_in(start_opts, [Access.key(:start_signal)], &Data.WorkflowStartSignal.with_opts!/1)
      else
        start_opts
      end

    start_opts
  end
end
