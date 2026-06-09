defmodule Temporal.CoreSdk.Data.Payload do
  defstruct data: nil,
            metadata: %{},
            data_binary: nil,
            external_payloads: []

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          metadata: %{String.t() => [byte()]},
          data: [byte()] | nil,
          data_binary: binary() | nil,
          external_payloads: [Data.ExternalPayloadDetails.t()]
        }

  @type opts ::
          [
            {:data, [byte()]}
            | {:data_binary, binary()}
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

  @spec to_value(t()) :: term()
  def to_value(%{metadata: %{"encoding" => ~c"json/plain"}} = payload),
    do: Jason.decode!(payload.data_binary || to_string(payload.data))

  def to_value(%{metadata: %{"encoding" => "application/x-erlang-term"}} = payload),
    do: :erlang.binary_to_term(payload.data_binary || :binary.list_to_bin(payload.data))

  def to_value(payload),
    do: payload.data_binary || :binary.list_to_bin(payload.data)

  @spec from_workflow_input(Data.ClientPayload.t()) :: t()
  def from_workflow_input({:integer, val}) when is_integer(val),
    do: %__MODULE__{
      data_binary: Jason.encode!(val),
      metadata: %{"encoding" => String.to_charlist("json/plain")}
    }

  def from_workflow_input({:float, val}) when is_float(val),
    do: %__MODULE__{
      data_binary: Jason.encode!(val),
      metadata: %{"encoding" => String.to_charlist("json/plain")}
    }

  def from_workflow_input({:string, val}) when is_binary(val),
    do: %__MODULE__{
      data_binary: Jason.encode!(val),
      metadata: %{"encoding" => String.to_charlist("json/plain")}
    }

  def from_workflow_input({:json, val}) when is_binary(val),
    do: %__MODULE__{
      data_binary: val,
      metadata: %{"encoding" => String.to_charlist("json/plain")}
    }

  def from_workflow_input({:erlang_external_term, val}),
    do: %__MODULE__{
      data_binary: val,
      metadata: %{"encoding" => "application/x-erlang-term"}
    }

  def from_workflow_input({:bytes, bytes}), do: %__MODULE__{data: bytes}
end
