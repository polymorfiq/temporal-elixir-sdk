defmodule TemporalEngine.Data.NexusTask do
  require Record

  alias TemporalEngine.Data.Timestamp

  @type nexus_task :: start_task() | cancel_task()

  Record.defrecord(:start_task, [
    :endpoint,
    :poller_group_id,
    :poller_group_infos,
    request_deadline: nil,
    request: nil,
    poller_scaling_decision: nil,
    task_token: nil
  ])

  @type start_task ::
          record(:start_task,
            endpoint: String.t(),
            request_deadline: Timestamp.timestamp() | nil,
            task_token: binary(),
            request: request() | nil,
            poller_scaling_decision: decision(),
            poller_group_id: String.t(),
            poller_group_infos: [group_info()]
          )

  @type request :: start_operation() | cancel_operation()

  Record.defrecord(:decision, [:poll_request_delta_suggestion])
  @type decision :: record(:decision, poll_request_delta_suggestion: integer())

  Record.defrecord(:group_info, [:id, :weight])
  @type group_info :: record(:group_info, id: String.t(), weight: float())

  Record.defrecord(:start_operation, [
    :header,
    :endpoint,
    :service,
    :operation,
    :request_id,
    :callback,
    :callback_header,
    :links,
    scheduled_time: nil,
    capabilities: nil,
    payload: nil
  ])

  @type start_operation ::
          record(:start_operation,
            header: %{String.t() => String.t()},
            scheduled_time: Timestamp.timestamp() | nil,
            capabilities: capabilities() | nil,
            endpoint: String.t(),
            service: String.t(),
            operation: String.t(),
            request_id: String.t(),
            callback: String.t(),
            payload: Payload.payload() | nil,
            callback_header: %{String.t() => String.t()},
            links: [link()]
          )

  Record.defrecord(:cancel_operation, [
    :header,
    :endpoint,
    :service,
    :operation,
    :operation_id,
    :operation_token,
    scheduled_time: nil,
    capabilities: nil
  ])

  @type cancel_operation ::
          record(:cancel_operation,
            header: %{String.t() => String.t()},
            scheduled_time: Timestamp.timestamp() | nil,
            capabilities: capabilities() | nil,
            endpoint: String.t(),
            service: String.t(),
            operation: String.t(),
            operation_id: String.t(),
            operation_token: String.t()
          )

  Record.defrecord(:capabilities, [:temporal_failure_responses])
  @type capabilities :: record(:capabilities, temporal_failure_responses: bool())

  Record.defrecord(:link, [:url, :link_type])
  @type link :: record(:link, url: String.t(), link_type: String.t())

  Record.defrecord(:cancel_task, [
    :endpoint,
    :reason,
    request_deadline: nil,
    task_token: nil
  ])

  @type cancel_task ::
          record(:cancel_task,
            endpoint: String.t(),
            reason: cancel_reason(),
            request_deadline: Timestamp.timestamp() | nil,
            task_token: binary()
          )

  @type cancel_reason :: :timed_out | :worker_shutdown
end
