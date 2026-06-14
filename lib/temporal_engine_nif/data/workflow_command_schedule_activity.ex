defmodule TemporalEngineNif.Data.WorkflowCommandScheduleActivity do
  defstruct [
    :seq,
    :activity_id,
    :activity_type,
    :task_queue,
    arguments: [],
    cancellation_type: :try_cancel,
    do_not_eagerly_execute: false,
    headers: %{},
    versioning_intent: :unspecified,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ]

  alias TemporalEngineNif.Data

  @type cancellation_type() :: :try_cancel | :wait_cancellation_completed | :abandon
  @type versioning_intent() :: :unspecified | :compatible | :default
  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          task_queue: String.t(),
          headers: %{String.t() => Data.Payload.t()},
          arguments: [Data.Payload.t()],
          schedule_to_close_timeout: Data.Duration.t() | nil,
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          heartbeat_timeout: Data.Duration.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          cancellation_type: cancellation_type(),
          do_not_eagerly_execute: bool(),
          versioning_intent: versioning_intent(),
          priority: Data.Priority.t() | nil
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:activity_id, String.t()}
          | {:activity_type, String.t()}
          | {:task_queue, String.t()}
          | {:headers, %{String.t() => Data.Payload.opts()}}
          | {:arguments, [Data.Payload.opts()]}
          | {:schedule_to_close_timeout, Data.Duration.opts()}
          | {:schedule_to_start_timeout, Data.Duration.opts()}
          | {:start_to_close_timeout, Data.Duration.opts()}
          | {:heartbeat_timeout, Data.Duration.opts()}
          | {:retry_policy, Data.RetryPolicy.opts()}
          | {:cancellation_type, cancellation_type()}
          | {:do_not_eagerly_execute, bool()}
          | {:versioning_intent, versioning_intent()}
          | {:priority, Data.Priority.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    schedule = struct!(__MODULE__, opts)

    if !schedule.schedule_to_close_timeout && !schedule.start_to_close_timeout do
      raise "Activity must have schedule_to_close_timeout or start_to_close_timeout"
    end

    schedule =
      update_in(schedule, [Access.key(:headers)], fn headers ->
        Map.new(headers, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    schedule =
      update_in(schedule, [Access.key(:arguments)], fn arguments ->
        Enum.map(arguments, fn arg ->
          arg |> Data.WorkflowInput.with_opts!() |> Data.Payload.from_workflow_input()
        end)
      end)

    schedule =
      if opts[:schedule_to_close_timeout] do
        update_in(schedule, [Access.key(:schedule_to_close_timeout)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:schedule_to_start_timeout] do
        update_in(schedule, [Access.key(:schedule_to_start_timeout)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:start_to_close_timeout] do
        update_in(schedule, [Access.key(:start_to_close_timeout)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:heartbeat_timeout] do
        update_in(schedule, [Access.key(:heartbeat_timeout)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:retry_policy] do
        update_in(schedule, [Access.key(:retry_policy)], &Data.RetryPolicy.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:priority] do
        update_in(schedule, [Access.key(:priority)], &Data.Priority.with_opts!/1)
      else
        schedule
      end

    schedule
  end
end
