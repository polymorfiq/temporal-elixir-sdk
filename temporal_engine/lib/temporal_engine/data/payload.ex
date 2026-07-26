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
  end

  deftype :external_payload_details do
    @structdoc "Describes an externally stored object referenced by this payload."

    @doc "Size in bytes of the externally stored payload"
    @type size_bytes :: required :: pos_integer()
  end
end
