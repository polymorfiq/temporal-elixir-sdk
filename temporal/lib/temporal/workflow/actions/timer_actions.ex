defmodule Temporal.Workflow.TimerActions do
  require Record
  import Temporal.Workflow.WorkflowContext
  import TemporalEngine.Data.Commands

  alias Temporal.Workflow.WorkflowExecution
  alias Temporal.Workflow.WorkflowContext
  alias TemporalEngine.Data.Duration

  Record.defrecord(:timer_handle, [:seq, :execution])
  @opaque timer_handle :: record(:timer_handle, seq: pos_integer())

  @spec new_timer(WorkflowContext.workflow_context(), Duration.duration()) ::
          {:ok, timer_handle()} | {:error, term()}
  def new_timer(ctx, duration) do
    workflow_context(execution: exec) = ctx

    duration = Duration.from_tuple(duration)

    with {:ok, cmd} <-
           WorkflowExecution.queue_command(exec, start_timer(start_to_fire_timeout: duration)) do
      {:ok, timer_handle(seq: start_timer(cmd, :seq), execution: exec)}
    end
  end

  @spec get(timer_handle()) :: :ok | {:error, term()}
  def get(timer_handle(seq: seq, execution: exec)),
    do: WorkflowExecution.wait_for_timer(exec, seq)

  @spec sleep(WorkflowContext.workflow_context(), Duration.duration()) :: :ok | {:error, term()}
  def sleep(ctx, duration) do
    with {:ok, timer} <- new_timer(ctx, duration) do
      get(timer)
    end
  end
end
