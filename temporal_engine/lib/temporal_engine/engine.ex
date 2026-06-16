defmodule TemporalEngine.Engine do
  require Record

  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Runtime

  defmacro __using__(_opts) do
    quote do
      @behaviour TemporalEngine.Engine
      import TemporalEngine.Engine
    end
  end

  Record.defrecord(:runtime_opts, [:id, heartbeat_interval: nil])

  @type runtime_opts ::
          record(:runtime_opts, id: String.t(), heartbeat_interval: Duration.duration())

  @callback create_runtime(runtime_opts()) :: {:ok, Runtime.t()} | {:error, reason :: term()}
end
