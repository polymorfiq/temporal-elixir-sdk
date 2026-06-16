defmodule TemporalEngine.Data.Failure do
  require Record

  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload

  Record.defrecord(:failure, [
    :message,
    source: "elixir-sdk",
    stack_trace: "",
    encoded_attributes: nil,
    cause: nil,
    failure_info: nil
  ])

  @type failure ::
          record(:failure,
            message: String.t(),
            source: String.t(),
            stack_trace: String.t(),
            encoded_attributes: Payload.payload() | nil,
            cause: failure() | nil,
            failure_info: info() | nil
          )

  @type info ::
          application()
          | timeout_reached()
          | cancelled()
          | terminated()
          | server()
          | reset_workflow()
          | activity()
          | child_execution()
          | nexus_operation()
          | nexus_handler()

  Record.defrecord(:application, [
    :failure_type,
    non_retryable: false,
    category: :unspecified,
    details: [],
    next_retry_delay: nil
  ])

  @type application ::
          record(:application,
            failure_type: String.t(),
            non_retryable: bool(),
            details: [Payload.payload()],
            next_retry_delay: Duration.duration() | nil,
            category: category()
          )

  @type category :: :unspecified | :benign

  Record.defrecord(:timeout_reached,
    timeout_type: :unspecified,
    last_heartbeat_details: nil
  )

  @type timeout_reached ::
          record(:timeout_reached,
            timeout_type: timeout_type(),
            last_heartbeat_details: Payload.payload() | nil
          )
  @type timeout_type ::
          :unspecified | :start_to_close | :schedule_to_start | :schedule_to_close | :heartbeat

  Record.defrecord(:cancelled, [:identity, details: nil])

  @type cancelled ::
          record(:cancelled,
            identity: String.t(),
            details: Payload.payload() | nil
          )

  Record.defrecord(:terminated, [:identity])
  @type terminated :: record(:terminated, identity: String.t())

  Record.defrecord(:server, [:non_retryable])
  @type server :: record(:server, non_retryable: bool())

  Record.defrecord(:reset_workflow, last_heartbeat_details: nil)
  @type reset_workflow :: record(:reset_workflow, last_heartbeat_details: Payload.payload() | nil)

  Record.defrecord(:activity, [
    :scheduled_event_id,
    :started_event_id,
    :identity,
    :activity_id,
    retry_state: :unspecified,
    activity_type: nil
  ])

  @type activity ::
          record(:activity,
            scheduled_event_id: integer(),
            started_event_id: integer(),
            identity: String.t(),
            activity_type: activity_type() | nil,
            activity_id: String.t(),
            retry_state: retry_state()
          )

  @type retry_state ::
          :unspecified
          | :in_progress
          | :non_retryable_failure
          | :timeout
          | :maximum_attempts_reached
          | :retry_policy_not_set
          | :internal_server_error
          | :cancel_requested

  Record.defrecord(:activity_type, [:name])
  @type activity_type :: record(:activity_type, name: String.t())

  Record.defrecord(:child_execution, [
    :namespace,
    :initiated_event_id,
    :started_event_id,
    :retry_state,
    workflow_execution: nil,
    workflow_type: nil
  ])

  @type child_execution ::
          record(:child_execution,
            namespace: String.t(),
            workflow_execution: run() | nil,
            workflow_type: workflow_type() | nil,
            initiated_event_id: integer(),
            started_event_id: integer(),
            retry_state: retry_state()
          )

  Record.defrecord(:run, [:workflow_id, :run_id])
  @type run :: record(:run, workflow_id: String.t(), run_id: String.t())

  Record.defrecord(:workflow_type, [:name])
  @type workflow_type :: record(:workflow_type, name: String.t())

  Record.defrecord(:nexus_operation, [
    :scheduled_event_id,
    :endpoint,
    :service,
    :operation,
    :operation_id,
    :operation_token
  ])

  @type nexus_operation ::
          record(:nexus_operation,
            scheduled_event_id: integer(),
            endpoint: String.t(),
            service: String.t(),
            operation: String.t(),
            operation_id: String.t(),
            operation_token: String.t()
          )

  Record.defrecord(:nexus_handler, [:failure_type, retry_behavior: :unspecified])

  @type nexus_handler ::
          record(:nexus_handler, failure_type: String.t(), retry_behavior: retry_behavior())
  @type retry_behavior :: :unspecified | :retryable | :non_retryable

  Record.defrecord(:workflow_failed, [:failure])
  @type workflow_failed :: record(:workflow_failed, failure: failure())

  Record.defrecord(:workflow_cancelled, [:details])
  @type workflow_cancelled :: record(:workflow_cancelled, details: [Payload.payload()])

  Record.defrecord(:workflow_terminated, [:details])
  @type workflow_terminated :: record(:workflow_terminated, details: [Payload.payload()])

  Record.defrecord(:workflow_timed_out, [])
  @type workflow_timed_out :: record(:workflow_timed_out)

  Record.defrecord(:workflow_continued_as_new, [])
  @type workflow_continued_as_new :: record(:workflow_continued_as_new)

  Record.defrecord(:workflow_not_found, [])
  @type workflow_not_found :: record(:workflow_not_found)

  Record.defrecord(:workflow_payload_conversion, [:message])
  @type workflow_payload_conversion :: record(:workflow_payload_conversion, message: String.t())

  Record.defrecord(:workflow_rpc_error, [:message])
  @type workflow_rpc_error :: record(:workflow_rpc_error, message: String.t())

  Record.defrecord(:workflow_other_error, [:message])
  @type workflow_other_error :: record(:workflow_other_error, message: String.t())
end
