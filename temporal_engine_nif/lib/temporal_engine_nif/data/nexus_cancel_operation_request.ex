defmodule TemporalEngineNif.Data.NexusCancelOperationRequest do
  defstruct [:service, :operation, :operation_id, :operation_token]

  @type t :: %__MODULE__{
          service: String.t(),
          operation: String.t(),
          operation_id: String.t(),
          operation_token: String.t()
        }
end
