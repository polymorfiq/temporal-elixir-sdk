defmodule TemporalEngineNif.Engine do
  use TemporalEngine.Engine

  require TemporalEngine.Opts.ClientOpts

  alias TemporalEngine.Opts.ClientOpts
  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Runtime

  @impl true
  def create_runtime(opts) do
    with {:ok, rt_opts} <- ClientOpts.runtime_opts_from_opts(opts),
         {:ok, core} <- Core._create_runtime(rt_opts) do
      {:ok, %Runtime{id: ClientOpts.runtime_opts(rt_opts, :id), core: core}}
    end
  end
end
