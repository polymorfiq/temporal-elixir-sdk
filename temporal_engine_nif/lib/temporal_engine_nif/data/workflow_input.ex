defmodule TemporalEngineNif.Data.WorkflowInput do
  @type t ::
          {:integer, integer()}
          | {:float, float()}
          | {:string, String.t()}
          | {:json, String.t()}
          | {:bytes, binary()}

  @spec bytes(binary()) :: t()
  def bytes(value) when is_binary(value), do: {:bytes, value}

  @spec to_val!(t()) :: term()
  def to_val!({:integer, val}) when is_integer(val), do: val
  def to_val!({:float, val}) when is_float(val), do: val
  def to_val!({:string, val}) when is_binary(val), do: val
  def to_val!({:json, val}) when is_binary(val), do: Jason.decode!(val)
  def to_val!({:bytes, val}) when is_binary(val), do: val
  def to_val!({:bytes, val}) when is_list(val), do: :binary.list_to_bin(val)

  def to_val!({:erlang_external_term, val}) when is_binary(val),
    do: :erlang.binary_to_term(:binary.list_to_bin(val))
end
