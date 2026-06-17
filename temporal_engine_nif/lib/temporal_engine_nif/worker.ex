defmodule TemporalEngineNif.Worker do
  defstruct [:id, :core, :client, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Worker, for: TemporalEngineNif.Worker do
  require Logger

  import TemporalEngine.Data.ActivationCompletion
  import TemporalEngine.Data.Commands
  import TemporalEngine.Data.ActivityTaskCompletion

  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Data.ActivityTask
  alias TemporalEngineNif.Data.ActivityTaskCompletion
  alias TemporalEngineNif.Data.ActivityExecutionResult, as: ActivityResult
  alias TemporalEngineNif.Data.ActivityExecutionSuccess, as: ActivitySuccess
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.Priority
  alias TemporalEngineNif.Data.RetryPolicy
  alias TemporalEngineNif.Data.Timestamp
  alias TemporalEngineNif.Data.WorkflowActivation
  alias TemporalEngineNif.Data.WorkflowActivationCompletion
  alias TemporalEngineNif.Data.WorkflowActivationCompletionSuccessStatus, as: SuccessResult
  alias TemporalEngineNif.Data.WorkflowActivationCompletionFailureStatus, as: FailureResult
  alias TemporalEngineNif.Data.WorkflowCommand
  alias TemporalEngineNif.Data.WorkflowCommandScheduleActivity, as: ScheduleActivity
  alias TemporalEngineNif.Data.WorkflowCommandRequestCancelActivity, as: RequestCancelActivity
  alias TemporalEngineNif.Data.WorkflowCommandScheduleLocalActivity, as: ScheduleLocalActivity
  alias TemporalEngineNif.Data.WorkflowCommandRequestCancelLocalActivity, as: RequestCancelLocalActivity
  alias TemporalEngineNif.Data.WorkflowCommandStartTimer, as: StartTimer

  alias TemporalEngineNif.Data.WorkflowCommandCompleteWorkflowExecution,
    as: CompleteWorkflowExecution

  alias TemporalEngineNif.Data.WorkflowCommandFailWorkflowExecution, as: FailWorkflowExecution

  alias TemporalEngineNif.Data.WorkflowFailure

  @impl true
  def id(worker), do: worker.id

  @impl true
  def poll_workflow_activation(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activations_poll, worker.id})

        Logger.debug("Polling workflow activations...")

        Core._worker_poll_workflow_activation(worker.runtime.core, worker.core, self())
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
        {:ok, WorkflowActivation.to_record(task)}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def poll_activity_task(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activity_task_poll, worker.id})

        Logger.debug("Polling activity tasks...")

        Core._worker_poll_activity_task(worker.runtime.core, worker.core, self())
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
        {:ok, ActivityTask.to_record(task)}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def poll_nexus_task(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_nexus_task_poll, worker.id})

        Logger.debug("Polling nexus tasks...")

        Core._worker_poll_nexus_task(worker.runtime.core, worker.core, self())
        |> case do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling nexus tasks: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, task}} ->
        {:ok, task}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def complete_workflow_activation(worker, completion(run_id: run_id, status: result)) do
    parent = self()

    completion = %WorkflowActivationCompletion{
      run_id: run_id,
      status:
        case result do
          success(commands: cmds, used_internal_flags: flags, versioning_behavior: versioning) ->
            {:successful,
             %SuccessResult{
               commands:
                 Enum.map(cmds, fn
                   start_timer(seq: seq, start_to_fire_timeout: tm) ->
                     %WorkflowCommand{
                       variant:
                         {:start_timer,
                          %StartTimer{seq: seq, start_to_fire_timeout: Duration.from_record(tm)}}
                     }

                   schedule_activity() = cmd ->
                     %WorkflowCommand{
                       variant:
                         {:schedule_activity,
                          %ScheduleActivity{
                            seq: schedule_activity(cmd, :seq),
                            activity_id: schedule_activity(cmd, :activity_id),
                            activity_type: schedule_activity(cmd, :activity_type),
                            task_queue: schedule_activity(cmd, :task_queue),
                            headers:
                              Map.new(schedule_activity(cmd, :headers), fn {k, v} ->
                                {k, Payload.from_record(v)}
                              end),
                            arguments:
                              Enum.map(schedule_activity(cmd, :arguments), &Payload.from_record/1),
                            schedule_to_close_timeout:
                              Duration.from_record(
                                schedule_activity(cmd, :schedule_to_close_timeout)
                              ),
                            schedule_to_start_timeout:
                              Duration.from_record(
                                schedule_activity(cmd, :schedule_to_start_timeout)
                              ),
                            start_to_close_timeout:
                              Duration.from_record(
                                schedule_activity(cmd, :start_to_close_timeout)
                              ),
                            heartbeat_timeout:
                              Duration.from_record(schedule_activity(cmd, :heartbeat_timeout)),
                            retry_policy:
                              RetryPolicy.from_record(schedule_activity(cmd, :retry_policy)),
                            cancellation_type: schedule_activity(cmd, :cancellation_type),
                            do_not_eagerly_execute:
                              schedule_activity(cmd, :do_not_eagerly_execute),
                            versioning_intent: schedule_activity(cmd, :versioning_intent),
                            priority: Priority.from_record(schedule_activity(cmd, :priority))
                          }}
                     }

                   request_cancel_activity(seq: seq) ->
                     %WorkflowCommand{
                       variant: {:request_cancel_activity, %RequestCancelActivity{seq: seq}}
                     }

                   schedule_local_activity() = cmd ->
                     %WorkflowCommand{
                       variant:
                         {:schedule_local_activity,
                          %ScheduleLocalActivity{
                            seq: schedule_local_activity(cmd, :seq),
                            activity_id: schedule_local_activity(cmd, :activity_id),
                            activity_type: schedule_local_activity(cmd, :activity_type),
                            attempt: schedule_local_activity(cmd, :attempt),
                            original_schedule_time:
                              if(t = schedule_local_activity(cmd, :original_schedule_time),
                                do: Timestamp.from_record(t)
                              ),
                            headers:
                              Map.new(schedule_local_activity(cmd, :headers), fn {k, v} ->
                                {k, Payload.from_record(v)}
                              end),
                            arguments:
                              Enum.map(
                                schedule_local_activity(cmd, :arguments),
                                &Payload.from_record/1
                              ),
                            schedule_to_close_timeout:
                              Duration.from_record(
                                schedule_local_activity(cmd, :schedule_to_close_timeout)
                              ),
                            schedule_to_start_timeout:
                              Duration.from_record(
                                schedule_local_activity(cmd, :schedule_to_start_timeout)
                              ),
                            start_to_close_timeout:
                              Duration.from_record(
                                schedule_local_activity(cmd, :start_to_close_timeout)
                              ),
                            local_retry_threshold:
                              Duration.from_record(
                                schedule_local_activity(cmd, :local_retry_threshold)
                              ),
                            retry_policy:
                              RetryPolicy.from_record(schedule_local_activity(cmd, :retry_policy)),
                            cancellation_type: schedule_local_activity(cmd, :cancellation_type)
                          }}
                     }

                   request_cancel_local_activity(seq: seq) ->
                     %WorkflowCommand{
                       variant: {:request_cancel_local_activity, %RequestCancelLocalActivity{seq: seq}}
                     }

                   complete_workflow_execution(result: result) ->
                     %WorkflowCommand{
                       variant:
                         {:complete_workflow_execution,
                          %CompleteWorkflowExecution{result: Payload.from_record(result)}}
                     }

                   fail_workflow_execution(failure: failure) ->
                     %WorkflowCommand{
                       variant:
                         {:fail_workflow_execution,
                          %FailWorkflowExecution{failure: WorkflowFailure.from_record(failure)}}
                     }
                 end),
               used_internal_flags: flags,
               versioning_behavior: versioning
             }}

          failure(failure: failure, force_cause: cause) ->
            {:failed,
             %FailureResult{failure: WorkflowFailure.from_record(failure), force_cause: cause}}
        end
    }

    child =
      spawn_link(fn ->
        Core._worker_complete_workflow_activation(
          worker.runtime.core,
          worker.core,
          completion,
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

  @impl true
  def complete_activity_task(worker, task_completed(payload: payload, task_token: task_token)) do
    parent = self()

    completion = %ActivityTaskCompletion{
      task_token: :binary.bin_to_list(task_token),
      result: %ActivityResult{
        status: {:completed, %ActivitySuccess{result: Payload.from_record(payload)}}
      }
    }

    child =
      spawn_link(fn ->
        Core._worker_complete_activity_task(
          worker.runtime.core,
          worker.core,
          completion,
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

  @impl true
  def initiate_shutdown(worker) do
    with :ok <- Core._worker_initiate_shutdown(worker.core) do
      Logger.debug("Worker (#{worker.id}) shutdown initiated.")
      :ok
    else
      {:error, err} ->
        Logger.error("Worker (#{worker.id}) error initiating shutdown - #{inspect(err)}")
        {:error, err}
    end
  end

  @impl true
  def finalize_shutdown(worker) do
    with :ok <- Core._worker_finalize_shutdown(worker.core) do
      Logger.debug("Worker (#{worker.id}) shutdown finalized.")
      :ok
    else
      {:error, err} ->
        Logger.error("Worker (#{worker.id}) error finalizing shutdown - #{inspect(err)}")
        {:error, err}
    end
  end
end
