defmodule Temporal.CoreSdk.Data.ActivationQueryWorkflow do
  defstruct [:query_id, :query_type, :arguments, :headers]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          query_id: String.t(),
          query_type: String.t(),
          arguments: [Data.Payload.t()],
          headers: map()
        }
end
