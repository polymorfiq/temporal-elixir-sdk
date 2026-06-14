defmodule TemporalEngineNif.Data.Payloads do
  defstruct [
    :payloads
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          payloads: [Data.Payload.t()]
        }

  @type opts :: [{:payloads, Data.Payload.opts()}] | [Data.Payload.opts()] | t()

  @spec with_opts!(opts()) :: t()
  def with_opts!(%__MODULE__{} = payloads), do: payloads

  def with_opts!(opts) when is_list(opts) do
    if Keyword.keyword?(opts) do
      payloads = struct!(__MODULE__, opts)

      payloads =
        update_in(payloads, [Access.key(:payloads)], fn all_payload_opts ->
          Enum.map(all_payload_opts, &Data.Payload.with_opts!/1)
        end)

      payloads
    else
      %__MODULE__{payloads: Enum.map(opts, &Data.Payload.with_opts!/1)}
    end
  end
end
