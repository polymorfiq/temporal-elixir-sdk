defmodule Temporal.CoreSdk.Data.WorkflowCommandScheduleNexusOperation do
  defstruct [
    :seq,
    :endpoint,
    :service,
    :operation,
    :cancellation_type,
    nexus_header: %{},
    input: nil,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil
  ]

  alias Temporal.CoreSdk.Data

  @type cancellation_type ::
          :wait_cancellation_completed | :abandon | :try_cancel | :wait_cancellation_requested

  @type t :: %__MODULE__{
          seq: pos_integer(),
          endpoint: String.t(),
          service: String.t(),
          operation: String.t(),
          input: Data.Payload.t() | nil,
          schedule_to_close_timeout: Data.Duration.t() | nil,
          nexus_header: %{String.t() => String.t()},
          cancellation_type: cancellation_type(),
          schedule_to_start_timeout: Data.Duration.t() | nil,
          start_to_close_timeout: Data.Duration.t() | nil
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:endpoint, String.t()}
          | {:service, String.t()}
          | {:operation, String.t()}
          | {:input, Data.Payload.opts()}
          | {:schedule_to_close_timeout, Data.Duration.opts()}
          | {:nexus_header, %{String.t() => String.t()}}
          | {:cancellation_type, cancellation_type()}
          | {:schedule_to_start_timeout, Data.Duration.opts()}
          | {:start_to_close_timeout, Data.Duration.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    schedule = struct!(__MODULE__, opts)

    schedule =
      if opts[:input] do
        update_in(schedule, [Access.key(:input)], &Data.Payload.with_opts!/1)
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
      if opts[:start_to_close_timeout] do
        update_in(schedule, [Access.key(:start_to_close_timeout)], &Data.Duration.with_opts!/1)
      else
        schedule
      end

    schedule
  end
end
