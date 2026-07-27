defmodule Temporal.Converter.DefaultDataConverter do
  defstruct []
end

defimpl TemporalEngine.Converter.DataConverter, for: Temporal.Converter.DefaultDataConverter do
  import TemporalEngine.Data.Payload

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

  @impl true
  def to_payload(conv, value), do: to_payload(conv, value, available_encoders())

  def to_payload(_, val, %{json: json}) do
    {:ok,
     payload(
       data: json.encode!(val),
       metadata: %{"encoding" => "json/plain"}
     )}
  end

  def to_payload(_, val, _) do
    {:ok,
     payload(
       data: :erlang.term_to_binary(val),
       metadata: %{"encoding" => "application/x-erlang-term"}
     )}
  end

  @impl true
  def from_payload(conv, payload), do: from_payload(conv, payload, available_encoders())

  def from_payload(_, payload(data: encoded, metadata: %{"encoding" => "json/plain"}), %{
        json: json
      }) do
    json.decode(encoded)
  end

  def from_payload(_, payload(metadata: %{"encoding" => "json/plain"}), _) do
    {:error, "No JSON encoder specified. Cannot decode JSON"}
  end

  def from_payload(
        _,
        payload(data: encoded, metadata: %{"encoding" => "application/x-erlang-term"}),
        _
      ) do
    {:ok, :erlang.binary_to_term(encoded)}
  end

  def from_payload(_, payload(metadata: %{"encoding" => encoding}), _) do
    {:error, "Temporal Client's DataConverter does not know the encoding: #{inspect(encoding)}"}
  end

  @impl true
  def to_payloads(conv, values) do
    Enum.reduce(values, {:ok, []}, fn value, acc ->
      with {:ok, values} <- acc,
           {:ok, val} <- to_payload(conv, value) do
        {:ok, [val | values]}
      end
    end)
  end

  @impl true
  def from_payloads(conv, payloads) do
    Enum.reduce(payloads, {:ok, []}, fn payload, acc ->
      with {:ok, values} <- acc,
           {:ok, val} <- from_payload(conv, payload) do
        {:ok, [val | values]}
      end
    end)
  end

  @impl true
  def to_string(_, payload(data: encoded, metadata: %{"encoding" => "json/plain"})) do
    encoded
  end

  def to_string(_, payload(data: encoded, metadata: %{"encoding" => "application/x-erlang-term"})) do
    inspect(:erlang.binary_to_term(encoded))
  end

  def to_string(_, payload(metadata: %{"encoding" => encoding})) do
    "Temporal Client's DataConverter does not know the encoding: #{inspect(encoding)}"
  end

  @impl true
  def to_strings(conv, payloads), do: Enum.map(payloads, &to_string(conv, &1))
end
