defmodule TemporalEngineNif.Data.WorkflowCommandQuerySuccess do
  defstruct response: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          response: Data.Payload.t() | nil
        }

  @type opts :: [{:response, Data.Payload.opts()}] | Data.Payload.opts()

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    if Keyword.keyword?(opts) && opts[:response] do
      success = struct!(__MODULE__, opts)
      success = update_in(success, [Access.key(:result)], &Data.Payload.with_opts!/1)
      success
    else
      %__MODULE__{response: Data.Payload.with_opts!(opts)}
    end
  end
end
