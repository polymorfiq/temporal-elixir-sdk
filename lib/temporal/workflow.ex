defmodule Temporal.Workflow do
  alias Temporal.Activity
  alias Temporal.Activity.ActivityExecHandle
  alias Temporal.Client
  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.WorkflowGetResultOptions
  alias Temporal.CoreSdk.Data.WorkflowStartOptions
  alias Temporal.CoreSdk.Data.ClientPayload
  alias Temporal.TaskQueue
  alias Temporal.Workflows.WorkflowExecHandle
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

  @watch_result_msg :workflow_result

  defmacro __using__(opts) do
    activities = Keyword.get(opts, :activities)

    if activities do
      quote do
        def _temporal_activities, do: unquote(activities)
      end
    end
  end

  @spec result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, ClientPayload.t()} | {:error, term()}
  def result(%WorkflowExecHandle{} = handle, opts \\ []) do
    with {:ok, opts} <- Keyword.validate(opts, [:follow_runs, :timeout]),
         {:ok, runtime} <- Client.core_runtime(handle.client),
         {:ok, client} <- Client.core_for_identity(handle.client.identity) do
      get_result_opts = %WorkflowGetResultOptions{
        follow_runs: Keyword.get(opts, :follow_runs, true)
      }

      parent = self()

      {pid, ref} =
        spawn_monitor(fn ->
          CoreSdk._workflow_handle_get_result(
            runtime.core,
            client.core,
            handle.handle,
            get_result_opts,
            self()
          )
          |> case do
            :ok -> :ok
            {:error, err} -> raise "Could not get workflow result from Core SDK: #{inspect(err)}"
          end

          receive do
            {:ok, result} ->
              send(parent, {self(), {:ok, result}})

            {:error, err} ->
              send(parent, {self(), {:error, err}})
          end
        end)

      timeout = Keyword.get(opts, :timeout, :infinity)

      receive do
        {^pid, {:ok, result}} ->
          {:ok, ClientPayload.to_val!(result)}

        {:DOWN, ^ref, :process, ^pid, %RuntimeError{} = rt_err} ->
          {:error, rt_err}
      after
        timeout ->
          {:error, :timeout}
      end
    end
  end

  @spec watch_result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, ClientPayload.t()} | {:error, term()}
  def watch_result(%WorkflowExecHandle{} = handle, opts \\ []) do
    parent = self()

    spawn_link(fn ->
      send(parent, {@watch_result_msg, handle, result(handle, opts)})
    end)
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
          {:ok, "#{activity_type}"}
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
               opts
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

  @spec get(exec_handle()) :: {:ok, term()} | {:error, term()}
  def get(%WorkflowExecHandle{} = handle) do
    result(handle)
  end

  def get(%ActivityExecHandle{} = activity) do
    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(activity.run_id) do
      WorkflowFlowController.await_activity_result(flow_control, activity.activity_id)
    end
  end

  @spec get(WorkflowContext.t(), exec_handle()) :: {:ok, term()} | {:error, term()}
  def get(%WorkflowContext{} = _ctx, %WorkflowExecHandle{} = handle),
    do: handle |> IO.inspect(label: "HMMM2?")

  def get(%WorkflowContext{} = ctx, %ActivityExecHandle{} = activity) do
    with {:ok, flow_control} <- WorkflowSupervisor.flow_control_pid(ctx.run_id) do
      WorkflowFlowController.await_activity_result(flow_control, activity.activity_id)
    end
  end
end
