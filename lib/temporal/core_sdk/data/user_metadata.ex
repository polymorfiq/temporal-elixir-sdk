defmodule Temporal.CoreSdk.Data.UserMetadata do
  defstruct summary: nil,
            details: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          summary: Data.Payload.t() | nil,
          details: Data.Payload.t() | nil
        }

  @type opts :: [{:summary, Data.Payload.opts()} | {:details, Data.Payload.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    metadata = struct!(__MODULE__, opts)

    metadata =
      if opts[:summary] do
        update_in(metadata, [Access.key(:summary)], &Data.Payload.with_opts!/1)
      else
        metadata
      end

    metadata =
      if opts[:details] do
        update_in(metadata, [Access.key(:details)], &Data.Payload.with_opts!/1)
      else
        metadata
      end

    metadata
  end
end
