defmodule Temporal.CoreSdk.Data.CallbackInternal do
  defstruct [:data]

  @type t :: %__MODULE__{
          data: [byte()]
        }

  @type opts :: [{:data, [byte()]}] | [byte()]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    if Keyword.keyword?(opts) do
      struct!(__MODULE__, opts)
    else
      %__MODULE__{data: opts}
    end
  end
end
