defmodule TemporalEngineNif.Data.Callback do
  defstruct [:links, variant: nil]

  alias TemporalEngineNif.Data

  @type variant :: {:nexus, Data.CallbackNexus.t()} | {:internal, Data.CallbackInternal.t()}
  @type t :: %__MODULE__{
          links: [Data.Link.t()],
          variant: variant() | nil
        }

  @type variant_opts ::
          {:nexus, Data.CallbackNexus.opts()} | {:internal, Data.CallbackInternal.opts()}
end
