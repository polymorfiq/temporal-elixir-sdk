defprotocol TemporalEngine.Client do
  alias TemporalEngine.Config
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Opts.WorkflowOpts
  alias TemporalEngine.Worker
  alias TemporalEngine.WorkflowHandle

  @spec create_worker(t(), Config.worker_config()) ::
          {:ok, Worker.t()} | {:error, reason :: term()}
  def create_worker(client, config)

  @spec start_workflow(
          t(),
          WorkflowOpts.workflow_definition(),
          inputs :: [Payload.payload()],
          WorkflowOpts.workflow_start_opts()
        ) :: {:ok, WorkflowHandle.t()} | {:error, reason :: term()}
  def start_workflow(client, definition, args, opts)

  @doc "A unique identifier for the client"
  @spec id(t()) :: String.t()
  def id(client)

  @doc "The namespace the client is listening to"
  @spec namespace(t()) :: String.t()
  def namespace(client)
end
