defmodule TemporalEngine.Data.Payload do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Payload

  deftype :workflow_arguments do
    @type args :: required :: [nested!(Payload.payload())]
  end

  deftype :payload do
    @structdoc "Represents some binary (byte array) data (ex: activity input parameters or workflow result) with metadata which describes this binary data (format, encoding, encryption, etc). Serialization of the data may be user-defined."
    @opts_type :: term()

    @default %{}
    @type metadata :: required :: %{String.t() => binary()}

    @type data :: required :: binary()

    @default []
    @type external_payloads :: required :: [nested!(Payload.external_payload_details())]

    @spec validate_opts(opts(), path :: String.t()) :: {:ok, t()} | {:error, term()}
    def validate_opts(opts, _path), do: {:ok, opts}

    @spec from_opts(opts()) :: {:ok, t()} | {:error, term()}
    def from_opts(payload() = opts), do: {:ok, opts}
    def from_opts(opts), do: {:ok, record_from_value(opts)}
  end

  deftype :external_payload_details do
    @structdoc "Describes an externally stored object referenced by this payload."

    @doc "Size in bytes of the externally stored payload"
    @type size_bytes :: required :: pos_integer()
  end

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
