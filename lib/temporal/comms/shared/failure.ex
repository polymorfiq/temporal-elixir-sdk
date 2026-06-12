defmodule Temporal.Comms.Shared.Failure do
  defstruct [
    :message,
    source: "",
    stack_trace: "",
    encoded_attributes: nil,
    cause: nil,
    failure_info: nil
  ]

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.FailureInfo

  @type failure ::
          {:failure, message :: String.t()} | {:failure, message :: String.t(), failure_opts()}
  @type failure_opts :: [
          {:source, String.t()}
          | {:stack_trace, String.t()}
          | {:encoded_attributes, Payload.payload()}
          | {:cause, failure()}
          | {:failure_info, FailureInfo.failure_info()}
        ]

  @type t :: %__MODULE__{
          message: String.t(),
          source: String.t(),
          stack_trace: String.t(),
          encoded_attributes: Payload.t() | nil,
          cause: t() | nil,
          failure_info: FailureInfo.t() | nil
        }

  @spec send_to_sdk(t()) :: failure()
  def send_to_sdk(failure) do
    opts = failure |> Map.from_struct() |> Map.drop(:message)

    opts =
      if opts[:encoded_attributes] do
        update_in(opts, [:encoded_attributes], &Payload.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:cause] do
        update_in(opts, [:cause], &send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:failure_info] do
        update_in(opts, [:failure_info], &FailureInfo.send_to_sdk/1)
      else
        opts
      end

    {:failure, failure.message, Keyword.new(opts)}
  end

  @spec send_to_engine(failure()) :: t()
  def send_to_engine({:failure, message}), do: send_to_engine({:failure, message, []})

  def send_to_engine({:failure, message, opts}) do
    opts = Keyword.put(opts, :message, message)

    failure = struct!(__MODULE__, opts)

    failure =
      if opts[:encoded_attributes] do
        update_in(failure, [Access.key(:encoded_attributes)], &Payload.send_to_engine/1)
      else
        failure
      end

    failure =
      if opts[:failure_info] do
        update_in(failure, [Access.key(:failure_info)], &FailureInfo.send_to_engine/1)
      else
        failure
      end

    failure
  end
end
