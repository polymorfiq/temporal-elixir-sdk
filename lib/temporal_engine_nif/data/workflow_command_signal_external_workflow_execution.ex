defmodule TemporalEngineNif.Data.WorkflowCommandSignalExternalWorkflowExecution do
  defstruct [
    :seq,
    :signal_name,
    args: [],
    headers: %{},
    target: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          seq: pos_integer(),
          signal_name: String.t(),
          args: [Data.Payload.t()],
          headers: %{String.t() => Data.Payload.t()},
          target: Data.WorkflowCommandSignalExternalExecutionTarget.t() | nil
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:signal_name, String.t()}
          | {:args, [Data.Payload.opts()]}
          | {:headers, %{String.t() => Data.Payload.opts()}}
          | {:target, Data.WorkflowCommandSignalExternalExecutionTarget.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    signal = struct!(__MODULE__, opts)

    signal =
      update_in(signal, [Access.key(:args)], fn arguments ->
        Enum.map(arguments, &Data.Payload.with_opts!/1)
      end)

    signal =
      update_in(signal, [Access.key(:headers)], fn headers ->
        Map.new(headers, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    signal =
      if opts[:target] do
        update_in(
          signal,
          [Access.key(:target)],
          &Data.WorkflowCommandSignalExternalExecutionTarget.with_opts!/1
        )
      else
        signal
      end

    signal
  end
end
