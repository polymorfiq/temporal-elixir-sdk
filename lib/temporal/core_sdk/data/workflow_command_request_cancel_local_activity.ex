defmodule Temporal.CoreSdk.Data.WorkflowCommandRequestCancelLocalActivity do
  defstruct [:seq]

  @type t :: %__MODULE__{
          seq: pos_integer()
        }

  @type opts :: [{:seq, pos_integer()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts), do: struct!(__MODULE__, opts)
end
