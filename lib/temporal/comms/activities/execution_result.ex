defmodule Temporal.Comms.Activities.ExecutionResult do
  defstruct [:status]

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Failure

  defmodule Completed do
    defstruct [:result]

    @type t :: %__MODULE__{result: Payload.t()}
  end

  defmodule Failed do
    defstruct [:failure]

    @type t :: %__MODULE__{failure: Failure.t()}
  end

  defmodule Cancelled do
    defstruct [:failure]

    @type t :: %__MODULE__{failure: Failure.t()}
  end

  defmodule WillCompleteAsync do
    defstruct []

    @type t :: %__MODULE__{}
  end

  @type t :: %__MODULE__{
          status:
            {:completed, Completed.t()}
            | {:failed, Failed.t()}
            | {:cancelled, Cancelled.t()}
            | {:will_complete_async, WillCompleteAsync.t()}
        }

  @type result ::
          {:completed, Payload.payload()}
          | {:failed, Failure.failure()}
          | {:cancelled, Failure.failure()}
          | :will_complete_async

  def send_to_engine({:completed, result}) do
    %__MODULE__{status: {:completed, %Completed{result: Payload.send_to_engine(result)}}}
  end

  def send_to_engine({:failed, failure}) do
    %__MODULE__{status: {:failed, %Failed{failure: Failure.send_to_engine(failure)}}}
  end

  def send_to_engine({:cancelled, failure}) do
    %__MODULE__{status: {:cancelled, %Cancelled{failure: Failure.send_to_engine(failure)}}}
  end

  def send_to_engine(:will_complete_async) do
    %__MODULE__{status: {:will_complete_async, %WillCompleteAsync{}}}
  end
end
