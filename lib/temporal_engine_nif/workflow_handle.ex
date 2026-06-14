defmodule TemporalEngineNif.WorkflowHandle do
  defstruct [:core]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.WorkflowHandle, for: TemporalEngineNif.WorkflowHandle do
  import TemporalEngine.WorkflowHandle

  @impl true
  def get_result(handle, opts) do
    {:error, :not_implemented}
  end
end
