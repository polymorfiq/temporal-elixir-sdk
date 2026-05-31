defprotocol Temporal.Client do
  alias Temporal.Time

  @spec id(t()) :: String.t()
  def id(client)

  @spec namespace(t()) :: String.t()
  def namespace(client)

  @spec worker_grouping_key(t()) :: String.t()
  def worker_grouping_key(client)

  @spec worker_heartbeat_interval(t()) :: Time.time_interval()
  def worker_heartbeat_interval(client)

  @spec channel(t()) :: GRPC.Channel.t()
  def channel(client)

  @spec worker_supervisor(t()) :: {:ok, pid()} | {:error, term()}
  def worker_supervisor(client)

  @spec stop_workers(t()) :: :ok | {:error, term()}
  def stop_workers(client)

  @spec close(t()) :: {:ok, t()} | {:error, term()}
  def close(client)
end
