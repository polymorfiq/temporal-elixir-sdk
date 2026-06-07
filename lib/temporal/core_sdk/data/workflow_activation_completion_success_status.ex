defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus do
  defstruct [:commands, used_internal_flags: [], versioning_behavior: 0]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          commands: [Data.WorkflowCommand.t()],
          used_internal_flags: [pos_integer()],
          versioning_behavior: integer()
        }

  @type opts :: [
          {:commands, [Data.WorkflowCommand.opts()]}
          | {:used_internal_flags, [pos_integer()]}
          | {:versioning_behavior, integer()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    status = struct!(__MODULE__, opts)

    status =
      update_in(status, [Access.key(:commands)], fn commands ->
        Enum.map(commands, &Data.WorkflowCommand.with_opts!/1)
      end)

    status
  end
end
