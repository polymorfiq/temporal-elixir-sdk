defmodule Temporal.Comms.Workflows.Commands.ScheduleActivity do
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

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Duration
  alias Temporal.Comms.Shared.Priority
  alias Temporal.Comms.Shared.RetryPolicy

  @type seq :: pos_integer()
  @type schedule_activity :: {:schedule_activity, seq(), schedule_activity_opts()}

  @type activity_id :: String.t()
  @type activity_type :: String.t()
  @type schedule_activity_opts :: %{
          activity_id: String.t(),
          activity_type: String.t(),
          task_queue: String.t(),
          headers: %{String.t() => Payload.t()},
          arguments: [Payload.t()],
          schedule_to_close_timeout: Duration.t() | nil,
          schedule_to_start_timeout: Duration.t() | nil,
          start_to_close_timeout: Duration.t() | nil,
          heartbeat_timeout: Duration.t() | nil,
          retry_policy: RetryPolicy.t() | nil,
          cancellation_type: cancellation_type(),
          do_not_eagerly_execute: bool(),
          versioning_intent: versioning_intent(),
          priority: Priority.t() | nil
        }

  @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  @type versioning_intent :: :unspecified | :compatible | :default

  @type t :: %__MODULE__{
          seq: pos_integer(),
          activity_id: String.t(),
          activity_type: String.t(),
          task_queue: String.t(),
          headers: %{String.t() => Payload.t()},
          arguments: [Payload.t()],
          schedule_to_close_timeout: Duration.t() | nil,
          schedule_to_start_timeout: Duration.t() | nil,
          start_to_close_timeout: Duration.t() | nil,
          heartbeat_timeout: Duration.t() | nil,
          retry_policy: RetryPolicy.t() | nil,
          cancellation_type: cancellation_type(),
          do_not_eagerly_execute: bool(),
          versioning_intent: versioning_intent(),
          priority: Priority.t() | nil
        }

  @spec send_to_engine(schedule_activity()) :: t()
  def send_to_engine({:schedule_activity, seq, opts}) do
    opts = Map.put(opts, :seq, seq)
    schedule = struct!(__MODULE__, opts)

    if !schedule.schedule_to_close_timeout && !schedule.start_to_close_timeout do
      raise "Activity must have schedule_to_close_timeout or start_to_close_timeout"
    end

    schedule =
      update_in(schedule, [Access.key(:headers)], fn headers ->
        Map.new(headers, fn {k, v} -> {k, Payload.send_to_engine(v)} end)
      end)

    schedule =
      update_in(schedule, [Access.key(:arguments)], fn arguments ->
        Enum.map(arguments, fn
          arg when is_tuple(arg) -> arg |> Payload.send_to_engine()
          arg -> {:json, Jason.encode!(arg)} |> Payload.send_to_engine()
        end)
      end)

    schedule =
      if opts[:schedule_to_close_timeout] do
        update_in(schedule, [Access.key(:schedule_to_close_timeout)], &Duration.send_to_engine/1)
      else
        schedule
      end

    schedule =
      if opts[:schedule_to_start_timeout] do
        update_in(schedule, [Access.key(:schedule_to_start_timeout)], &Duration.send_to_engine/1)
      else
        schedule
      end

    schedule =
      if opts[:start_to_close_timeout] do
        update_in(schedule, [Access.key(:start_to_close_timeout)], &Duration.send_to_engine/1)
      else
        schedule
      end

    schedule =
      if opts[:heartbeat_timeout] do
        update_in(schedule, [Access.key(:heartbeat_timeout)], &Duration.send_to_engine/1)
      else
        schedule
      end

    schedule =
      if opts[:retry_policy] do
        update_in(schedule, [Access.key(:retry_policy)], &RetryPolicy.send_to_engine/1)
      else
        schedule
      end

    schedule =
      if opts[:priority] do
        update_in(schedule, [Access.key(:priority)], &Priority.send_to_engine/1)
      else
        schedule
      end

    {:schedule_activity, schedule}
  end
end
