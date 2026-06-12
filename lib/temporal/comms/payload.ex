defmodule Temporal.Comms.Payload do
  defstruct [
    :data,
    metadata: %{},
    external_payloads: []
  ]

  @type payload ::
          {data_type(), binary()} | {data_type(), binary(), payload_opts()}
  @type data_type :: :json | :etf | :bytes

  @type payload_opts :: [
          {:metadata, %{String.t() => [byte()]}}
          | {:external_payloads, [{:size_bytes, integer()}]}
        ]

  def send_to_sdk(%__MODULE__{} = msg) do
    opts = msg |> Map.from_struct() |> Keyword.new() |> Keyword.drop([:data])

    case msg.metadata do
      %{"encoding" => ~c"json/plain"} ->
        {:json, :binary.list_to_bin(msg.data), opts}

      %{"encoding" => ~c"binary/plain"} ->
        {:bytes, :binary.list_to_bin(msg.data), opts}

      %{"encoding" => ~c"application/x-erlang-term"} ->
        {:etf, :binary.list_to_bin(msg.data), opts}
    end
  end

  def send_to_engine({encoding, data}), do: send_to_engine({encoding, data, []})

  def send_to_engine({:json, data, opts}) do
    opts = Keyword.put(opts, :data, :binary.bin_to_list(data))
    payload = struct!(__MODULE__, opts)

    metadata =
      payload.metadata
      |> Map.put("encoding", "json/plain")
      |> Enum.map(fn {k, v} -> {k, :binary.bin_to_list(v)} end)
      |> Map.new()

    payload = %{payload | metadata: metadata}

    payload
  end

  def send_to_engine({:bytes, data, opts}) do
    opts = Keyword.put(opts, :data, :binary.bin_to_list(data))
    payload = struct!(__MODULE__, opts)

    metadata =
      payload.metadata
      |> Map.put("encoding", "binary/plain")
      |> Enum.map(fn {k, v} -> {k, :binary.bin_to_list(v)} end)
      |> Map.new()

    payload = %{payload | metadata: metadata}

    payload
  end

  def send_to_engine({:etf, data, opts}) do
    opts = Keyword.put(opts, :data, :binary.bin_to_list(data))
    payload = struct!(__MODULE__, opts)

    metadata =
      payload.metadata
      |> Map.put("encoding", "application/x-erlang-term")
      |> Enum.map(fn {k, v} -> {k, :binary.bin_to_list(v)} end)
      |> Map.new()

    payload = %{payload | metadata: metadata}

    payload
  end

  def send_to_engine(data), do: send_to_engine({:etf, :erlang.term_to_binary(data), []})

  def to_value({encoding, data}), do: to_value({encoding, data, []})

  def to_value({:json, data, _}), do: Jason.decode!(data)
  def to_value({:bytes, data, _}), do: data
  def to_value({:etf, data, _}), do: :erlang.binary_to_term(data)
end
