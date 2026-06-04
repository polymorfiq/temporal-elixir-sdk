defmodule Temporal.Workflows.WorkflowExecHandle do
  defstruct [:metadata, :client, :handle]

  alias Temporal.Client

  @type metadata :: [
          {:worflow_id, String.t()} | {:task_queue, String.t()} | {:workflow_name, String.t()}
        ]
  @type t() :: %__MODULE__{metadata: metadata(), client: Client.t(), handle: term()}

  @spec new(Client.t(), handle :: term(), metadata) :: t()
  def new(client, handle, metadata \\ []),
    do: %__MODULE__{metadata: metadata, client: client, handle: handle}
end

defimpl Temporal.Workflows.WorkflowExecution, for: Temporal.Workflows.WorkflowExecHandle do
  @impl true
  def status(_exec), do: :running
end
