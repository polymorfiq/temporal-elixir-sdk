defmodule Temporal.Comms.Activities.TaskCompletion do
  defstruct [:result, :task_token]

  alias Temporal.Comms.Activities.ExecutionResult
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Failure

  @type completion ::
          {:activity, :completed, Payload.payload() | term(), task_token()}
          | {:activity, :failed, Failure.failure(), task_token()}
          | {:activity, :cancelled, Failure.failure(), task_token()}
          | {:activity, :will_complete_async, task_token()}

  @type task_token :: binary()

  def send_to_engine({:activity, :completed, result, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:completed, result}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:activity, :failed, failure, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:failed, failure}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:activity, :cancelled, failure, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine({:cancelled, failure}),
      task_token: :binary.bin_to_list(token)
    }
  end

  def send_to_engine({:activity, :will_complete_async, token}) do
    %__MODULE__{
      result: ExecutionResult.send_to_engine(:will_complete_async),
      task_token: :binary.bin_to_list(token)
    }
  end
end
