defmodule Temporal.Comms.Activities.ActivityTaskCancel do
  defstruct [
    :reason,
    details: nil
  ]

  alias Temporal.Comms.Activities.CancellationDetails

  @type cancel_reason() ::
          :not_found | :cancelled | :timed_out | :worker_shutdown | :paused | :reset

  @type t :: %__MODULE__{
          reason: cancel_reason(),
          details: CancellationDetails.t() | nil
        }

  @type activity_task_cancel :: {:cancel, cancel_reason(), CancellationDetails.details()}

  @spec send_to_sdk(t()) :: activity_task_cancel()
  def send_to_sdk(%__MODULE__{} = cancel) do
    {:cancel, cancel.reason,
     if(cancel.details, do: CancellationDetails.send_to_sdk(cancel.details), else: [])}
  end
end
