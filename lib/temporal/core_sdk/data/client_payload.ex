defmodule Temporal.CoreSdk.Data.ClientPayload do
  @type t ::
          {:integer, integer()}
          | {:float, float()}
          | {:string, String.t()}
          | {:json, String.t()}
          | {:bytes, binary()}

  @type opts :: integer() | float() | String.t() | t() | term()

  @spec with_opts!(opts()) :: t()
  def with_opts!({:integer, val}) when is_integer(val), do: {:json, Jason.encode!(val)}
  def with_opts!({:float, val}) when is_float(val), do: {:json, Jason.encode!(val)}
  def with_opts!({:string, val}) when is_binary(val), do: {:json, Jason.encode!(val)}
  def with_opts!({:json, val}) when is_binary(val), do: {:json, val}
  def with_opts!({:bytes, val}) when is_binary(val), do: {:bytes, :binary.bin_to_list(val)}
  def with_opts!({:bytes, val}) when is_list(val), do: {:bytes, val}

  def with_opts!({:erlang_external_term, val}) when is_binary(val),
    do: {:erlang_external_term, val}

  def with_opts!({:etf, val}),
    do: {:erlang_external_term, :erlang.term_to_binary(val)}

  def with_opts!(value), do: {:json, Jason.encode!(value)}

  @spec bytes(binary()) :: t()
  def bytes(value) when is_binary(value), do: {:bytes, value}

  @spec to_val!(t()) :: term()
  def to_val!({:json, val}), do: Jason.decode!(to_string(val))
  def to_val!({:bytes, val}) when is_binary(val), do: val
  def to_val!({:bytes, val}) when is_list(val), do: :binary.list_to_bin(val)

  def to_val!({:erlang_external_term, val}) when is_binary(val),
    do: :erlang.binary_to_term(val)
end
