defmodule Temporal.CoreSdk.Data.WorkflowCommandCancelTimer do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }

  @type opts :: [{:seq, pos_integer()}] | pos_integer()

  @spec with_opts!(opts()) :: t()
  def with_opts!(seq) when is_integer(seq), do: %__MODULE__{seq: seq}
  def with_opts!(opts), do: struct!(__MODULE__, opts)
end
