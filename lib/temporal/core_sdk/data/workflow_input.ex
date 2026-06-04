defmodule Temporal.CoreSdk.Data.WorkflowInput do
  defstruct [
    :metadata,
    :data,
    :external_payloads
  ]

  @type t :: %__MODULE__{
          metadata: %{String.t() => String.t()},
          data: [byte()],
          external_payloads: list()
        }
end
