defmodule Temporal.CoreSdk.Data.WorkflowInput do
  @type t ::
          {:integer, integer()}
          | {:float, float()}
          | {:string, String.t()}
          | {:json, String.t()}
          | {:bytes, binary()}

  @type opts :: integer() | float() | String.t() | t() | term()

  @spec with_opts!(opts()) :: t()
  def with_opts!({:integer, val}) when is_integer(val), do: {:integer, val}
  def with_opts!({:float, val}) when is_float(val), do: {:float, val}
  def with_opts!({:string, val}) when is_binary(val), do: {:string, val}
  def with_opts!({:json, val}) when is_binary(val), do: {:json, val}
  def with_opts!({:bytes, val}) when is_binary(val), do: {:bytes, :binary.bin_to_list(val)}
  def with_opts!({:bytes, val}) when is_list(val), do: {:bytes, val}
  def with_opts!(value) when is_integer(value), do: {:integer, value}
  def with_opts!(value) when is_float(value), do: {:float, value}
  def with_opts!(value) when is_binary(value), do: {:string, value}
  def with_opts!(value), do: {:json, Jason.encode!(value)}

  @spec bytes(binary()) :: t()
  def bytes(value) when is_binary(value), do: {:bytes, value}
end
