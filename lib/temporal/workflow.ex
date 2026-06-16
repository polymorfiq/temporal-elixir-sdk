defmodule Temporal.Workflow do
  require TemporalEngine.Data.Failure

  import TemporalEngine.WorkflowHandle

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
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  defmodule ResultError do
    defstruct [:error_code, message: nil, failure: nil, details: nil]

    @type t :: %__MODULE__{
            error_code:
              :workflow_failed
              | :workflow_cancelled
              | :workflow_terminated
              | :workflow_timed_out
              | :workflow_continued_as_new
              | :workflow_not_found
              | :workflow_payload_conversion_error
              | :workflow_rpc_error
              | :other,
            message: String.t() | nil,
            details: [term()] | nil,
            failure: map() | nil
          }
  end

  @type workflow_exec_handle() :: WorkflowExecHandle.t()
  @type get_results_opts() :: [
          {:follow_runs, bool()},
          {:timeout, Duration.duration()}
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

  @returned_error_type "_Temporal::ReturnedError"
  def returned_error_type, do: @returned_error_type

  @spec result(workflow_exec_handle(), get_results_opts()) ::
          {:ok, TemporalEngine.Data.Payload.t()} | {:error, ResultError.t() | term()}
  def result(handle, opts \\ []) do
    opts =
      get_result_opts(
        follow_runs: opts[:follow_runs] || true,
        timeout: if(tm = opts[:timeout], do: Duration.from_tuple(tm))
      )

    with {:ok, result} <- TemporalEngine.WorkflowHandle.get_result(handle, opts) do
      {:ok, if(result, do: Payload.value_from_record(result))}
    else
      {:error,
       Failure.workflow_failed(
         failure:
           Failure.failure(
             failure_info:
               Failure.application(failure_type: @returned_error_type, details: details)
           )
       )} ->
        {:error, Enum.map(details, &Payload.value_from_record/1) |> List.first()}

      {:error, Failure.workflow_failed(failure: f)} ->
        {:error, %{error_code: :workflow_failed, failure: failure_to_map(f)}}

      {:error, Failure.workflow_cancelled(details: details)} ->
        {:error,
         %{
           error_code: :workflow_cancelled,
           details: Enum.map(details || [], &Payload.value_from_record/1)
         }}

      {:error, Failure.workflow_terminated(details: details)} ->
        {:error,
         %{
           error_code: :workflow_terminated,
           details: Enum.map(details || [], &Payload.value_from_record/1)
         }}

      {:error, Failure.workflow_timed_out()} ->
        {:error, %ResultError{error_code: :workflow_timed_out}}

      {:error, Failure.workflow_continued_as_new()} ->
        {:error, %ResultError{error_code: :workflow_continued_as_new}}

      {:error, Failure.workflow_not_found()} ->
        {:error, %ResultError{error_code: :workflow_not_found}}

      {:error, Failure.workflow_payload_conversion(message: message)} ->
        {:error, %ResultError{error_code: :workflow_payload_conversion_error, message: message}}

      {:error, Failure.workflow_rpc_error(message: message)} ->
        {:error, %ResultError{error_code: :workflow_rpc_error, message: message}}

      {:error, Failure.workflow_other_error(message: message)} ->
        {:error, %ResultError{error_code: :unknown, message: message}}

      {:error, err} ->
        {:error, err}
    end
  end

  defp failure_to_map(nil), do: nil

  defp failure_to_map(f) do
    %{
      type: failure_info_to_map(Failure.failure(f, :failure_info))[:failure],
      message: Failure.failure(f, :message),
      source: Failure.failure(f, :source),
      stack_trace: Failure.failure(f, :stack_trace),
      encoded_attributes:
        (Failure.failure(f, :encoded_attributes) || []) |> Enum.map(&Payload.value_from_record/1),
      cause: Failure.failure(f, :cause) |> failure_to_map(),
      info: Failure.failure(f, :failure_info) |> failure_info_to_map()
    }
  end

  defp failure_info_to_map(nil), do: nil

  defp failure_info_to_map(Failure.application() = info) do
    %{
      failure: :application,
      type: Failure.application(info, :failure_type),
      non_retryable: Failure.application(info, :non_retryable),
      details: Failure.application(info, :details) |> Enum.map(&Payload.value_from_record/1),
      next_retry_delay:
        if(d = Failure.application(info, :next_retry_delay), do: Duration.to_tuple(d)),
      category: Failure.application(info, :category)
    }
  end

  defp failure_info_to_map(Failure.timeout_reached() = info) do
    %{
      failure: :timeout_reached,
      timeout_type: Failure.timeout_reached(info, :timeout_type),
      last_heartbeat_details: Failure.timeout_reached(info, :last_heartbeat_details)
    }
  end

  defp failure_info_to_map(Failure.cancelled() = info) do
    %{
      failure: :cancelled,
      identity: Failure.cancelled(info, :identity),
      details: if(p = Failure.cancelled(info, :details), do: Payload.value_from_record(p))
    }
  end

  defp failure_info_to_map(Failure.terminated() = info) do
    %{
      failure: :terminated,
      identity: Failure.terminated(info, :identity)
    }
  end

  defp failure_info_to_map(Failure.server() = info) do
    %{
      failure: :server,
      non_retryable: Failure.server(info, :non_retryable)
    }
  end

  defp failure_info_to_map(Failure.reset_workflow() = info) do
    %{
      failure: :reset_workflow,
      last_heartbeat_details:
        if(p = Failure.reset_workflow(info, :last_heartbeat_details),
          do: Payload.value_from_record(p)
        )
    }
  end

  defp failure_info_to_map(Failure.activity() = info) do
    %{
      failure: :activity,
      scheduled_event_id: Failure.activity(info, :scheduled_event_id),
      started_event_id: Failure.activity(info, :started_event_id),
      identity: Failure.activity(info, :identity),
      activity_type:
        if(at = Failure.activity(info, :activity_type), do: Failure.activity_type(at, :name)),
      activity_id: Failure.activity(info, :activity_type),
      retry_state: Failure.activity(info, :retry_state)
    }
  end

  defp failure_info_to_map(Failure.child_execution() = info) do
    %{
      failure: :child_execution,
      namespace: Failure.child_execution(info, :namespace),
      workflow_execution:
        if(r = Failure.child_execution(info, :workflow_execution),
          do: %{workflow_id: Failure.run(r, :workflow_id), run_id: Failure.run(r, :run_id)}
        ),
      workflow_type:
        if(wt = Failure.child_execution(info, :workflow_type),
          do: Failure.workflow_type(wt, :name)
        ),
      initiated_event_id: Failure.child_execution(info, :initiated_event_id),
      started_event_id: Failure.child_execution(info, :started_event_id),
      retry_state: Failure.child_execution(info, :retry_state)
    }
  end

  defp failure_info_to_map(Failure.nexus_operation() = info) do
    %{
      failure: :nexus_operation,
      scheduled_event_id: Failure.nexus_operation(info, :scheduled_event_id),
      endpoint: Failure.nexus_operation(info, :endpoint),
      service: Failure.nexus_operation(info, :service),
      operation: Failure.nexus_operation(info, :operation),
      operation_id: Failure.nexus_operation(info, :operation_id),
      operation_token: Failure.nexus_operation(info, :operation_token)
    }
  end

  defp failure_info_to_map(Failure.nexus_handler() = info) do
    %{
      failure: :nexus_handler,
      failure_type: Failure.nexus_handler(info, :failure_type),
      retry_behavior: Failure.nexus_handler(info, :retry_behavior)
    }
  end

  @spec new_timer(WorkflowContext.t(), Duration.duration()) ::
          {:ok, TimerHandle.t()} | {:error, term()}
  def new_timer(%WorkflowContext{} = ctx, duration) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(ctx.run_id) do
      reported = WorkflowProgressReporter.request_start_timer(reporter, duration)

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

  @spec execute_local_activity(WorkflowContext.t(), term(), [term()], activity_exec_opts()) ::
          {:ok, ActivityExecHandle.t()} | {:error, term()}
  def execute_local_activity(%WorkflowContext{} = ctx, activity_type, args \\ [], opts \\ []) do
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
             WorkflowProgressReporter.schedule_local_activity(
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
           workflow_id: ctx.workflow_id,
           is_local: true
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
