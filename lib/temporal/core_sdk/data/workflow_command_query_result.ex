defmodule Temporal.CoreSdk.Data.WorkflowCommandQueryResult do
  defstruct [:query_id, variant: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          query_id: String.t(),
          variant: Data.WorkflowCommandQueryResultVariant.t() | nil
        }

  @type opts :: [
          {:query_id, String.t()} | {:variant, Data.WorkflowCommandQueryResultVariant.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    result = struct!(__MODULE__, opts)

    result =
      if opts[:variant] do
        update_in(
          result,
          [Access.key(:variant)],
          &Data.WorkflowCommandQueryResultVariant.with_opts!/1
        )
      else
        result
      end

    result
  end
end
