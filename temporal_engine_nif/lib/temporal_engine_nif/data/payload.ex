defmodule TemporalEngineNif.Data.Payload do
  defstruct [
    :data,
    metadata: %{},
    external_payloads: []
  ]

  import TemporalEngine.Data.Payload

  alias TemporalEngineNif.Data.ExternalPayloadDetails
  alias TemporalEngine.Data.Payload, as: EnginePayload

  @type t :: %__MODULE__{
          metadata: %{String.t() => [byte()]},
          data: [byte()],
          external_payloads: [ExternalPayloadDetails.t()]
        }

  @spec to_record(t() | nil) :: EnginePayload.payload() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{} = payload) do
    payload(
      metadata: Map.new(payload.metadata, fn {k, v} -> {k, :binary.list_to_bin(v)} end),
      data: :binary.list_to_bin(payload.data),
      external_payloads: Enum.map(payload.external_payloads, &external(size_bytes: &1.size_bytes))
    )
  end

  @spec from_record(EnginePayload.payload() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(payload() = p) do
    %__MODULE__{
      metadata: Map.new(payload(p, :metadata), fn {k, v} -> {k, :binary.bin_to_list(v)} end),
      data: :binary.bin_to_list(payload(p, :data)),
      external_payloads:
        Enum.map(
          payload(p, :external_payloads),
          &%ExternalPayloadDetails{size_bytes: &1.size_bytes}
        )
    }
  end
end
