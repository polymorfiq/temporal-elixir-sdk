defmodule Temporal.Activity.ActivityComms do
  use GenStage

  require Logger
  require Record

  import TemporalEngine.Data.ActivityTask
  import TemporalEngine.Data.Common, only: [workflow_execution: 2]
  import TemporalEngine.Data.ActivityTaskCompletion

  alias Temporal.Activity.ActivityExecution
  alias TemporalEngine.Data.ActivityTask
  alias TemporalEngine.Data.ActivityTaskCompletion
  alias TemporalEngine.Worker

  Record.defrecordp(:comms_state, [
    :run_id,
    :activity_type,
    :activity_id,
    :state,
    :task_token,
    :worker,
    :exec
  ])

  @typep comms_state ::
           record(:comms_state,
             run_id: String.t(),
             activity_type: String.t(),
             activity_id: String.t(),
             state: :started,
             task_token: String.t(),
             worker: Worker.t(),
             exec: pid()
           )

  @doc false
  def start_link(init_args), do: GenStage.start_link(__MODULE__, init_args)

  @doc false
  @spec init(
          {Worker.t(), ActivityTask.start_activity(), exec_args :: term(),
           task_token :: String.t()}
        ) :: {:consumer, comms_state(), keyword()}
  def init({worker, start, exec_args, task_token}) do
    activity_type = start_activity(start, :activity_type)
    activity_id = start_activity(start, :activity_id)
    workflow_exec = start_activity(start, :workflow_execution)
    run_id = workflow_execution(workflow_exec, :run_id)
    Process.set_label({:activity_comms, run_id, activity_type, activity_id})

    {:ok, exec} = ActivityExecution.start_link(exec_args)

    {:consumer,
     comms_state(
       run_id: run_id,
       activity_type: activity_type,
       activity_id: activity_id,
       worker: worker,
       state: :started,
       exec: exec,
       task_token: task_token
     ), subscribe_to: [exec]}
  end

  @spec handle_events(
          [ActivityTaskCompletion.activity_execution_result()],
          {pid(), reference()},
          comms_state()
        ) ::
          {:noreply, [], comms_state()} | {:stop, term(), comms_state()}
  def handle_events([result], _, state) do
    worker = comms_state(state, :worker)
    task_token = comms_state(state, :task_token)

    :ok =
      Worker.complete_activity_task(
        worker,
        task_completion(task_token: task_token, result: result)
      )

    {:stop, :normal, state}
  end
end
