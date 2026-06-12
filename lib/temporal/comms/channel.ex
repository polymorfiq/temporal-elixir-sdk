defmodule Temporal.Comms.Channel do
  defstruct [:task_queue, :runtime, :pid]
  use GenServer

  require Logger
  require Record

  alias Temporal.Client
  alias Temporal.Comms.Payload
  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.CoreSdk
  alias Temporal.Comms.Workflows.ActivationCompletion
  alias Temporal.Supervisor.WorkerSupervisor

  @type t :: %__MODULE__{}

  Record.defrecordp(:channel_state, listeners: [])

  def init(_) do
    {:ok, channel_state()}
  end

  def add_listener(channel, pid, types \\ nil) do
    GenServer.cast(channel.pid, {:add_listener, pid, types})
  end

  def remove_listener(channel, pid) do
    GenServer.cast(channel.pid, {:remove_listener, pid})
  end

  def record_to_client(channel, msg) do
    case msg do
      {:activation, _, opts} ->
        GenServer.cast(channel.pid, {:to_client, :activation, msg})
        jobs = Keyword.get(opts, :jobs, [])

        jobs
        |> Enum.map(fn
          {:initialize_workflow, id, type, args, opts} ->
            GenServer.cast(
              channel.pid,
              {:to_client, :job,
                {:initialize_workflow, id, type, Enum.map(args, &Payload.to_value/1), opts}}
            )

          {:resolve_activity, seq, {:completed, result}, opts} ->
            GenServer.cast(
              channel.pid,
              {:to_client, :job,
               {:resolve_activity, seq, {:completed, result |> Payload.to_value()}, opts}}
            )

          job ->
            GenServer.cast(channel.pid, {:to_client, :job, job})
        end)

      other ->
        GenServer.cast(channel.pid, {:to_client, :unknown, other})
    end
  end

  def record_to_engine(channel, msg) do
    case msg do
      {:activation_completion, _, {:success, commands} = result} ->
        GenServer.cast(channel.pid, {:to_engine, :completion, msg})
        GenServer.cast(channel.pid, {:to_engine, :completion_result, result})

        Enum.each(commands, fn
          {:complete_workflow_execution, %Payload{} = payload} ->
            GenServer.cast(
              channel.pid,
              {:to_engine, :command,
               {:complete_workflow_execution,
                payload |> Payload.send_to_sdk() |> Payload.to_value()}}
            )

          command ->
            GenServer.cast(channel.pid, {:to_engine, :command, command})
        end)

      {:activation_completion, _, result} ->
        GenServer.cast(channel.pid, {:to_engine, :completion, msg})
        GenServer.cast(channel.pid, {:to_engine, :completion_result, result})

      other ->
        GenServer.cast(channel.pid, {:to_engine, :unknown, other})
    end
  end

  def handle_cast({:add_listener, pid, types}, state) do
    listeners = channel_state(state, :listeners)
    {:noreply, channel_state(state, listeners: [{pid, types} | listeners])}
  end

  def handle_cast({:remove_listener, pid}, state) do
    listeners = channel_state(state, :listeners)
    {:noreply, channel_state(state, listeners: Enum.filter(listeners, &(&1 != pid)))}
  end

  def handle_cast({:to_client, type, msg}, state) do
    channel_state(state, :listeners)
    |> Enum.each(fn {pid, types} ->
      cond do
        types == nil -> send(pid, {:to_client, type, msg})
        Enum.member?(types, type) -> send(pid, {:to_client, type, msg})
        true -> :ok
      end
    end)

    {:noreply, state}
  end

  def handle_cast({:to_engine, type, msg}, state) do
    channel_state(state, :listeners)
    |> Enum.each(fn {pid, types} ->
      cond do
        types == nil -> send(pid, {:to_engine, type, msg})
        Enum.member?(types, type) -> send(pid, {:to_engine, type, msg})
        true -> :ok
      end
    end)

    {:noreply, state}
  end

  def new(task_queue) do
    with {:ok, runtime} <- Client.core_runtime(task_queue.client),
         {:ok, pid} <- GenServer.start_link(__MODULE__, :ok) do
      %__MODULE__{task_queue: task_queue, runtime: runtime, pid: pid}
    end
  end

  def send_to_engine(channel, worker, tuple) do
    record_to_engine(channel, tuple)

    send_to_engine(elem(tuple, 0), channel, worker, tuple)
  end

  def send_to_engine(:activation_completion, channel, worker, tuple),
    do:
      ActivationCompletion.send_to_engine(tuple)
      |> send_activation_completion(channel, worker, tuple)

  def send_to_sdk(channel, %mod{} = msg) do
    tuple = mod.send_to_sdk(msg)
    record_to_client(channel, tuple)

    tuple
  end

  def poll_activity_task(channel, worker) do
    with {:ok, core_worker_pid} <- WorkerSupervisor.worker_pid(worker.id),
         {:ok, core_worker} = CoreWorker.get_core(core_worker_pid) do
      parent = self()

      child =
        spawn_link(fn ->
          Process.set_label({:long_activity_task_poll, worker.id})

          CoreSdk._worker_poll_activity_task(channel.runtime.core, core_worker.core, self())
          |> case do
            :ok ->
              receive do
                {:ok, task} ->
                  send(parent, {self(), {:ok, task}})

                {:error, error} ->
                  send(parent, {self(), {:error, error}})
              end

            resp ->
              send(parent, {self(), {:error, "Error polling activity tasks: #{inspect(resp)}"}})
          end
        end)

      receive do
        {^child, {:ok, task}} ->
          send_to_sdk(channel, task)

        {^child, {:error, err}} ->
          {:error, err}
      end
    end
  end

  def poll_activation(channel, worker) do
    with {:ok, core_worker_pid} <- WorkerSupervisor.worker_pid(worker.id),
         {:ok, core_worker} = CoreWorker.get_core(core_worker_pid) do
      parent = self()

      child =
        spawn_link(fn ->
          Process.set_label({:long_activity_task_poll, worker.id})

          CoreSdk._worker_poll_workflow_activation(channel.runtime.core, core_worker.core, self())
          |> case do
            :ok ->
              receive do
                {:ok, task} ->
                  send(parent, {self(), {:ok, task}})

                {:error, error} ->
                  send(parent, {self(), {:error, error}})
              end

            resp ->
              send(parent, {self(), {:error, "Error polling activity tasks: #{inspect(resp)}"}})
          end
        end)

      receive do
        {^child, {:ok, task}} ->
          send_to_sdk(channel, task)

        {^child, {:error, err}} ->
          {:error, err}
      end
    end
  end

  defp send_activation_completion(msg, channel, worker, _tuple) do
    with {:ok, core_worker_pid} <- WorkerSupervisor.worker_pid(worker.id),
         {:ok, core_worker} = CoreWorker.get_core(core_worker_pid) do
      parent = self()

      child =
        spawn_link(fn ->
          CoreSdk._worker_complete_workflow_activation(
            channel.runtime.core,
            core_worker.core,
            msg,
            self()
          )
          |> case do
            :ok ->
              receive do
                {:ok, _} ->
                  send(parent, {self(), :ok})

                {:error, err} ->
                  send(parent, {self(), {:error, err}})
                  Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
              end

            other_resp ->
              send(parent, {self(), other_resp})
          end
        end)

      receive do
        {^child, resp} ->
          resp
      end
    end
  end
end
