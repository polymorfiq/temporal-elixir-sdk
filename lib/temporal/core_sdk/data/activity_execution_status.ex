defmodule Temporal.CoreSdk.Data.ActivityExecutionStatus do
  alias Temporal.CoreSdk.Data

  @type t ::
          {:completed, Data.ActivityExecutionSuccess.t()}
          | {:failed, Data.ActivityExecutionFailure.t()}
          | {:cancelled, Data.ActivityExecutionCancellation.t()}
          | {:will_complete_async, Data.ActivityExecutionWillCompleteAsync.t()}

  @type opts :: [
          {:completed, Data.ActivityExecutionSuccess.opts()}
          | {:failed, Data.ActivityExecutionFailure.opts()}
          | {:cancelled, Data.ActivityExecutionCancellation.opts()}
          | {:will_complete_async, Data.ActivityExecutionWillCompleteAsync.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!({:completed, opts}),
    do: {:completed, Data.ActivityExecutionSuccess.with_opts!(opts)}

  def with_opts!({:failed, opts}), do: {:failed, Data.ActivityExecutionFailure.with_opts!(opts)}

  def with_opts!({:cancelled, opts}),
    do: {:cancelled, Data.ActivityExecutionCancellation.with_opts!(opts)}

  def with_opts!({:will_complete_async, opts}),
    do: {:will_complete_async, Data.ActivityExecutionWillCompleteAsync.with_opts!(opts)}
end
