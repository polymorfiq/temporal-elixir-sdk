defmodule Temporal.Comms.WorkflowContext do
  require Record

  Record.defrecord(:workflow_context, [:worker, :workflow_id, :run_id])
end
