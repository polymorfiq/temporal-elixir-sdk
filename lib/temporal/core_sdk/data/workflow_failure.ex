defmodule Temporal.CoreSdk.Data.WorkflowFailure do
  defstruct [
    :message,
    :source,
    :stack_trace,
    encoded_attributes: nil,
    cause: nil,
    failure_info: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          message: String.t(),
          source: String.t(),
          stack_trace: String.t(),
          encoded_attributes: Data.Payload.t() | nil,
          cause: t() | nil,
          failure_info: Data.WorkflowFailureInfo.t() | nil
        }

  @type opts :: [
          {:message, String.t()}
          | {:source, String.t()}
          | {:stack_trace, String.t()}
          | {:encoded_attributes, Data.Payload.opts()}
          | {:cause, opts()}
          | {:failure_info, Data.WorkflowFailureInfo.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    failure = struct!(__MODULE__, opts)

    failure =
      if opts[:encoded_attributes] do
        update_in(failure, [Access.key(:encoded_attributes)], &Data.Payload.with_opts!/1)
      else
        failure
      end

    failure =
      if opts[:cause] do
        update_in(failure, [Access.key(:cause)], &with_opts!/1)
      else
        failure
      end

    failure =
      if opts[:failure_info] do
        update_in(failure, [Access.key(:failure_info)], &Data.WorkflowFailureInfo.with_opts!/1)
      else
        failure
      end

    failure
  end
end
