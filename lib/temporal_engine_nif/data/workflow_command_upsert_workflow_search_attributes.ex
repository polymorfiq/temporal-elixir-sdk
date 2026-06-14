defmodule TemporalEngineNif.Data.WorkflowCommandUpsertWorkflowSearchAttributes do
  defstruct search_attributes: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          search_attributes: Data.WorkflowSearchAttributes.t() | nil
        }

  @type opts :: [{:search_attributes, Data.WorkflowSearchAttributes.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    upsert = struct!(__MODULE__, opts)

    upsert =
      if opts[:search_attributes] do
        update_in(
          upsert,
          [Access.key(:search_attributes)],
          &Data.WorkflowSearchAttributes.with_opts!/1
        )
      end

    upsert
  end
end
