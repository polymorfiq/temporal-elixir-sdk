defmodule TemporalEngine.Engine do
  require Record

  require TemporalEngine.Opts.ClientOpts

  alias TemporalEngine.Runtime
  alias TemporalEngine.Opts.ClientOpts

  defmacro __using__(_opts) do
    quote do
      @behaviour TemporalEngine.Engine
      import TemporalEngine.Engine
    end
  end

  @callback create_runtime(ClientOpts.runtime_opts_opts()) ::
              {:ok, Runtime.t()} | {:error, reason :: term()}
end
