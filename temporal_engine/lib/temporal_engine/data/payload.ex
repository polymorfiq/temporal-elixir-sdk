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

  defp available_encoders do
    encoders = %{}

    encoders =
      if json = Application.get_env(:temporal_engine, :json_encoder) do
        Map.put(encoders, :json, json)
      else
        encoders
      end

    encoders
  end

  @spec value_from_record(payload()) :: term()
  def value_from_record(payload) do
    value_from_record(payload, available_encoders())
  end

  defp value_from_record(payload(metadata: %{"encoding" => "json/plain"}, data: data), %{
         json: json
       }),
       do: json.decode!(data)

  defp value_from_record(payload(metadata: %{"encoding" => "json/plain"}), _),
    do:
      raise(
        "Received JSON-encoded data when `:json_encoder` is not configured for `:temporal_engine`. Please consult documentation."
      )

  defp value_from_record(
         payload(metadata: %{"encoding" => "application/x-erlang-term"}, data: data),
         _
       ),
       do: :erlang.binary_to_term(data)

  defp value_from_record(payload(data: data), _), do: data

  @spec record_from_value(term()) :: payload()
  def record_from_value(value) do
    record_from_value(value, available_encoders())
  end

  defp record_from_value(val, %{json: json}) when is_integer(val),
    do:
      payload(
        data: json.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  defp record_from_value(val, %{json: json}) when is_float(val),
    do:
      payload(
        data: json.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  defp record_from_value(val, %{json: json}) when is_binary(val),
    do:
      payload(
        data: json.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  defp record_from_value({:json, val}, %{json: json}),
    do:
      payload(
        data: json.encode!(val),
        metadata: %{"encoding" => "json/plain"}
      )

  defp record_from_value({:json, _val}, _),
    do:
      raise(
        ":json_encoder not configured for `temporal_engine` application. Please consult documentation."
      )

  defp record_from_value({:etf, val}, _),
    do:
      payload(
        data: :erlang.term_to_binary(val),
        metadata: %{"encoding" => "application/x-erlang-term"}
      )

  defp record_from_value({:bytes, bytes}, _), do: payload(data: bytes)

  defp record_from_value(val, encoders) do
    if json = encoders[:json] do
      with {:ok, encoded} <- json.encode(val) do
        # If JSON is configured, check if JSON-serializable
        # If so, assume JSON is preferred (more easily readable on Temporal Server)
        payload(
          data: encoded,
          metadata: %{"encoding" => "json/plain"}
        )
      else
        _ ->
          # Fallback to ETF if not a JSON-serializable value
          record_from_value({:etf, val})
      end
    else
      # Default to ETF if JSON not configured
      record_from_value({:etf, val})
    end
  end
end
