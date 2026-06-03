defmodule Temporal.CoreSdk.Data.WorkflowNamespacedExecution do
  defstruct [
    :namespace,
    :workflow_id,
    :run_id
  ]

  @type t :: %__MODULE__{
          namespace: String.t(),
          workflow_id: String.t(),
          run_id: String.t()
        }
end
