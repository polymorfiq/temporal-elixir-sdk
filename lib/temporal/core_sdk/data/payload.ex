defmodule Temporal.CoreSdk.Data.Payload do
  defstruct [
    :data,
    metadata: %{},
    external_payloads: []
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          metadata: %{String.t() => [byte()]},
          data: [byte()],
          external_payloads: [Data.ExternalPayloadDetails.t()]
        }

  @type opts ::
          [
            {:data, [byte()]}
            | {:metadata, %{String.t() => [byte()]}}
            | {:external_payloads, Data.ExternalPayloadDetails.opts()}
          ]
          | t()

  @spec with_opts!(opts()) :: t()
  def with_opts!(%__MODULE__{} = payload), do: payload

  def with_opts!(opts) do
    payload = struct!(__MODULE__, opts)

    payload =
      update_in(payload, [Access.key(:external_payloads)], fn all_payload_opts ->
        Enum.map(all_payload_opts, &Data.ExternalPayloadDetails.with_opts!/1)
      end)

    payload
  end
end
