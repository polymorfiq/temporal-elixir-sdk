defmodule TemporalEngine.Mock.Engine do
  use TemporalEngine.Engine

  alias TemporalEngine.Mock

  def create_runtime(opts) do
    real_engine = Application.fetch_env!(:temporal, :engine)

    with {:ok, real_runtime} <- real_engine.create_runtime(opts) do
      runtime_id = TemporalEngine.Runtime.id(real_runtime)
      mocked = Mock.Runtime.new(real_runtime)

      :ets.insert(Mock.Storage.set(), {{:runtime, runtime_id}, mocked})

      {:ok, mocked}
    end
  end
end
