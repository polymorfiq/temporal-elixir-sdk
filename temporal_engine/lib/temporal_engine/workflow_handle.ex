defprotocol TemporalEngine.WorkflowHandle do
  require Record

  require TemporalEngine.Opts.HandleOpts
  require TemporalEngine.Data.Queries

  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Opts.HandleOpts

  @spec get_result(t(), HandleOpts.get_workflow_result_opts_opts()) ::
          {:ok, Payload.payload()} | {:error, reason :: term()}
  def get_result(handle, opts \\ [])

  @doc "Send a Query message to a workflow and get the response"
  @spec query(
          t(),
          query_type :: String.t(),
          args :: [Payload.payload()],
          opts :: Queries.query_options()
        ) :: {:ok, Queries.query_workflow_response()} | {:error, term()}
  def query(handle, query_type, args, opts)
end
