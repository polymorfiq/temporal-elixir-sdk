defmodule TemporalEngine.Data.Signals do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Failure

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Payload

  deftype :signal_workflow_request do
    @doc "The namespace of the client (Will be filled in by SDK)"
    @default ""
    @type namespace :: required :: String.t()

    @type workflow_execution :: nested!(Common.workflow_execution())

    @doc "The workflow author-defined name of the signal to send to the workflow"
    @type signal_name :: required :: String.t()

    @doc "Serialized value(s) to provide with the signal"
    @type input :: required :: [nested!(Payload.payload())]

    @doc "The identity of the client (Will be filled in by SDK)"
    @default ""
    @type identity :: required :: String.t()

    @doc "Used to de-dupe sent signals"
    @type request_id :: required :: String.t()

    @doc "Deprecated."
    @default ""
    @type control :: required :: String.t()

    @doc "Headers that are passed with the signal to the processing workflow. These can include things like auth or tracing tokens."
    @type header :: nested!(Common.header())

    @doc "Links to be associated with the WorkflowExecutionSignaled event."
    @default []
    @type links :: required :: [nested!(Common.link())]
  end

  deftype :signal_workflow_response do
    @doc "Link to be associated with the WorkflowExecutionSignaled event. Added on the response to propagate the backlink. Available from Temporal server 1.31 and up."
    @type link :: nested!(Common.link())
  end
end
