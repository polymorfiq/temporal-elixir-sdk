defmodule TemporalEngineNif.Data.WorkflowNamespacedExecution do
  defstruct [
    :namespace,
    :workflow_id,
    :run_id
  ]

  import TemporalEngine.Data.Common

  @type t :: %__MODULE__{
          namespace: String.t(),
          workflow_id: String.t(),
          run_id: String.t()
        }

  @spec to_record(t() | nil) :: Common.namespaced_workflow_execution() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{namespace: namespace, workflow_id: workflow_id, run_id: run_id}) do
    namespaced_workflow_execution(namespace: namespace, workflow_id: workflow_id, run_id: run_id)
  end
end
