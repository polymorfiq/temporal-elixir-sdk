defmodule Temporal.CoreSdk.Data.WorkflowInput do
  defstruct [
    integer: nil,
    float: nil,
    string: nil,
    json: nil,
    bytes: nil,
  ]

  @type value :: integer() | float() | String.t() | term()
  @type t :: %__MODULE__{
               integer: integer() | nil,
               float: float() | nil,
               string: String.t() | nil,
               json: String.t() | nil,
               bytes: [byte()] | nil
        }

  @spec new(value()) :: t()
  def new(value) when is_integer(value), do: %__MODULE__{integer: value}
  def new(value) when is_float(value), do: %__MODULE__{float: value}
  def new(value) when is_binary(value), do: %__MODULE__{string: value}
  def new(value), do: %__MODULE__{json: Jason.encode!(value)}

  @spec bytes(binary()) :: t()
  def bytes(value) when is_binary(value), do: %__MODULE__{bytes: :binary.bin_to_list(value)}
end
