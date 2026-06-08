defmodule Temporal.Activity.ActivityExecutor do
  use GenServer

  require Logger
  require Record
  alias Temporal.Activity.ActivityProgressReporter
  alias Temporal.Activity.ActivityContext
  alias Temporal.CoreSdk.Data.Payload
  alias Temporal.Supervisor.ActivitySupervisor

  Record.defrecordp(:activity_state, [
    :activity_id,
    :activity_type,
    :activity_fn,
    :start,
    :exec_ctx
  ])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    Process.flag(:trap_exit, true)

    {:ok,
     activity_state(
       activity_id: exec_ctx.activity_id,
       activity_type: exec_ctx.activity_type,
       activity_fn: exec_ctx.activity_fn,
       start: exec_ctx.activity_start,
       exec_ctx: exec_ctx
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.info(
      "Activity started (Type: #{activity_state(state, :activity_type)}, ID: #{activity_state(state, :activity_id)}"
    )

    start = activity_state(state, :start)
    activity_fn = activity_state(state, :activity_fn)
    ctx = ActivityContext.new(activity_state(state, :exec_ctx))

    inputs = Enum.map(start.input, &Payload.to_value/1)
    resp = apply(activity_fn, [ctx] ++ inputs)

    {:noreply, state, {:continue, {:complete, resp}}}
  end

  def handle_continue({:complete, {:ok, result}}, state) do
    activity_type = activity_state(state, :activity_type)
    activity_id = activity_state(state, :activity_id)

    with {:ok, reporter} <- ActivitySupervisor.progress_reporter_pid(activity_id) do
      case ActivityProgressReporter.report_success(reporter, result) do
        :ok ->
          Logger.info(
            "Activity completion reported (Type: #{inspect(activity_type)}, ID: #{inspect(activity_id)})"
          )

        {:error, err} ->
          Logger.error(
            "Activity completion failed (Type: #{inspect(activity_type)}, ID: #{inspect(activity_id)}) - #{inspect(err)}"
          )
      end
    end

    {:noreply, state}
  end
end
