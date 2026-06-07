defmodule Temporal.CoreSdk.Data.WorkflowCommandModifyWorkflowProperties do
  defstruct upserted_memo: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          upserted_memo: Data.WorkflowMemo.t() | nil
        }

  @type opts :: [{:upserted_memo, Data.WorkflowMemo.opts()}] | Data.WorkflowMemo.opts()

  @spec with_opts!(opts()) :: t()
  def with_opts!(memo) when is_map(memo) do
    %__MODULE__{upserted_memo: Data.WorkflowMemo.with_opts!(memo)}
  end

  def with_opts!(opts) do
    props = struct!(__MODULE__, opts)

    props =
      if opts[:upserted_memo] do
        update_in(props, [Access.key(:upserted_memo)], &Data.WorkflowMemo.with_opts!/1)
      else
        props
      end

    props
  end
end
