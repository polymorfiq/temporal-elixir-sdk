defmodule Temporal.CoreSdk.Data.WorkflowCommand do
  defstruct user_metadata: nil,
            variant: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          user_metadata: Data.UserMetadata.t() | nil,
          variant: Data.WorkflowCommandVariant.t() | nil
        }

  @type opts ::
          [
            {:user_metadata, Data.UserMetadata.opts()},
            {:variant, Data.WorkflowCommandVariant.opts()}
          ]
          | {atom(), keyword()}

  @spec with_opts!(opts()) :: t()
  def with_opts!({variant, variant_opts}) do
    %__MODULE__{variant: Data.WorkflowCommandVariant.with_opts!({variant, variant_opts})}
  end

  def with_opts!(opts) do
    cmd = struct!(__MODULE__, opts)

    cmd =
      if opts[:user_metadata] do
        update_in(cmd, [Access.key(:user_metadata)], &Data.UserMetadata.with_opts!/1)
      else
        cmd
      end

    cmd =
      if opts[:variant] do
        update_in(cmd, [Access.key(:variant)], &Data.WorkflowCommandVariant.with_opts!/1)
      else
        cmd
      end

    cmd
  end
end
