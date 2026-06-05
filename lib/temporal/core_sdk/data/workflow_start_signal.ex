defmodule Temporal.CoreSdk.Data.WorkflowStartSignal do
  defstruct [
    :signal_name,
    input: nil,
    header: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          signal_name: String.t(),
          input: Data.Payloads.t() | nil,
          header: Data.Header.t() | nil
        }

  @type opts :: [
          {:signal_name, String.t()}
          | {:input, Data.Payloads.opts()}
          | {:header, Data.Header.opts()}
        ]

  def with_opts!(opts) do
    start_signal = struct!(__MODULE__, opts)

    start_signal =
      if opts[:input] do
        update_in(start_signal, [Access.key(:input)], &Data.Payloads.with_opts!/1)
      else
        start_signal
      end

    start_signal =
      if opts[:header] do
        update_in(start_signal, [Access.key(:header)], &Data.Header.with_opts!/1)
      else
        start_signal
      end

    start_signal
  end
end
