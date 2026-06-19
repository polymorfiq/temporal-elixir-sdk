defprotocol TemporalEngine.Runtime do
  alias TemporalEngine.Client
  alias TemporalEngine.Opts.ClientOpts

  @spec create_client(t(), ClientOpts.connection_opts()) ::
          {:ok, Client.t()} | {:error, reason :: term()}
  def create_client(runtime, opts)

  @doc "A unique identifier for the runtime"
  @spec id(t()) :: String.t()
  def id(runtime)
end
