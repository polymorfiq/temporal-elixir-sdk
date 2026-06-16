defmodule TemporalEngine.Data.Jobs do
  require Record

  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy
  alias TemporalEngine.Data.Timestamp

  @type job :: initialize_workflow() | fire_timer() | resolve_activity() | remove_from_cache()

  Record.defrecord(:initialize_workflow, [
    :workflow_type,
    :workflow_id,
    :arguments,
    :randomness_seed,
    :headers,
    :identity,
    :continued_from_execution_run_id,
    :continued_initiator,
    :first_execution_run_id,
    :attempt,
    :cron_schedule,
    parent_workflow_info: nil,
    workflow_execution_timeout: nil,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    continued_failure: nil,
    last_completion_result: nil,
    retry_policy: nil,
    workflow_execution_expiration_time: nil,
    cron_schedule_to_schedule_interval: nil,
    memo: nil,
    search_attributes: nil,
    start_time: nil,
    root_workflow: nil,
    priority: nil
  ])

  @initialize_workflow_fields @__records__[:initialize_workflow]
  def initialize_workflow_fields, do: @initialize_workflow_fields

  @type initialize_workflow ::
          record(:initialize_workflow,
            workflow_type: String.t(),
            workflow_id: String.t(),
            arguments: Payload.payload(),
            randomness_seed: pos_integer(),
            headers: %{String.t() => Payload.payload()},
            identity: String.t(),
            parent_workflow_info: namespaced_run() | nil,
            workflow_execution_timeout: Duration.duration() | nil,
            workflow_run_timeout: Duration.duration() | nil,
            workflow_task_timeout: Duration.duration() | nil,
            continued_from_execution_run_id: String.t(),
            continued_initiator: integer(),
            continued_failure: Failure.failure() | nil,
            last_completion_result: Payload.payload() | nil,
            first_execution_run_id: String.t(),
            retry_policy: RetryPolicy.policy() | nil,
            attempt: integer(),
            cron_schedule: String.t(),
            workflow_execution_expiration_time: Timestamp.timestamp() | nil,
            cron_schedule_to_schedule_interval: Duration.duration() | nil,
            memo: memo() | nil,
            search_attributes: search_attribs() | nil,
            start_time: Timestamp.timestamp() | nil,
            root_workflow: run() | nil,
            priority: Priority.priority() | nil
          )

  Record.defrecord(:run, [:workflow_id, :run_id])
  @type run :: record(:run, workflow_id: String.t(), run_id: String.t())

  Record.defrecord(:namespaced_run, [:namespace, :workflow_id, :run_id])

  @type namespaced_run ::
          record(:namespaced_run,
            namespace: String.t(),
            workflow_id: String.t(),
            run_id: String.t()
          )

  Record.defrecord(:memo, [:fields])
  @type memo :: record(:memo, fields: %{String.t() => Payload.payload()})

  Record.defrecord(:search_attribs, [:indexed_fields])

  @type search_attribs ::
          record(:search_attribs, indexed_fields: %{String.t() => Payload.payload()})

  Record.defrecord(:fire_timer, [:seq])
  @type fire_timer :: record(:fire_timer, seq: pos_integer())

  Record.defrecord(:query_workflow, [:query_id, :query_type, arguments: [], headers: %{}])

  @type query_workflow ::
          record(:query_workflow,
            query_id: String.t(),
            query_type: String.t(),
            arguments: [Payload.payload()],
            headers: %{String.t() => Payload.payload()}
          )

  Record.defrecord(:resolve_activity, [:seq, :is_local, result: nil])

  @type resolve_activity ::
          record(:resolve_activity,
            seq: pos_integer(),
            result: activity_status(),
            is_local: bool()
          )
  @type activity_status ::
          activity_completed() | activity_failed() | activity_cancelled() | activity_backoff()

  Record.defrecord(:activity_completed, [:result])
  @type activity_completed :: record(:activity_completed, result: Payload.payload())

  Record.defrecord(:activity_failed, [:failure])
  @type activity_failed :: record(:activity_failed, failure: Failure.failure())

  Record.defrecord(:activity_cancelled, [:failure])
  @type activity_cancelled :: record(:activity_cancelled, failure: Failure.failure())

  Record.defrecord(:activity_backoff, [
    :attempt,
    backoff_duration: nil,
    original_schedule_time: nil
  ])

  @type activity_backoff ::
          record(:activity_backoff,
            attempt: pos_integer(),
            backoff_duration: Duration.duration() | nil,
            original_schedule_time: Timestamp.timestamp() | nil
          )

  Record.defrecord(:remove_from_cache, [:message, :reason])

  @type remove_from_cache ::
          record(:remove_from_cache, message: String.t(), reason: cache_eviction_reason())

  @type cache_eviction_reason ::
          :unspecified
          | :cache_full
          | :cache_miss
          | :non_determinism
          | :lang_fail
          | :lang_requested
          | :task_not_found
          | :unhandled_command
          | :fatal
          | :pagination_or_history_fetch
          | :workflow_execution_ending
end
