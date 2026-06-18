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
    @type failure_info :: nested!(Failure.info())
  end

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

  @type info_opts ::
          application_opts()
          | timeout_reached_opts()
          | cancelled_opts()
          | terminated_opts()
          | server_opts()
          | reset_workflow_opts()
          | activity_opts()
          | child_execution_opts()
          | nexus_operation_opts()
          | nexus_handler_opts()

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
    @type category :: required :: Failure.category()
  end

  @type category :: :unspecified | :benign
  @type category_opts :: category()

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
    @type activity_id :: required :: nested!(Failure.activity_type())
    @type retry_state :: required :: nested!(Failure.retry_state())
    @type activity_type :: nested!(Failure.activity_type())
  end

  deftype :activity_type do
    @type name :: required :: String.t()
  end

  deftype :child_execution do
    @type namespace :: required :: String.t()
    @type initiated_event_id :: required :: integer()
    @type started_event_id :: required :: integer()
    @type retry_state :: required :: nested!(Failure.retry_state())

    @type workflow_execution :: nested!(Common.workflow_execution())
    @type workflow_type :: nested!(Failure.workflow_type())
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
    @type retry_behavior :: required :: nested!(Failure.retry_behavior())
  end

  @type retry_behavior :: :unspecified | :retryable | :non_retryable
  @type retry_behavior_opts :: retry_behavior()

  @type retry_state ::
          :unspecified
          | :in_progress
          | :non_retryable_failure
          | :timeout
          | :maximum_attempts_reached
          | :retry_policy_not_set
          | :internal_server_error
          | :cancel_requested

  @type retry_state_opts :: retry_state()

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
end
