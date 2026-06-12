defmodule Temporal.Comms.Activities.ResolutionStatus do
  defstruct [:status]

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Failure
  alias Temporal.Comms.Shared.Duration
  alias Temporal.Comms.Shared.Timestamp

  defmodule Completed do
    defstruct [:result]

    @type t :: %__MODULE__{result: Payload.t()}
  end

  defmodule Failed do
    defstruct [:failure]

    @type t :: %__MODULE__{failure: Failure.t()}
  end

  defmodule Cancelled do
    defstruct [:failure]

    @type t :: %__MODULE__{failure: Failure.t()}
  end

  defmodule Backoff do
    defstruct [:attempt, backoff_duration: nil, original_schedule_time: nil]

    alias Temporal.Comms.Shared.{Duration, Timestamp}

    @type t :: %__MODULE__{
            attempt: pos_integer(),
            backoff_duration: Duration.t() | nil,
            original_schedule_time: Timestamp.t() | nil
          }
  end

  @type t :: %__MODULE__{
          status:
            {:completed, Completed.t()}
            | {:failed, Failed.t()}
            | {:cancelled, Cancelled.t()}
            | {:will_complete_async, WillCompleteAsync.t()}
        }

  @type result ::
          {:completed, Payload.payload()}
          | {:failed, Failure.failure()}
          | {:cancelled, Failure.failure()}
          | {:backoff, attempt :: pos_integer(), backoff_opts()}

  @type backoff_opts :: [
          {:backoff_duration, Duration.duration()}
          | {:original_schedule_time, Timestamp.timestamp()}
        ]

  def send_to_sdk(%__MODULE__{status: {:completed, %{result: result}}}) do
    {:completed, Payload.send_to_sdk(result)}
  end

  def send_to_sdk(%__MODULE__{status: {:failed, %{failure: failure}}}) do
    {:failed, if(failure, do: Failure.send_to_sdk(failure))}
  end

  def send_to_sdk(%__MODULE__{status: {:cancelled, %{failure: failure}}}) do
    {:cancelled, if(failure, do: Failure.send_to_sdk(failure))}
  end

  def send_to_sdk(%__MODULE__{status: {:backoff, backoff}}) do
    opts = []

    opts =
      if duration = opts[:backoff_duration] do
        Keyword.put(opts, :backoff_duration, Duration.send_to_sdk(duration))
      else
        opts
      end

    opts =
      if scheduled = opts[:original_schedule_time] do
        Keyword.put(opts, :original_schedule_time, Timestamp.send_to_sdk(scheduled))
      else
        opts
      end

    {:backoff, backoff.attempt, opts}
  end
end
