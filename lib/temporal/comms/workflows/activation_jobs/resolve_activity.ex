defmodule Temporal.Comms.Workflows.ActivationJobs.ResolveActivity do
  defstruct [:seq, :is_local, result: nil]

  alias Temporal.Comms.Activities.ResolutionStatus

  @type t :: %__MODULE__{
          seq: pos_integer(),
          result: ResolutionStatus.status(),
          is_local: bool()
        }

  @type resolve_activity :: {:resolve_activity, seq(), result(), opts()}
  @type seq :: pos_integer()
  @type result :: ResolutionStatus.status()
  @type opts :: %{is_local: bool()}

  @spec send_to_sdk(t()) :: resolve_activity()
  def send_to_sdk(%__MODULE__{} = job) do
    {:resolve_activity, job.seq, ResolutionStatus.send_to_sdk(job.result),
     %{is_local: job.is_local}}
  end
end
