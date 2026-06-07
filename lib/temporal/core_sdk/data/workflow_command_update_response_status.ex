defmodule Temporal.CoreSdk.Data.WorkflowCommandUpdateResponseStatus do
  alias Temporal.CoreSdk.Data

  @type t ::
          {:accepted, bool()}
          | {:rejected, Data.WorkflowFailure.t()}
          | {:completed, Data.Payload.t()}

  @type opts ::
          {:accepted, bool()}
          | {:rejected, Data.WorkflowFailure.opts()}
          | {:completed, Data.Payload.opts()}

  @spec with_opts!(opts()) :: t()
  def with_opts!({:accepted, opts}), do: {:accepted, opts}
  def with_opts!({:rejected, opts}), do: {:rejected, Data.WorkflowFailure.with_opts!(opts)}
  def with_opts!({:completed, opts}), do: {:completed, Data.Payload.with_opts!(opts)}
end
