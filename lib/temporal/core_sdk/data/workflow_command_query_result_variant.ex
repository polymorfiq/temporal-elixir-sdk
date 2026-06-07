defmodule Temporal.CoreSdk.Data.WorkflowCommandQueryResultVariant do
  alias Temporal.CoreSdk.Data

  @type t ::
          {:succeeded, Data.WorkflowCommandQuerySuccess.t()} | {:failed, Data.WorkflowFailure.t()}

  @type opts ::
          {:succeeded, Data.WorkflowCommandQuerySuccess.opts()}
          | {:failed, Data.WorkflowFailure.opts()}

  @spec with_opts!(opts()) :: t()
  def with_opts!({:succeeded, opts}),
    do: {:succeeded, Data.WorkflowCommandQuerySuccess.with_opts!(opts)}

  def with_opts!({:failed, opts}), do: {:failed, Data.WorkflowFailure.with_opts!(opts)}
end
