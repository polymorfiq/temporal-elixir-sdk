defmodule TemporalEngine.Data.Queries do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Payload

  deftype :workflow_query do
    @doc "The workflow-author-defined identifier of the query. Typically a function name."
    @type query_type :: required :: String.t()

    @doc "Serialized arguments that will be provided to the query handler."
    @type query_args :: required :: [nested!(Payload.payload())]

    @doc "Headers that were passed by the caller of the query and copied by temporal server into the workflow task."
    @type header :: nested!(Common.header())
  end

  deftype :query_options do
    @default :unspecified
    @type reject_condition ::
            required :: :unspecified | :none | :not_open | :not_completed_cleanly
  end

  deftype :query_workflow_response do
    @type query_result :: [nested!(Payload.payload())]
    @type query_rejected :: nested!(Queries.query_rejected())
  end

  deftype :query_rejected do
    @type status ::
            required ::
            :unspecified
            | :running
            | :completed
            | :failed
            | :canceled
            | :terminated
            | :continued_as_new
            | :timed_out
            | :paused
  end

  @type query_reject_condition :: :unspecified | :none | :not_open | :not_completed_cleanly
end
