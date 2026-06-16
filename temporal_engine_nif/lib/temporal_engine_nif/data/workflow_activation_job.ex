defmodule TemporalEngineNif.Data.WorkflowActivationJob do
  defstruct variant: nil

  import TemporalEngine.Data.Jobs

  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.Priority
  alias TemporalEngineNif.Data.RetryPolicy
  alias TemporalEngineNif.Data.Timestamp
  alias TemporalEngineNif.Data.WorkflowActivationJobVariant
  alias TemporalEngineNif.Data.WorkflowNamespacedExecution
  alias TemporalEngineNif.Data.WorkflowExecution
  alias TemporalEngineNif.Data.WorkflowFailure
  alias TemporalEngineNif.Data.WorkflowMemo
  alias TemporalEngineNif.Data.WorkflowSearchAttributes

  @type t :: %__MODULE__{
          variant: WorkflowActivationJobVariant.t() | nil
        }

  def to_record(nil), do: nil

  def to_record(%__MODULE__{variant: {:initialize_workflow, job}}) do
    initialize_workflow(
      workflow_type: job.workflow_type,
      workflow_id: job.workflow_id,
      arguments: Enum.map(job.arguments, &Payload.to_record/1),
      randomness_seed: job.randomness_seed,
      headers: job.headers,
      identity: job.identity,
      parent_workflow_info: WorkflowNamespacedExecution.to_record(job.parent_workflow_info),
      workflow_execution_timeout: Duration.to_record(job.parent_workflow_info),
      workflow_run_timeout: Duration.to_record(job.workflow_run_timeout),
      workflow_task_timeout: Duration.to_record(job.workflow_task_timeout),
      continued_from_execution_run_id: job.continued_from_execution_run_id,
      continued_initiator: job.continued_initiator,
      continued_failure: WorkflowFailure.to_record(job.continued_failure),
      last_completion_result: Payload.to_record(job.last_completion_result),
      first_execution_run_id: job.first_execution_run_id,
      retry_policy: RetryPolicy.to_record(job.retry_policy),
      attempt: job.attempt,
      cron_schedule: job.cron_schedule,
      workflow_execution_expiration_time:
        Timestamp.to_record(job.workflow_execution_expiration_time),
      cron_schedule_to_schedule_interval:
        Duration.to_record(job.cron_schedule_to_schedule_interval),
      memo: WorkflowMemo.to_record(job.memo),
      search_attributes: WorkflowSearchAttributes.to_record(job.search_attributes),
      start_time: Timestamp.to_record(job.start_time),
      root_workflow: WorkflowExecution.to_record(job.root_workflow),
      priority: Priority.to_record(job.priority)
    )
  end

  def to_record(%__MODULE__{variant: {:resolve_activity, job}}) do
    resolve_activity(
      seq: job.seq,
      result:
        case job.result do
          nil ->
            nil

          %{status: {:completed, result}} ->
            activity_completed(result: Payload.to_record(result.result))

          %{status: {:failed, result}} ->
            activity_failed(failure: WorkflowFailure.to_record(result.failure))

          %{status: {:cancelled, result}} ->
            activity_cancelled(failure: WorkflowFailure.to_record(result.failure))

          %{status: {:backoff, result}} ->
            activity_backoff(
              attempt: result.attempt,
              backoff_duration: Duration.to_record(result.backoff_duration),
              original_schedule_time: Timestamp.to_record(result.original_schedule_time)
            )
        end,
      is_local: job.is_local
    )
  end

  def to_record(%__MODULE__{variant: {:query_workflow, job}}) do
    query_workflow(
      query_id: job.query_id,
      query_type: job.query_type,
      arguments: job.arguments |> Enum.map(&Payload.to_record/1),
      headers: job.headers |> Map.new(fn {k, v} -> {k, Payload.to_record(v)} end)
    )
  end

  def to_record(%__MODULE__{variant: {:fire_timer, job}}) do
    fire_timer(seq: job.seq)
  end

  def to_record(%__MODULE__{variant: {:remove_from_cache, job}}) do
    remove_from_cache(message: job.message, reason: job.reason)
  end
end
