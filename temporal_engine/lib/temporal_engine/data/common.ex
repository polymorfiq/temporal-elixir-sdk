defmodule TemporalEngine.Data.Common do
  use TemporalEngine.Data.TypeSpec

  deftype :workflow_execution do
    @structdoc """
    Identifies a specific workflow within a namespace. Practically speaking, because run_id is a uuid, a workflow execution is globally unique.

    Note that many commands allow specifying an empty run id as a way of saying “target the latest run of the workflow”.
    """

    @type workflow_id :: required :: String.t()
    @type run_id :: required :: String.t()
  end

  deftype :namespaced_workflow_execution do
    @structdoc "Identifying information about a particular workflow execution, including namespace"

    @type namespace :: required :: String.t()
    @type workflow_id :: required :: String.t()
    @type run_id :: required :: String.t()
  end
end
