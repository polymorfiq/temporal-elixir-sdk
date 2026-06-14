defmodule TemporalEngineNif.Data.ActivityExecutionSuccess do
  defstruct result: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          result: Data.Payload.t() | nil
        }

  @type opts :: [{:result, Data.Payload.opts()}] | Data.Payload.opts()

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    success = struct!(__MODULE__, opts)

    success =
      if opts[:result] do
        update_in(success, [Access.key(:result)], &Data.Payload.with_opts!/1)
      else
        success
      end

    success
  end
end
