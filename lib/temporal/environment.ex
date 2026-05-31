defmodule Temporal.Environment do
  use GenServer
  require Record

  @info_table_name :_temporal_sdk_environment
  @host_info_key :latest_host_info

  Record.defrecordp(:host_info_state,
    cpu_usage: 0.0,
    memory_usage: 0.0,
    os_process_id: nil,
    hostname: nil,
    last_checked_at: nil
  )

  @typedoc """
  ## Host Info
  - **`:cpu_usage`** - 1.0 represents all CPU cores of the machine are fully utilized, 0.0 represents they are all idle

  - **`:memory_usage`** - 1.0 represents all RAM of the machine is fully utilized, 0.0 represents all RAM is available

  - **`:os_process_id`** - Process ID of the Erlang VM on the host system

  - **`:hostname`** - Hostname of the host system as reported by the OS

  - **`:last_checked_at`** - When this information was gathered from the host machine
  """
  @type host_info :: %{
          cpu_usage: float(),
          memory_usage: float(),
          os_process_id: String.t(),
          hostname: String.t(),
          last_checked_at: DateTime.t()
        }

  @typep host_info_state ::
           record(:host_info_state,
             cpu_usage: float(),
             memory_usage: float(),
             os_process_id: integer(),
             hostname: String.t(),
             last_checked_at: DateTime.t()
           )

  @doc """
  Retrieves the latest recorded data around CPU, Memory and other host properties.

  **See `t:host_info/0` for more information.**
  """
  @spec latest_host_info() :: host_info()
  def latest_host_info do
    [{@host_info_key, host}] = :ets.lookup(@info_table_name, @host_info_key)

    %{
      cpu_usage: host_info_state(host, :cpu_usage),
      memory_usage: host_info_state(host, :memory_usage),
      os_process_id: host_info_state(host, :os_process_id),
      hostname: host_info_state(host, :hostname),
      last_checked_at: host_info_state(host, :last_checked_at)
    }
  end

  @doc false
  def child_spec(_opts \\ []) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [:ok]}
    }
  end

  @doc false
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  @doc false
  def init(_) do
    try do
      :ets.new(@info_table_name, [:named_table, :set, :protected])
    catch
      _ -> :ok
    end

    {:ok, %{host_info: record_host_info(host_info_state())}, {:continue, :schedule_host_info}}
  end

  @doc false
  @impl true
  def handle_continue(:schedule_host_info, state) do
    Process.send_after(self(), :get_host_info, 5 * 1000)
    {:noreply, state}
  end

  @doc false
  @impl true
  def handle_info(:get_host_info, state) do
    {:noreply, %{state | host_info: record_host_info(state.host_info)},
     {:continue, :schedule_host_info}}
  end

  @spec record_host_info(host_info_state()) :: host_info_state()
  defp record_host_info(prev_info) do
    {total_memory, used_memory, _} = :memsup.get_memory_data()
    {:ok, hostname_charlist} = :inet.gethostname()
    hostname = to_string(hostname_charlist)
    os_pid = System.pid()

    {cores, _, _, _} = :cpu_sup.util([:detailed])
    max_utilization = 256.0 * Enum.count(cores)
    avg_sys_cpu_utilization = :cpu_sup.avg1() / max_utilization

    latest_info =
      prev_info
      |> host_info_state(
        cpu_usage: avg_sys_cpu_utilization,
        memory_usage: used_memory / total_memory,
        hostname: hostname,
        os_process_id: os_pid,
        last_checked_at: DateTime.utc_now()
      )

    :ets.insert(@info_table_name, {@host_info_key, latest_info})

    latest_info
  end
end
