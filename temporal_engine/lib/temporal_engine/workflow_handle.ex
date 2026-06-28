defprotocol TemporalEngine.WorkflowHandle do
  require Record

  require TemporalEngine.Opts.HandleOpts
  require TemporalEngine.Data.Queries
  require TemporalEngine.Data.Updates
  require TemporalEngine.Data.Signals

  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Signals
  alias TemporalEngine.Data.Updates
  alias TemporalEngine.Opts.HandleOpts

  @spec get_result(t(), HandleOpts.get_workflow_result()) ::
          {:ok, Payload.payload()} | {:error, reason :: term()}
  def get_result(handle, opts)

  @doc "Send a Query message to a workflow and get the response"
  @spec query(
          t(),
          query_type :: String.t(),
          args :: [Payload.payload()],
          opts :: Queries.query_options()
        ) :: {:ok, Queries.query_workflow_response()} | {:error, term()}
  def query(handle, query_type, args, opts)

  @doc "Send an Update message to a workflow and get the response"
  @spec update(
          t(),
          update_name :: String.t(),
          args :: [Payload.payload()],
          opts :: Updates.update_options()
        ) :: {:ok, Updates.workflow_update_response()} | {:error, term()}
  def update(handle, update_name, args, opts)

  @doc "Send an Signal message to a workflow and get the response"
  @spec signal(
          t(),
          signal_name :: String.t(),
          args :: [Payload.payload()],
          opts :: Signals.signal_workflow_request()
        ) :: {:ok, Signals.signal_workflow_response()} | {:error, term()}
  def signal(handle, update_name, args, opts)
end
