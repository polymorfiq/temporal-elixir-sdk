defprotocol Temporal.Client do
  alias Temporal.Time

  @spec namespace(t()) :: String.t()
  def namespace(client)

  @spec worker_grouping_key(t()) :: String.t()
  def worker_grouping_key(client)

  @spec worker_heartbeat_interval(t()) :: Time.time_interval()
  def worker_heartbeat_interval(client)

  @spec channel(t()) :: GRPC.Channel.t()
  def channel(client)
end
