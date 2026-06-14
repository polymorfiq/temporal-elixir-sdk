defmodule TemporalEngineNif.Data.ActivationDoUpdate do
  defstruct [:id, :protocol_instance_id, :name, :input, :headers, :run_validator, meta: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          id: String.t(),
          protocol_instance_id: String.t(),
          name: String.t(),
          input: [Data.Payload.t()],
          headers: map(),
          meta: Data.UpdateMeta.t() | nil,
          run_validator: bool()
        }
end
