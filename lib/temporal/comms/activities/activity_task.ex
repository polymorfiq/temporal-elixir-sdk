defmodule Temporal.Comms.Activities.ActivityTask do
  defstruct [
    :task_token,
    variant: nil
  ]

  alias Temporal.Comms.Activities.ActivityTaskStart
  alias Temporal.Comms.Activities.ActivityTaskCancel

  @type task_token :: binary()
  @type activity_task ::
          {:activity_task,
           ActivityTaskStart.activity_task_start() | ActivityTaskCancel.activity_task_cancel(),
           task_token()}

  @type t :: %__MODULE__{
          task_token: [byte()],
          variant: ActivityTaskStart.t() | ActivityTaskCancel.t()
        }

  @spec send_to_sdk(t()) :: activity_task()
  def send_to_sdk(%__MODULE__{variant: {:start, variant}} = task) do
    {:activity_task, ActivityTaskStart.send_to_sdk(variant), :binary.list_to_bin(task.task_token)}
  end

  def send_to_sdk(%__MODULE__{variant: {:cancel, variant}} = task) do
    {:activity_task, ActivityTaskCancel.send_to_sdk(variant),
     :binary.list_to_bin(task.task_token)}
  end
end
