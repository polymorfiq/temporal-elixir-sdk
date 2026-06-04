defmodule Temporal.CoreSdk.Data.WorkflowInput do
  @type value :: integer() | float() | String.t() | term()
  @type t :: {:integer, integer()} | {:float, float()} | {:string, String.t()} | {:json, String.t()} | {:bytes, String.t()}

  @spec new(value()) :: t()
  def new(value) when is_integer(value), do: {:integer, value}
  def new(value) when is_float(value), do: {:float, value}
  def new(value) when is_binary(value), do: {:string, value}
  def new(value), do: {:json, Jason.encode!(value)}

  @spec bytes(binary()) :: t()
  def bytes(value) when is_binary(value), do: {:bytes, :binary.bin_to_list(value)}
end
