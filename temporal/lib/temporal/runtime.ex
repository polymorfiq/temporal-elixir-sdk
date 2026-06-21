defmodule Temporal.Runtime do
  @moduledoc """
  Holds shared state/components needed to back instances of workers and clients.

  More than one may be instantiated, but typically only one is needed.

  More than one runtime instance may be useful if multiple different telemetry settings are required.
  """

  @opaque t() :: TemporalEngine.Runtime.t()

  @doc "Provides the default, global runtime for Temporal Clients"
  @spec global :: TemporalEngine.Runtime.t()
  def global do
    case :ets.lookup(Temporal.Storage.global_store(), :global_runtime) do
      [{_, runtime}] ->
        runtime

      _ ->
        engine = Application.fetch_env!(:temporal, :engine)
        {:ok, runtime} = engine.create_runtime(id: "_temporal_global")
        :ets.insert(Temporal.Storage.global_store(), {:global_runtime, runtime})
        runtime
    end
  end
end
