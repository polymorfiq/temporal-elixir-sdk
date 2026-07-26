defprotocol TemporalEngine.Runtime do
  alias TemporalEngine.Client
  alias TemporalEngine.Converter.DataConverter
  alias TemporalEngine.Opts.ClientOpts

  @type client_opts :: [
          {:connection, ClientOpts.connection_opts()} | {:data_converter, DataConverter.t()}
        ]

  @spec create_client(t(), client_opts()) ::
          {:ok, Client.t()} | {:error, reason :: term()}
  def create_client(runtime, opts)

  @doc "A unique identifier for the runtime"
  @spec id(t()) :: String.t()
  def id(runtime)
end
