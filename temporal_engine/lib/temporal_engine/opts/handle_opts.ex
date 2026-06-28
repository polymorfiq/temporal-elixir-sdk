defmodule TemporalEngine.Opts.HandleOpts do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Duration

  deftype :get_workflow_result do
    @doc "If true (the default), follows to the next workflow run in the execution chain while retrieving results."
    @default true
    @type follow_runs :: boolean()

    @doc "How long to wait before automatically failing the retrieval"
    @type timeout :: nested!(Duration.duration())
  end
end
