defmodule TemporalEngineNif.Data.ActivityExecutionResult do
  defstruct status: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          status: Data.ActivityExecutionStatus.t() | nil
        }

  @type opts ::
          [{:status, Data.ActivityExecutionStatus.opts()}] | Data.ActivityExecutionStatus.opts()

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    if is_tuple(opts) do
      %__MODULE__{status: Data.ActivityExecutionStatus.with_opts!(opts)}
    else
      result = struct!(__MODULE__, opts)

      result =
        if opts[:status] do
          update_in(result, [Access.key(:status)], &Data.ActivityExecutionStatus.with_opts!/1)
        else
          result
        end

      result
    end
  end
end
