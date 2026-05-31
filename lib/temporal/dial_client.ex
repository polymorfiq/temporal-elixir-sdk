defmodule Temporal.DialClient do
  defstruct [:host_port, :channel, :namespace, :worker_heartbeat_interval, :worker_grouping_key]

  alias Temporal.Constants
  alias Temporal.Time

  @type host_port() :: String.t()
  @type t() :: %__MODULE__{
          host_port: host_port(),
          channel: GRPC.Channel.t(),
          namespace: String.t(),
          worker_heartbeat_interval: Time.time_interval(),
          worker_grouping_key: String.t()
        }

  @type client_opt ::
          {:host_port, String.t()}
          | {:namespace, String.t()}
          | {:worker_heartbeat_interval, Time.time_interval()}

  @spec new(opts :: [client_opt()]) :: {:ok, t()} | {:error, term()}
  def new(opts) do
    host_port = Keyword.fetch!(opts, :host_port)
    namespace = Keyword.get(opts, :namespace, Constants.default_namespace())

    worker_hb_interval =
      Keyword.get(opts, :worker_heartbeat_interval, Constants.default_worker_heartbeat_interval())

    with {:ok, channel} <- GRPC.Stub.connect(host_port) do
      {:ok,
       %__MODULE__{
         host_port: host_port,
         channel: channel,
         namespace: namespace,
         worker_grouping_key: UUID.uuid4(),
         worker_heartbeat_interval: worker_hb_interval
       }}
    end
  end
end

defimpl Temporal.Client, for: Temporal.DialClient do
  def namespace(c), do: c.namespace
  def worker_grouping_key(c), do: c.worker_grouping_key
  def channel(c), do: c.channel
  def worker_heartbeat_interval(c), do: c.worker_heartbeat_interval
end
