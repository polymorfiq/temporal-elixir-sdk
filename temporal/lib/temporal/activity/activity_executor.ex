defmodule Temporal.Activity.ActivityExecutor do
  use GenServer

  require Logger
  require Record
  alias Temporal.Activity.ActivityProgressReporter
  alias Temporal.Activity.ActivityContext
  alias Temporal.Supervisor.ActivitySupervisor

  Record.defrecordp(:activity_state, [
    :run_id,
    :activity_id,
    :activity_type,
    :activity_fn,
    :activity_inputs,
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
    Process.set_label({:activity_executor, exec_ctx.activity_id})
    Process.flag(:trap_exit, true)

    {:ok,
     activity_state(
       run_id: exec_ctx.run_id,
       activity_id: exec_ctx.activity_id,
       activity_type: exec_ctx.activity_type,
       activity_fn: exec_ctx.activity_fn,
       activity_inputs: exec_ctx.activity_inputs,
       exec_ctx: exec_ctx
     ), {:continue, :execute}}
  end

  def handle_continue(:execute, state) do
    Logger.debug(
      "Activity started (Type: #{activity_state(state, :activity_type)}, ID: #{activity_state(state, :activity_id)})"
    )

    activity_fn = activity_state(state, :activity_fn)
    ctx = ActivityContext.new(activity_state(state, :exec_ctx))
    inputs = activity_state(state, :activity_inputs)

    resp = apply(activity_fn, [ctx | inputs])

    {:noreply, state, {:continue, {:complete, resp}}}
  end

  def handle_continue({:complete, output}, state) do
    activity_type = activity_state(state, :activity_type)
    activity_id = activity_state(state, :activity_id)
    run_id = activity_state(state, :run_id)

    with {:ok, reporter} <- ActivitySupervisor.progress_reporter_pid(run_id, activity_id) do
      resp = case output do
        :ok -> ActivityProgressReporter.report_success(reporter, nil)

         {:ok, result} -> ActivityProgressReporter.report_success(reporter, result)

         {:error, err} -> ActivityProgressReporter.report_failure(reporter, err)
      end

      case resp do
        :ok ->
          Logger.debug(
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
