defmodule TemporalEngineNif.Data.WorkflowCommandScheduleLocalActivity do
  defstruct [
    :seq,
    :activity_id,
    :activity_type,
    :attempt,
    :headers,
    :arguments,
    :cancellation_type,
    original_schedule_time: nil,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    retry_policy: nil,
    local_retry_threshold: nil
  ]

  alias TemporalEngineNif.Data

  @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          attempt: pos_integer(),
          original_schedule_time: Data.Timestamp.t() | nil,
          headers: %{String.t() => Data.Payload.t()},
          arguments: [Data.Payload.t()],
          schedule_to_close_timeout: Data.Duration.t() | nil,
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          local_retry_threshold: Data.Duration.t() | nil,
          cancellation_type: cancellation_type()
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:activity_id, String.t()}
          | {:activity_type, String.t()}
          | {:attempt, pos_integer()}
          | {:original_schedule_time, Data.Timestamp.opts()}
          | {:headers, %{String.t() => Data.Payload.opts()}}
          | {:arguments, [Data.Payload.opts()]}
          | {:schedule_to_close_timeout, Data.Duration.opts()}
          | {:schedule_to_start_timeout, Data.Duration.opts()}
          | {:start_to_close_timeout, Data.Duration.opts()}
          | {:retry_policy, Data.RetryPolicy.opts()}
          | {:local_retry_threshold, Data.Duration.opts()}
          | {:cancellation_type, cancellation_type()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    schedule = struct!(__MODULE__, opts)

    schedule =
      update_in(schedule, [Access.key(:arguments)], fn arguments ->
        Enum.map(arguments, &Data.Payload.with_opts!/1)
      end)

    schedule =
      update_in(schedule, [Access.key(:headers)], fn headers ->
        Map.new(headers, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    schedule =
      if opts[:original_schedule_time] do
        update_in(schedule, [Access.key(:original_schedule_time)], &Data.Timestamp.with_opts!/1)
      else
        schedule
      end

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
      if opts[:retry_policy] do
        update_in(schedule, [Access.key(:retry_policy)], &Data.RetryPolicy.with_opts!/1)
      else
        schedule
      end

    schedule =
      if opts[:local_retry_threshold] do
        update_in(schedule, [Access.key(:local_retry_threshold)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule
  end
end
