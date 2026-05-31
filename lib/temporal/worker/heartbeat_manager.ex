defmodule Temporal.Worker.HeartbeatManager do
  @moduledoc """
  Handles sending out periodic Worker heartbeats to the Temporal Server.
  """

  use GenServer
  require Record
  require Logger

  alias Temporal.Client
  alias Temporal.Environment
  alias Temporal.Time
  alias Temporal.Worker
  alias Temporal.Comms.Worker.WorkerHeartbeatComms
  alias Temporal.Data.Worker.WorkerHeartbeat

  Record.defrecordp(:beat_state, [
    :heartbeat_interval_ms,
    :client,
    :worker_addr,
    :first_beat_at,
    last_beat_at: nil
  ])

  @typep beat_state ::
           record(:beat_state,
             heartbeat_interval_ms: integer(),
             client: Client.t(),
             worker_addr: Worker.Address.t(),
             first_beat_at: DateTime.t(),
             last_beat_at: DateTime.t()
           )

  @doc false
  def start_link(init_args), do: GenServer.start_link(__MODULE__, init_args)

  @doc false
  def init(worker) do
    hb_interval = Client.worker_heartbeat_interval(worker.client)

    {:ok,
     send_heartbeat(
       beat_state(
         heartbeat_interval_ms: Time.ms(hb_interval),
         client: worker.client,
         worker_addr: worker.address,
         first_beat_at: DateTime.utc_now()
       )
     ), {:continue, :schedule_beat}}
  end

  @doc false
  def handle_continue(:schedule_beat, state) do
    Process.send_after(self(), :beat, beat_state(state, :heartbeat_interval_ms))
    {:noreply, state}
  end

  @doc false
  def handle_info(:beat, state) do
    state = beat_state(state, last_beat_at: DateTime.utc_now())
    {:noreply, state |> send_heartbeat(), {:continue, :schedule_beat}}
  end

  @spec send_heartbeat(beat_state()) :: beat_state()
  def send_heartbeat(state) do
    now = DateTime.utc_now()
    client = beat_state(state, :client)
    worker_addr = beat_state(state, :worker_addr)

    heartbeat = %WorkerHeartbeat{
      worker_started_at: beat_state(state, :first_beat_at),
      last_heartbeat_at: beat_state(state, :last_beat_at),
      heartbeat_at: now,
      addr: worker_addr,
      host: Environment.latest_host_info()
    }

    with :ok <- WorkerHeartbeatComms.send_heartbeat(client, heartbeat) do
      beat_state(state, last_beat_at: now)
    else
      {:error, err} ->
        Logger.error("Heartbeat failed for #{inspect(worker_addr)}: #{inspect(err)}")
        state
    end
  end
end
