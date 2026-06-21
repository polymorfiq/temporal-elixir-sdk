defmodule Temporal.Activity.ActivityExecution do
  use GenStage

  require TemporalEngine.Data.Failure
  import TemporalEngine.Data.ActivityTask
  import Temporal.Activity.ActivityContext
  import TemporalEngine.Data.Common, only: [workflow_execution: 2]
  import TemporalEngine.Data.ActivityTaskCompletion

  alias TemporalEngine.Data.ActivityTask
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  require Logger
  require Record

  Record.defrecordp(:activity_state, [
    :activity_type,
    :run_id,
    :activity_id,
    :arguments,
    :module,
    :exec_fn,
    exec_ref: nil,
    exec_pid: nil,
    demand: 0
  ])

  @typep activity_state ::
           record(:activity_state,
             activity_type: String.t(),
             run_id: String.t(),
             activity_id: String.t(),
             arguments: [term()],
             module: module(),
             exec_fn: atom(),
             exec_ref: reference() | nil,
             exec_pid: pid() | nil,
             demand: integer()
           )

  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @spec init({module :: module(), exec_fn :: atom(), ActivityTask.start_activity()}) ::
          {:producer, activity_state()}
  def init({module, exec_fn, start}) do
    workflow_exec = start_activity(start, :workflow_execution)
    run_id = workflow_execution(workflow_exec, :run_id)
    activity_type = start_activity(start, :activity_type)
    activity_id = start_activity(start, :activity_id)
    Process.set_label({:activity, run_id, activity_type, activity_id})

    arguments = start_activity(start, :input) |> Enum.map(&Payload.value_from_record/1)

    {:producer,
     activity_state(
       activity_type: activity_type,
       run_id: run_id,
       activity_id: activity_id,
       arguments: arguments,
       module: module,
       exec_fn: exec_fn
     )}
  end

  @doc false
  @spec handle_demand(integer(), activity_state()) :: {:noreply, list(), activity_state()}
  def handle_demand(demand, state) when demand > 0 do
    existing_demand = activity_state(state, :demand)
    GenStage.async_info(self(), :execute_if_not_already)

    {:noreply, [], activity_state(state, demand: existing_demand + demand)}
  end

  @doc false
  @spec handle_info(term(), activity_state()) :: {:noreply, list(), activity_state()}
  def handle_info(:execute_if_not_already, activity_state(exec_ref: ref) = state)
      when is_reference(ref) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, activity_state(demand: 0) = state) do
    {:noreply, [], state}
  end

  def handle_info(:execute_if_not_already, state) do
    module = activity_state(state, :module)
    exec_fn = activity_state(state, :exec_fn)
    arguments = activity_state(state, :arguments)

    ctx =
      activity_context(
        execution: self(),
        run_id: activity_state(state, :run_id),
        activity_type: activity_state(state, :activity_type),
        activity_id: activity_state(state, :activity_id)
      )

    parent = self()

    {exec_pid, exec_ref} =
      spawn_monitor(fn ->
        resp = apply(module, exec_fn, [ctx | arguments])
        GenStage.cast(parent, {:activity_completed, resp})
      end)

    {:noreply, [], activity_state(state, exec_pid: exec_pid, exec_ref: exec_ref)}
  end

  def handle_info(
        {:DOWN, exec_ref, :process, _, :normal},
        activity_state(exec_ref: exec_ref) = state
      ) do
    type = activity_state(state, :activity_type)
    activity_id = activity_state(state, :activity_id)
    run_id = activity_state(state, :run_id)

    Logger.debug(
      "Activity execution halted: (#{inspect(type)}, Run: #{inspect(run_id)}, ID: #{inspect(activity_id)})"
    )

    {:noreply, [], activity_state(state, exec_pid: nil, exec_ref: nil)}
  end

  def handle_info(
        {:DOWN, exec_ref, :process, _, {%error_type{} = err, stacktrace}},
        activity_state(exec_ref: exec_ref) = state
      ) do
    failure =
      Failure.failure(
        message: Exception.message(err),
        source: "elixir-sdk",
        stack_trace: "#{Exception.format_stacktrace(stacktrace)}",
        failure_info: Failure.application(failure_type: "#{error_type}")
      )

    status = activity_execution_result(status: activity_failed(failure: failure))
    {:noreply, [status], activity_state(state, exec_pid: nil, exec_ref: nil)}
  end

  def handle_cast({:activity_completed, resp}, state) do
    with {:ok, result} <- resp do
      status =
        activity_execution_result(
          status: activity_completed(result: Payload.record_from_value(result))
        )

      {:noreply, [status], state}
    else
      {:error, err} ->
        failure =
          Failure.failure(
            message: "{:error, #{inspect(err)}}",
            source: "elixir-sdk",
            stack_trace: "",
            failure_info:
              Failure.application(
                failure_type: "ReturnedError",
                details: Payload.record_from_value(err)
              )
          )

        status = activity_execution_result(status: activity_failed(failure: failure))
        {:noreply, [status], state}
    end
  end
end
