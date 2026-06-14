defmodule TemporalEngine.Data.Payload do
  require Record

  Record.defrecord(:payload, [
    :data,
    metadata: %{},
    external_payloads: []
  ])

  @type payload ::
          record(:payload,
            metadata: %{String.t() => binary()},
            data: binary(),
            external_payloads: [external()]
          )

  Record.defrecord(:external, [:size_bytes])
  @type external :: record(:external, size_bytes: pos_integer())

  @spec value_from_record(payload()) :: term()
  def value_from_record(payload(metadata: %{"encoding" => "json/plain"}, data: data)),
    do: Jason.decode!(data)

  def value_from_record(
        payload(metadata: %{"encoding" => "application/x-erlang-term"}, data: data)
      ),
      do: :erlang.binary_to_term(data)

  def value_from_record(payload(data: data)),
    do: data

  @spec record_from_value(term()) :: payload()
  def record_from_value({:integer, val}) when is_integer(val),
    do:
      payload(
        data: Jason.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  def record_from_value({:float, val}) when is_float(val),
    do:
      payload(
        data: Jason.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  def record_from_value({:string, val}) when is_binary(val),
    do:
      payload(
        data: Jason.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  def record_from_value({:json, val}) when is_binary(val),
    do:
      payload(
        data: val,
        metadata: %{"encoding" => "json/plain"}
      )

  def record_from_value({:etf, val}),
    do:
      payload(
        data: val,
        metadata: %{"encoding" => "application/x-erlang-term"}
      )

  def record_from_value({:bytes, bytes}), do: payload(data: bytes)
  def record_from_value(val), do: record_from_value({:etf, val})
end
