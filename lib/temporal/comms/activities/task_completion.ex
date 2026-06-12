defmodule Temporal.Comms.Activities.TaskCompletion do
  defstruct [:result, :task_token]

  alias Temporal.Comms.Activities.ExecutionResult
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Failure

  @type completion ::
          {:completed, Payload.payload() | term(), task_token()}
          | {:failed, Failure.failure(), task_token()}
          | {:cancelled, Failure.failure(), task_token()}
          | {:will_complete_async, task_token()}

  @type task_token :: binary()

  def send_to_engine({:completed, result, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:completed, result}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:failed, failure, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:failed, failure}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:cancelled, failure, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:cancelled, failure}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:will_complete_async, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine(:will_complete_async),
      task_token: :binary.bin_to_list(token)
    }
  end
end
