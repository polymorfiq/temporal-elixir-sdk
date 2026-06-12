defmodule Temporal.Comms.Shared do
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Failure
  alias Temporal.Comms.Shared.Priority
  alias Temporal.Comms.Shared.Timestamp

  @type payload :: Payload.payload()
  @type duration :: Duration.duration()
  @type failure :: Failure.failure()
  @type priority :: Priority.priority()
  @type timestamp :: Timestamp.timestamp()
end
