defprotocol TemporalEngine.Converter.DataConverter do
  require TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Payload

  @spec to_payload(t(), value :: term()) :: {:ok, Payload.payload()} | {:error, term()}
  def to_payload(converter, value)

  @spec from_payload(t(), payload :: Payload.payload()) :: {:ok, term()} | {:error, term()}
  def from_payload(converter, payload)

  @spec to_payloads(t(), values :: [term()]) :: {:ok, [Payload.payload()]} | {:error, term()}
  def to_payloads(converter, values)

  @spec from_payloads(t(), payloads :: [Payload.payload()]) :: {:ok, [term()]} | {:error, term()}
  def from_payloads(converter, payloads)

  @spec to_string(t(), payload :: Payload.payload()) :: String.t()
  def to_string(converter, payload)

  @spec to_strings(t(), payloads :: [Payload.payload()]) :: [String.t()]
  def to_strings(converter, payloads)
end

defimpl TemporalEngine.Converter.DataConverter, for: TemporalEngine.Converter.NoopConverter do
  # This is simply a do-nothing implementation to keep typechecker happy
  def to_payload(_, _), do: {:error, "Not implemented"}

  def from_payload(_, _), do: {:error, "Not implemented"}

  def to_payloads(_, _), do: {:error, "Not implemented"}

  def from_payloads(_, _), do: {:error, "Not implemented"}

  def to_string(_, _), do: "noop"

  def to_strings(_, payloads), do: Enum.map(payloads, fn _ -> "noop" end)
end
