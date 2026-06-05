defmodule Temporal.CoreSdk.Data.Callback do
  defstruct [:links, variant: nil]

  alias Temporal.CoreSdk.Data

  @type variant :: {:nexus, Data.CallbackNexus.t()} | {:internal, Data.CallbackInternal.t()}
  @type t :: %__MODULE__{
          links: [Data.Link.t()],
          variant: variant() | nil
        }

  @type variant_opts ::
          {:nexus, Data.CallbackNexus.opts()} | {:internal, Data.CallbackInternal.opts()}
  @type opts :: [{:links, [Data.Link.opts()]} | {:variant, variant_opts()}]

  def with_opts!(opts) do
    callback = struct!(__MODULE__, opts)

    callback =
      case opts[:variant] do
        nil ->
          nil

        {:nexus, nexus_opts} ->
          %{callback | variant: {:nexus, Data.CallbackNexus.with_opts!(nexus_opts)}}

        {:internal, internal_opts} ->
          %{callback | variant: {:internal, Data.CallbackInternal.with_opts!(internal_opts)}}
      end

    callback
  end
end
