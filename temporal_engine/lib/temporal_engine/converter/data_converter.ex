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
