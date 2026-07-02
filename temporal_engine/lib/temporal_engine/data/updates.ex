defmodule TemporalEngine.Data.Updates do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Failure

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Updates
  alias TemporalEngine.Data.Payload

  deftype :update_options do
    @doc "Indicates the Update lifecycle stage that the Update must reach before API call is returned."
    @type wait_policy :: nested!(Updates.update_wait_policy())

    @doc "Headers that are passed with the Update from the requesting entity. These can include things like auth or tracing tokens."
    @type header :: nested!(Common.header())

    @doc "Unique ID for the Update"
    @type id :: required :: String.t()
  end

  deftype :workflow_update do
    @doc "The name of the Update handler to invoke on the target Workflow."
    @type name :: required :: String.t()

    @doc "The arguments to pass to the named Update handler."
    @type args :: required :: [nested!(Payload.payload())]

    @doc "Headers that are passed with the Update from the requesting entity. These can include things like auth or tracing tokens."
    @type header :: nested!(Common.header())
  end

  deftype :update_wait_policy do
    @doc """
    Indicates the Update lifecycle stage that the Update must reach before API call is returned.

    NOTE: This field works together with API call timeout which is limited by server timeout (maximum wait time).

    If server timeout is expired before user specified timeout, API call returns even if specified stage is not reached.

    - `:admitted` - The API call will not return until the Update request has been admitted by the server - it may be the case that due to a considerations like load or resource limits that an Update is made to wait before the server will indicate that it has been received and will be processed. This value does not wait for any sort of acknowledgement from a worker.
    - `:accepted` - The API call will not return until the Update has passed validation on a worker.
    - `:completed` - The API call will not return until the Update has executed to completion on a worker and has either been rejected or returned a value or an error.
    """
    @default :unspecified
    @type lifecycle_stage :: required :: :unspecified | :admitted | :accepted | :completed
  end

  deftype :workflow_update_response do
    @doc "Enough information for subsequent poll calls if needed. Never null."
    @type update_ref :: nested!(Updates.update_ref())

    @doc """
    The outcome of the Update if and only if the Workflow Update has completed. If this response is being returned before the Update has completed then this field will not be set.
    """
    @type outcome :: nested!(Updates.update_outcome())

    @doc """
    The most advanced lifecycle stage that the Update is known to have reached, where lifecycle stages are ordered UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_UNSPECIFIED < UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_ADMITTED < UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_ACCEPTED < UPDATE_WORKFLOW_EXECUTION_LIFECYCLE_STAGE_COMPLETED. UNSPECIFIED will be returned if and only if the server’s maximum wait time was reached before the Update reached the stage specified in the request WaitPolicy, and before the context deadline expired; clients may may then retry the call as needed.
    """
    @type stage :: required :: :unspecified | :admitted | :accepted | :completed

    @doc "Link to the update event. May be null if the update has not yet been accepted."
    @type link :: nested!(Common.link())
  end

  deftype :update_ref do
    @structdoc "The data needed by a client to refer to a previously invoked Workflow Update."

    @type workflow_execution :: nested!(Common.workflow_execution())
    @type update_id :: required :: String.t()
  end

  deftype :update_outcome do
    @structdoc "The outcome of a Workflow Update: success or failure."

    @type value :: [nested!(Payload.payload())] | nested!(Failure.failure())
  end
end
