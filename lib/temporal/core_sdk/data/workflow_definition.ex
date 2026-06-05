defmodule Temporal.CoreSdk.Data.WorkflowDefinition do
  defstruct [
    :name
  ]

  @type t :: %__MODULE__{
          name: String.t()
        }

  @type opts :: [{:name, String.t()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
