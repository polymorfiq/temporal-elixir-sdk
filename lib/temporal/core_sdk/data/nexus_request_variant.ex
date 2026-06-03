defmodule Temporal.CoreSdk.Data.NexusRequestVariant do
  defstruct start_operation: nil, cancel_operation: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          start_operation: Data.NexusStartOperationRequest.t(),
          cancel_operation: Data.NexusCancelOperationRequest.t()
        }
end
