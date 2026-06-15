defmodule TemporalEngineNif.Data.WorkflowFailure do
  defstruct [
    :message,
    source: "",
    stack_trace: "",
    encoded_attributes: nil,
    cause: nil,
    failure_info: nil
  ]

  import TemporalEngine.Data.Failure

  alias TemporalEngineNif.Data.Payload
  alias TemporalEngineNif.Data.WorkflowFailureInfo
  alias TemporalEngine.Data.Failure, as: EngineFailure

  @type t :: %__MODULE__{
          message: String.t(),
          source: String.t(),
          stack_trace: String.t(),
          encoded_attributes: Payload.t() | nil,
          cause: t() | nil,
          failure_info: Data.WorkflowFailureInfo.t() | nil
        }

  @spec to_record(t() | nil) :: EngineFailure.failure() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{} = failure) do
    failure(
      message: failure.message,
      source: failure.source,
      stack_trace: failure.stack_trace,
      encoded_attributes: Payload.to_record(failure.encoded_attributes),
      cause: failure.cause,
      failure_info: WorkflowFailureInfo.to_record(failure.failure_info)
    )
  end

  @spec from_record(EngineFailure.failure() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(failure() = f) do
    %__MODULE__{
      message: failure(f, :message),
      source: failure(f, :source),
      stack_trace: failure(f, :stack_trace),
      encoded_attributes: Payload.from_record(failure(f, :encoded_attributes)),
      cause: failure(f, :cause),
      failure_info: WorkflowFailureInfo.from_record(failure(f, :failure_info))
    }
  end
end
