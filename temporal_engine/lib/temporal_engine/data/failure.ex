defmodule TemporalEngine.Data.Failure do
  use TemporalEngine.Data.TypeSpec

  require Record

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Failure

  deftype :failure do
    @type message :: required :: String.t()

    @doc "The source this Failure originated in, e.g. TypeScriptSDK / JavaSDK In some SDKs this is used to rehydrate the stack trace into an exception object."
    @default "elixir-sdk"
    @type source :: required :: String.t()

    @default ""
    @type stack_trace :: required :: String.t()

    @doc """
    Alternative way to supply message and stack_trace and possibly other attributes, used for encryption of errors originating in user code which might contain sensitive information. The encoded_attributes Payload could represent any serializable object, e.g. JSON object or a Failure proto message.

    SDK authors:
      - The SDK should provide a default encodeFailureAttributes and decodeFailureAttributes implementation that:
      - - Uses a JSON object to represent { message, stack_trace }.
      - - Overwrites the original message with “Encoded failure” to indicate that more information could be extracted.
      - - Overwrites the original stack_trace with an empty string.
      - - The resulting JSON object is converted to Payload using the default PayloadConverter and should be processed by the user-provided PayloadCodec
      - If there’s demand, we could allow overriding the default SDK implementation to encode other opaque Failure attributes. (– api-linter: core::0203::optional=disabled –)
    """
    @type encoded_attributes :: nested!(Payload.payload())
    @type cause :: nested!(Failure.failure())
    @type failure_info ::
            nested!(Failure.application())
            | nested!(Failure.timeout_reached())
            | nested!(Failure.cancelled())
            | nested!(Failure.terminated())
            | nested!(Failure.server())
            | nested!(Failure.reset_workflow())
            | nested!(Failure.activity())
            | nested!(Failure.child_execution())
            | nested!(Failure.nexus_operation())
            | nested!(Failure.nexus_handler())
  end

  deftype :application do
    @type failure_type :: required :: String.t()

    @default false
    @type non_retryable :: required :: bool()

    @default []
    @type details :: required :: [nested!(Payload.payload())]

    @doc """
    `next_retry_delay` can be used by the client to override the activity retry interval calculated by the retry policy. Retry attempts will still be subject to the maximum retries limit and total time limit defined by the policy.
    """
    @type next_retry_delay :: nested!(Duration.duration())

    @default :unspecified
    @type category :: required :: :unspecified | :benign
  end

  deftype :timeout_reached do
    @default :unspecified
    @type timeout_type :: required :: Failure.timeout_type()
    @type last_heartbeat_details :: [nested!(Payload.payload())]
  end

  @type timeout_type ::
          :unspecified | :start_to_close | :schedule_to_start | :schedule_to_close | :heartbeat

  @type timeout_type_opts :: timeout_type()

  deftype :cancelled do
    @doc "The identity of the worker or client that requested the cancellation."
    @type identity :: required :: String.t()
    @type details :: [nested!(Payload.payload())]
  end

  deftype :terminated do
    @doc "The identity of the worker or client that requested the termination."
    @type identity :: required :: String.t()
  end

  deftype :server do
    @type non_retryable :: required :: bool()
  end

  deftype :reset_workflow do
    @type last_heartbeat_details :: required :: [nested!(Payload.payload())]
  end

  deftype :activity do
    @type scheduled_event_id :: required :: integer()
    @type started_event_id :: required :: integer()
    @type identity :: required :: String.t()
    @type activity_type :: nested!(Failure.activity_type())
    @type activity_id :: required :: String.t()
    @type retry_state ::
            required ::
            :unspecified
            | :in_progress
            | :non_retryable_failure
            | :timeout
            | :maximum_attempts_reached
            | :retry_policy_not_set
            | :internal_server_error
            | :cancel_requested
  end

  deftype :activity_type do
    @type name :: required :: String.t()
  end

  deftype :child_execution do
    @type namespace :: required :: String.t()
    @type workflow_execution :: nested!(Common.workflow_execution())
    @type workflow_type :: nested!(Failure.workflow_type())
    @type initiated_event_id :: required :: integer()
    @type started_event_id :: required :: integer()
    @type retry_state ::
            required ::
            :unspecified
            | :in_progress
            | :non_retryable_failure
            | :timeout
            | :maximum_attempts_reached
            | :retry_policy_not_set
            | :internal_server_error
            | :cancel_requested
  end

  deftype :workflow_type do
    @type name :: required :: String.t()
  end

  deftype :nexus_operation do
    @doc "The NexusOperationScheduled event ID."
    @type scheduled_event_id :: required :: integer()

    @doc "Endpoint name."
    @type endpoint :: required :: String.t()

    @doc "Service name."
    @type service :: required :: String.t()

    @doc "Operation name."
    @type operation :: required :: String.t()

    @doc """
    Operation ID - may be empty if the operation completed synchronously.
    """

    @deprecated "Renamed to operation_token."
    @type operation_id :: required :: String.t()

    @doc "Operation token - may be empty if the operation completed synchronously."
    @type operation_token :: required :: String.t()
  end

  deftype :nexus_handler do
    @doc "The Nexus error type as defined in the spec: https://github.com/nexus-rpc/api/blob/main/SPEC.md#predefined-handler-errors"
    @type failure_type :: required :: String.t()

    @doc "Retry behavior, defaults to the retry behavior of the error type as defined in the spec."
    @default :unspecified
    @type retry_behavior :: required :: :unspecified | :retryable | :non_retryable
  end

  deftype :workflow_failed do
    @type failure :: required :: nested!(Failure.failure())
  end

  deftype :workflow_cancelled do
    @default []
    @type details :: required :: [nested!(Payload.payload())]
  end

  deftype :workflow_terminated do
    @default []
    @type details :: required :: [nested!(Payload.payload())]
  end

  deftype :workflow_timed_out do
  end

  deftype :workflow_continued_as_new do
  end

  deftype :workflow_not_found do
  end

  deftype :workflow_payload_conversion do
    @type message :: required :: String.t()
  end

  deftype :workflow_rpc_error do
    @type message :: required :: String.t()
  end

  deftype :workflow_other_error do
    @type message :: required :: String.t()
  end

  def to_map(failure() = f) do
    %{
      error_code: :workflow_failed,
      message: failure(f, :message),
      source: failure(f, :source),
      stacktrace: failure(f, :stack_trace),
      cause: failure(f, :cause),
      failure:
        case failure(f, :failure_info) do
          application() = info ->
            %{
              type: :application,
              info: %{
                details: Enum.map(application(info, :details), &Payload.value_from_record/1),
                non_retryable: application(info, :non_retryable),
                next_retry_delay:
                  if(d = application(info, :next_retry_delay),
                    do: Duration.to_tuple(d)
                  )
              }
            }

          timeout_reached() = info ->
            %{
              type: :timeout_reached,
              timeout_type: timeout_reached(info, :timeout_type),
              last_heartbeat_details:
                Enum.map(
                  timeout_reached(info, :last_heartbeat_details) || [],
                  &Payload.value_from_record/1
                )
            }

          cancelled() = info ->
            %{
              type: :cancelled,
              identity: cancelled(info, :identity),
              details: Enum.map(cancelled(info, :details) || [], &Payload.value_from_record/1)
            }

          terminated() = info ->
            %{
              type: :terminated,
              identity: terminated(info, :identity)
            }

          server() = info ->
            %{
              type: :server,
              non_retryable: server(info, :non_retryable)
            }

          reset_workflow() = info ->
            %{
              type: :reset_workflow,
              last_hearbeat_details:
                Enum.map(
                  reset_workflow(info, :last_heartbeat_details) || [],
                  &Payload.value_from_record/1
                )
            }

          activity() = info ->
            %{
              type: :activity,
              scheduled_event_id: activity(info, :scheduled_event_id),
              started_event_id: activity(info, :started_event_id),
              identity: activity(info, :identity),
              activity_id: activity(info, :activity_id),
              activity_type:
                if(type = activity(info, :activity_type), do: activity_type(type, :name)),
              retry_state: activity(info, :retry_state)
            }

          child_execution() = info ->
            %{
              type: :child_execution,
              namespace: child_execution(info, :namespace),
              initiated_event_id: child_execution(info, :initiated_event_id),
              started_event_id: child_execution(info, :started_event_id),
              retry_state: child_execution(info, :retry_state),
              workflow_execution: child_execution(info, :workflow_execution),
              workflow_type:
                if(type = child_execution(info, :workflow_type), do: workflow_type(type, :name))
            }

          nexus_operation() = info ->
            %{
              type: :nexus_operation,
              scheduled_event_id: nexus_operation(info, :scheduled_event_id),
              endpoint: nexus_operation(info, :endpoint),
              service: nexus_operation(info, :service),
              operation: nexus_operation(info, :operation),
              operation_id: nexus_operation(info, :operation_id),
              operation_token: nexus_operation(info, :operation_token)
            }

          nexus_handler() = info ->
            %{
              type: :nexus_handler,
              failure_type: nexus_handler(info, :failure_type),
              retry_behavior: nexus_handler(info, :retry_behavior)
            }
        end
    }
  end
end
