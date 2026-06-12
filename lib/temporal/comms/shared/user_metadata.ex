defmodule Temporal.Comms.Shared.UserMetadata do
  defstruct summary: nil,
            details: nil

  alias Temporal.Comms.Payload

  @type t :: %__MODULE__{
          summary: Payload.t() | nil,
          details: Payload.t() | nil
        }

  @type user_metadata :: [{:summary, Payload.payload()} | {:details, Payload.payload()}]

  @spec send_to_engine(user_metadata()) :: t()
  def send_to_engine(opts) do
    metadata = struct!(__MODULE__, opts)

    metadata =
      if opts[:summary] do
        update_in(metadata, [Access.key(:summary)], &Payload.send_to_engine/1)
      else
        metadata
      end

    metadata =
      if opts[:details] do
        update_in(metadata, [Access.key(:details)], &Payload.send_to_engine/1)
      else
        metadata
      end

    metadata
  end
end
