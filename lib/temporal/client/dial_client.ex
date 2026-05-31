defmodule Temporal.Client.DialClient do
  use Supervisor

  defstruct [
    :id,
    :host_port,
    :namespace,
    :worker_heartbeat_interval,
    :worker_grouping_key,
    :channel
  ]

  alias Temporal.Constants
  alias Temporal.Time

  @type host_port() :: String.t()
  @type t() :: %__MODULE__{
          id: String.t(),
          host_port: host_port(),
          namespace: String.t(),
          worker_heartbeat_interval: Time.time_interval(),
          worker_grouping_key: String.t(),
          channel: GRPC.Channel.t()
        }

  @type client_opt ::
          {:namespace, String.t()}
          | {:worker_heartbeat_interval, Time.time_interval()}

  @spec new(host_port :: host_port(), opts :: [client_opt()]) :: {:ok, t()} | {:error, term()}
  def new(host_port, opts \\ []) do
    validate_opts!(opts)
    namespace = Keyword.get(opts, :namespace, Constants.default_namespace())

    worker_hb_interval =
      Keyword.get(opts, :worker_heartbeat_interval, Constants.default_worker_heartbeat_interval())

    worker_grouping_key = UUID.uuid4()

    client_id = "#{worker_grouping_key}@#{namespace}"

    client_sup =
      DynamicSupervisor.start_child(
        Temporal.Clients,
        %{
          id: client_id,
          start:
            {__MODULE__, :start_link,
             [client_id, opts, [name: {:via, Registry, {Temporal.ClientRegistry, client_id}}]]}
        }
      )

    with {:ok, channel} <- GRPC.Stub.connect(host_port),
         {:ok, _} <- client_sup do
      {:ok,
       %__MODULE__{
         id: client_id,
         host_port: host_port,
         channel: channel,
         namespace: namespace,
         worker_grouping_key: worker_grouping_key,
         worker_heartbeat_interval: worker_hb_interval
       }}
    end
  end

  defp validate_opts!(opts) do
    opts
    |> Keyword.validate!([
      :namespace,
      :worker_heartbeat_interval
    ])
  end

  @spec start_link(client_id :: String.t(), client_opts :: [client_opt()], sup_opts :: keyword()) ::
          {:ok, pid()} | {:error, term()}
  def start_link(client_id, client_opts, sup_opts \\ []) do
    Supervisor.start_link(__MODULE__, {client_id, client_opts}, sup_opts)
  end

  @impl true
  @spec init({client_id :: String.t(), client_opts :: [client_opt()]}) :: Supervisor.init_result()
  def init({client_id, client_opts}) do
    validate_opts!(client_opts)

    children = [
      %{
        id: "workers@#{client_id}",
        start: {Temporal.Worker.Supervisor, :start_link, []}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defimpl Temporal.Client, for: Temporal.Client.DialClient do
  @default_close_timeout_ms 60_000

  defp client_supervisor(c) do
    GenServer.whereis({:via, Registry, {Temporal.ClientRegistry, c.id}})
  end

  def worker_supervisor(c) do
    if sup = client_supervisor(c) do
      Supervisor.which_children(sup)
      |> Enum.find(fn {_id, _pid, _type, modules} -> modules == [Temporal.Worker.Supervisor] end)
      |> case do
        {_, pid, _, _} when is_pid(pid) -> {:ok, pid}
        {_, :undefined, _, _} -> {:error, :client_worker_supervisor_not_started}
        nil -> {:error, :no_worker_supervisor}
      end
    else
      {:error, :client_supervisor_not_running}
    end
  end

  def id(c), do: c.id
  def namespace(c), do: c.namespace
  def worker_grouping_key(c), do: c.worker_grouping_key
  def channel(c), do: c.channel
  def worker_heartbeat_interval(c), do: c.worker_heartbeat_interval

  def stop_workers(c) do
    with {:ok, worker_sup} <- worker_supervisor(c) do
      DynamicSupervisor.which_children(worker_sup)
      |> Enum.each(fn
        {_id, pid, _, _} when is_pid(pid) ->
          DynamicSupervisor.terminate_child(worker_sup, pid)

        _ ->
          :ok
      end)

      :ok
    else
      {:error, err} -> {:error, err}
    end
  end

  def close(c) do
    if sup = client_supervisor(c) do
      Supervisor.stop(sup, :shutdown, @default_close_timeout_ms)

      with {:ok, closed_c} <- GRPC.Stub.disconnect(c.channel) do
        {:ok, %{c | channel: closed_c}}
      end
    else
      {:error, :no_client_supervisor}
    end
  end
end
