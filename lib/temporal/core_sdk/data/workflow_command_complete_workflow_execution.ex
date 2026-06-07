defmodule Temporal.CoreSdk.Data.WorkflowCommandCompleteWorkflowExecution do
  defstruct result: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          result: Data.Payload.t() | nil
        }

  @type opts :: [{:result, Data.Payload.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    complete = struct!(__MODULE__, opts)

    complete =
      if opts[:result] do
        update_in(complete, [Access.key(:result)], &Data.Payload.with_opts!/1)
      else
        complete
      end

    complete
  end
end
