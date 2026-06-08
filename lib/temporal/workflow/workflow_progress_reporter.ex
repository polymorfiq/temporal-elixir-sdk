defmodule Temporal.Workflow.WorkflowProgressReporter do
  use GenServer

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletion
  alias Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus, as: SuccessStatus
  alias Temporal.CoreSdk.Data.WorkflowCommandScheduleActivity
  alias Temporal.CoreSdk.Data.WorkflowInput

  require Logger
  require Record

  Record.defrecordp(:progress_state, [
    :run_id,
    :workflow_id,
    :worker_id,
    :task_queue,
    :next_seq,
    :runtime,
    :worker
  ])

  @type progress_state() :: term()

  @type schedule_activity_opts :: WorkflowCommandScheduleActivity.opts()

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    {:ok,
     progress_state(
       run_id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id,
       task_queue: exec_ctx.task_queue,
       next_seq: 1,
       runtime: exec_ctx.runtime,
       worker: exec_ctx.worker
     ), {:continue, :started}}
  end

  def handle_continue(:started, state) do
    {:noreply, state}
  end

  @spec schedule_activity(
          pid(),
          activity_id :: String.t(),
          activity_type :: String.t(),
          args :: [term()],
          schedule_activity_opts()
        ) :: :ok | {:error, term()}
  def schedule_activity(reporter, activity_id, activity_type, args, opts \\ []),
    do:
      GenServer.call(
        reporter,
        {:schedule_activity, activity_id, activity_type, args, opts},
        :infinity
      )

  def report_completed_success(reporter, result) do
    output = WorkflowInput.with_opts!(result) |> Payload.from_workflow_input()
    GenServer.call(reporter, {:report_completed_success, output}, :infinity)
  end

  def handle_call(
        {:schedule_activity, activity_id, activity_type, args, opts},
        _from,
        state
      ) do
    # Do not let user override these
    opts = Keyword.drop(opts, [:seq, :activity_id, :activity_type, :arguments])

    {state, send_resp} =
      report_successful_completion(state,
        commands: [
          {:schedule_activity,
           [
             seq: nil,
             activity_id: activity_id,
             activity_type: activity_type,
             task_queue: progress_state(state, :task_queue).queue_name,
             arguments: args
           ] ++ opts}
        ]
      )

    {:reply, send_resp, state}
  end

  def handle_call({:report_completed_success, output}, _from, state) do
    {state, send_resp} =
      report_successful_completion(state,
        commands: [{:complete_workflow_execution, [result: output]}]
      )

    {:reply, send_resp, state}
  end

  @spec report_successful_completion(progress_state(), SuccessStatus.opts()) ::
          :ok | {:error, term()}
  defp report_successful_completion(state, completion) do
    next_seq = progress_state(state, :next_seq)
    commands = Keyword.get(completion, :commands, [])

    {next_seq, commands} =
      Enum.reduce(commands, {next_seq, []}, fn {cmd_variant, cmd_opts}, {next_seq, cmds} ->
        if Keyword.has_key?(cmd_opts, :seq) do
          {next_seq + 1, cmds ++ [{cmd_variant, Keyword.put(cmd_opts, :seq, next_seq)}]}
        else
          {next_seq, cmds ++ [{cmd_variant, cmd_opts}]}
        end
      end)

    completion = Keyword.put(completion, :commands, commands)

    complete_activation_msg =
      WorkflowActivationCompletion.with_opts!(
        run_id: progress_state(state, :run_id),
        status: {:successful, completion}
      )

    parent = self()

    child =
      spawn_link(fn ->
        CoreSdk._worker_complete_workflow_activation(
          progress_state(state, :runtime).core,
          progress_state(state, :worker).core,
          complete_activation_msg,
          self()
        )
        |> case do
          :ok ->
            send(parent, {self(), progress_state(state, next_seq: next_seq), :ok})

          other_resp ->
            send(parent, {self(), state, other_resp})
        end

        receive do
          :ok ->
            :ok

          {:error, err} ->
            Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
        end
      end)

    receive do
      {^child, state, resp} ->
        {state, resp}
    end
  end
end
