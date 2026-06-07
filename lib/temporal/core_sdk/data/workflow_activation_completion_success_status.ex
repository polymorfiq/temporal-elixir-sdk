defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus do
  defstruct [:commands, used_internal_flags: [], versioning_behavior: :unspecified]

  alias Temporal.CoreSdk.Data

  @type versioning_behavior :: :unspecified | :pinned | :auto_upgrade
  @type t :: %__MODULE__{
          commands: [Data.WorkflowCommand.t()],
          used_internal_flags: [pos_integer()],
          versioning_behavior: versioning_behavior()
        }

  @type opts :: [
          {:commands, [Data.WorkflowCommand.opts()]}
          | {:used_internal_flags, [pos_integer()]}
          | {:versioning_behavior, versioning_behavior()}
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
