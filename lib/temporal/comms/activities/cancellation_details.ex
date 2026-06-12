defmodule Temporal.Comms.Activities.CancellationDetails do
  defstruct [
    :is_not_found,
    :is_cancelled,
    :is_paused,
    :is_timed_out,
    :is_worker_shutdown,
    :is_reset
  ]

  @type t :: %__MODULE__{
          is_not_found: bool(),
          is_cancelled: bool(),
          is_paused: bool(),
          is_timed_out: bool(),
          is_worker_shutdown: bool(),
          is_reset: bool()
        }

  @type details :: [
          {:is_not_found, bool()}
          | {:is_cancelled, bool()}
          | {:is_paused, bool()}
          | {:is_timed_out, bool()}
          | {:is_worker_shutdown, bool()}
          | {:is_reset, bool()}
        ]

  @spec send_to_sdk(t()) :: details()
  def send_to_sdk(%__MODULE__{} = details) do
    details |> Map.from_struct() |> Keyword.new()
  end
end
