defmodule Temporal.Workflow do
  alias Temporal.Activity
  alias Temporal.Activity.ActivityExecHandle
  alias Temporal.Comms.Shared.Duration
  alias Temporal.CoreSdk.Data.WorkflowStartOptions
  alias Temporal.Selectors.TimerHandle
  alias Temporal.TaskQueue
  alias Temporal.Workflow.WorkflowContext
  alias Temporal.Workflow.WorkflowFlowController
  alias Temporal.Workflow.WorkflowProgressReporter
  alias Temporal.Supervisor.WorkflowSupervisor

  @type workflow_exec_handle() :: WorkflowExecHandle.t()
  @type get_results_opts() :: [
          {:follow_runs, bool()},
          {:timeout, {pos_integer(), :second} | {pos_integer(), :ms}}
        ]
  @type activity_exec_opts ::
          [{:name, String.t()}] | WorkflowProgressReporter.schedule_activity_opts()

  @type exec_handle() :: WorkflowExecHandle.t() | ActivityExecHandle.t()

  defmacro __using__(opts) do
    activities = Keyword.get(opts, :activities)

    if activities do
      quote do
        def _temporal_activities, do: unquote(activities)
      end
    end
  end

  @spec result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, TemporalEngine.Data.Payload.t()} | {:error, term()}
  def result(handle, opts \\ []) do
    TemporalEngine.WorkflowHandle.get_result(handle, opts)
  end

  @spec new_timer(WorkflowContext.t(), Duration.duration()) ::
          {:ok, TimerHandle.t()} | {:error, term()}
  def new_timer(%WorkflowContext{} = ctx, duration) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(ctx.run_id) do
      reported = WorkflowProgressReporter.start_timer(reporter, duration)

      with {:ok, timer_id} <- reported do
        {:ok,
         %TimerHandle{
           timer_id: timer_id,
           run_id: ctx.run_id,
           workflow_id: ctx.workflow_id
         }}
      end
    end
  end

  @spec execute_activity(WorkflowContext.t(), term(), [term()], activity_exec_opts()) ::
          {:ok, ActivityExecHandle.t()} | {:error, term()}
  def execute_activity(%WorkflowContext{} = ctx, activity_type, args \\ [], opts \\ []) do
    args =
      if is_list(args) do
        args
      else
        [args]
      end

    activity_valid =
      cond do
        is_binary(activity_type) ->
          :ok

        is_function(activity_type) ->
          {:name, function_name} = Function.info(activity_type, :name)
          {:arity, arity} = Function.info(activity_type, :arity)

          if arity == Enum.count(args) + 1 do
            :ok
          else
            {:error, "Wrong number of arguments passed to activity (#{function_name}/#{arity})"}
          end

        is_atom(activity_type) ->
          :ok
      end

    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(ctx.run_id),
         :ok <- activity_valid do
      activity_type =
        Keyword.get_lazy(opts, :name, fn ->
          Activity.name_for_type(activity_type)
        end)

      with {:ok, activity_id} <-
             WorkflowProgressReporter.schedule_activity(
               reporter,
               activity_type,
               args,
               Map.new(opts)
             ) do
        {:ok,
         %ActivityExecHandle{
           activity_id: activity_id,
           activity_type: activity_type,
           run_id: ctx.run_id,
           workflow_id: ctx.workflow_id
         }}
      end
    end
  end

  @spec start(
          TaskQueue.t(),
          workflow_id :: String.t(),
          workflow_name :: WorkflowName.t(),
          inputs :: [term()],
          opts :: WorkflowStartOptions.opts()
        ) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def start(queue, workflow_id, workflow_name, inputs, opts \\ []) do
    TaskQueue.start_workflow(queue, workflow_id, workflow_name, inputs, opts)
  end

  @spec get(WorkflowContext.t(), exec_handle()) :: {:ok, term()} | {:error, term()}
  def get(%WorkflowContext{} = ctx, %ActivityExecHandle{} = activity) do
    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(ctx.run_id) do
      WorkflowFlowController.await_activity_result(
        flow_control,
        activity.run_id,
        activity.activity_id
      )
    end
  end

  def get(%WorkflowContext{} = ctx, %TimerHandle{} = timer) do
    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(ctx.run_id) do
      WorkflowFlowController.await_timer(
        flow_control,
        timer.run_id,
        timer.timer_id
      )
    end
  end
end
