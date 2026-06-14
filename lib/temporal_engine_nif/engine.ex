defmodule TemporalEngineNif.Engine do
  use TemporalEngine.Engine

  import TemporalEngine.Engine
  alias TemporalEngineNif.Data.RuntimeOpts
  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Runtime

  @impl true
  def create_runtime(opts) do
    rt_opts = %RuntimeOpts{heartbeat_interval: runtime_opts(opts, :heartbeat_interval)}

    with {:ok, core} <- Core._create_runtime(rt_opts) do
      {:ok, %Runtime{core: core}}
    end
  end
end
