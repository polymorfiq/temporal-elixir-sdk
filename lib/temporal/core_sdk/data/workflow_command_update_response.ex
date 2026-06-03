defmodule Temporal.CoreSdk.Data.WorkflowCommandUpdateResponse do
  defstruct [:protocol_instance_id, response: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          protocol_instance_id: String.t(),
          response: Data.WorkflowCommandUpdateResponseStatus.t() | nil
        }
end
