defmodule Temporal.Comms.Runtime do
  @moduledoc """
  Holds shared state/components needed to back instances of workers and clients.

  More than one may be instantiated, but typically only one is needed.

  More than one runtime instance may be useful if multiple different telemetry settings are required.
  """

  @opaque t() :: TemporalEngine.Runtime.t()

  @doc "Provides the default, global runtime for Temporal Clients"
  @spec global :: TemporalEngine.Runtime.t()
  def global, do: Temporal.Application.global_runtime()
end
