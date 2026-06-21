defmodule Temporal.Comms.Workflow.WorkflowExecution do
  use GenStage

  import Temporal.Comms.WorkflowContext
  import TemporalEngine.Data.Jobs, only: [initialize_workflow: 2]
  import TemporalEngine.Data.Commands

  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  Record.defrecordp(:workflow_state, [
    :workflow_type,
    :arguments,
    :run_id,
    :workflow_id,
    :task_queue,
    :module,
    :exec_fn,
    exec_ref: nil,
    exec_pid: nil,
    demand: 0,
    seq: 1
  ])

  @typep workflow_state ::
           record(:workflow_state,
             workflow_type: String.t(),
             arguments: [term()],
             run_id: String.t(),
             workflow_id: String.t(),
             task_queue: String.t(),
             module: module(),
             exec_fn: atom(),
             exec_ref: reference() | nil,
             exec_pid: pid() | nil,
             demand: integer(),
             seq: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init(
          {run_id :: String.t(), task_queue :: String.t(),
           module: module(), exec_fn: atom(), config: Jobs.initialize_workflow()}
        ) :: {:producer, workflow_state()}
  def init({run_id, task_queue, module, exec_fn, config}) do
    Process.set_label({:workflow, run_id})

    {:producer,
     workflow_state(
       workflow_type: initialize_workflow(config, :workflow_type),
       arguments:
         initialize_workflow(config, :arguments) |> Enum.map(&Payload.value_from_record/1),
       run_id: run_id,
       workflow_id: initialize_workflow(config, :workflow_id),
       task_queue: task_queue,
       module: module,
       exec_fn: exec_fn
     )}
  end

  @spec queue_commands(pid(), Commands.command()) :: {:ok, Command.command()} | {:error, term()}
  def queue_command(pid, command) do
    with {:ok, cmds} <- queue_commands(pid, [command]) do
      {:ok, List.first(cmds)}
    end
  end

  @spec queue_commands(pid(), [Commands.command()]) ::
          {:ok, [Command.command()]} | {:error, term()}
  def queue_commands(pid, commands),
    do: GenStage.call(pid, {:queue_commands, commands}, :infinity)

  @spec handle_demand(integer(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_demand(demand, state) when demand > 0 do
    existing_demand = workflow_state(state, :demand)
    GenStage.async_info(self(), :execute_if_not_already)

    {:noreply, [], workflow_state(state, demand: existing_demand + demand)}
  end

  @spec handle_call(term(), pid(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_call({:queue_commands, commands}, from, state) do
    seq = workflow_state(state, :seq)

    {commands, seq} =
      Enum.reduce(commands, {[], seq}, fn
        schedule_activity() = cmd, {cmds, seq} ->
          {cmds ++ [schedule_activity(cmd, seq: seq, activity_id: "#{seq}")], seq + 1}

        other, {cmds, seq} ->
          {cmds ++ [other], seq}
      end)

    commands |> IO.inspect(label: "received commands...")
    GenStage.reply(from, {:ok, commands})

    {:noreply, [], workflow_state(state, seq: seq)}
  end

  @spec handle_info(integer(), workflow_state()) :: {:noreply, list(), workflow_state()}
  def handle_info(:execute_if_not_already, workflow_state(exec_ref: ref) = state)
      when is_reference(ref) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, workflow_state(demand: 0) = state) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, state) do
    module = workflow_state(state, :module)
    exec_fn = workflow_state(state, :exec_fn)
    arguments = workflow_state(state, :arguments)

    ctx =
      workflow_context(
        execution: self(),
        task_queue: workflow_state(state, :task_queue),
        run_id: workflow_state(state, :run_id),
        workflow_id: workflow_state(state, :workflow_id)
      )

    {exec_pid, exec_ref} =
      spawn_monitor(fn ->
        apply(module, exec_fn, [ctx | arguments]) |> IO.inspect(label: "EXECUTED!")
      end)

    {:noreply, [], workflow_state(state, exec_pid: exec_pid, exec_ref: exec_ref)}
  end

  def handle_info(
        {:DOWN, exec_ref, :process, _, :normal},
        workflow_state(exec_ref: exec_ref) = state
      ) do
    type = workflow_state(state, :workflow_type)
    workflow_id = workflow_state(state, :workflow_id)
    run_id = workflow_state(state, :run_id)

    Logger.debug(
      "Workflow execution halted: (#{inspect(type)}, Run: #{inspect(run_id)}, ID: #{inspect(workflow_id)})"
    )

    {:noreply, [], workflow_state(state, exec_pid: nil, exec_ref: nil)}
  end
end
