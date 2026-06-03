defmodule Temporal.CoreSdk.Data.WorkflowNexusOperationFailureInfo do
  defstruct [
    :scheduled_event_id,
    :endpoint,
    :service,
    :operation,
    :operation_id,
    :operation_token
  ]

  @type t :: %__MODULE__{
          scheduled_event_id: integer(),
          endpoint: String.t(),
          service: String.t(),
          operation: String.t(),
          operation_id: String.t(),
          operation_token: String.t()
        }
end
