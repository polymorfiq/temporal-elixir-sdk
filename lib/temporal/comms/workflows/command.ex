defmodule Temporal.Comms.Workflows.Command do
  defstruct user_metadata: nil,
            variant: nil

  alias Temporal.Comms.Shared.UserMetadata
  alias Temporal.Comms.Workflows.Commands.ScheduleActivity
  alias Temporal.Comms.Workflows.Commands.StartTimer
  alias Temporal.Comms.Workflows.Commands.CompleteWorkflowExecution
  alias Temporal.Comms.Workflows.Commands.FailWorkflowExecution

  @type command ::
          StartTimer.start_timer()
          | ScheduleActivity.schedule_activity()
          | CompleteWorkflowExecution.complete_workflow_execution()
          | FailWorkflowExecution.fail_workflow_execution()
          | {:command, command(), opts()}

  @type t :: %__MODULE__{
          user_metadata: UserMetadata.t() | nil,
          variant:
            StartTimer.t()
            | ScheduleActivity.t()
            | CompleteWorkflowExecution.t()
            | FailWorkflowExecution.t()
        }

  @type opts ::
          [
            {:user_metadata, Data.UserMetadata.opts()}
          ]

  @spec send_to_engine(command()) :: t()
  def send_to_engine({:command, variant, opts}) do
    variant_mod =
      case elem(variant, 0) do
        :start_timer -> StartTimer
        :schedule_activity -> ScheduleActivity
        :fail_workflow_execution -> FailWorkflowExecution
        :complete_workflow_execution -> CompleteWorkflowExecution
      end

    opts = Keyword.put(opts, :variant, variant_mod.send_to_engine(variant))
    cmd = struct!(__MODULE__, opts)

    cmd =
      if opts[:user_metadata] do
        update_in(cmd, [Access.key(:user_metadata)], &UserMetadata.send_to_engine/1)
      else
        cmd
      end

    cmd
  end

  def send_to_engine(variant), do: send_to_engine({:command, variant, []})
end
