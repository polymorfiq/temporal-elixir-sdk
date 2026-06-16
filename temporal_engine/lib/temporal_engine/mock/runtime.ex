defmodule TemporalEngine.Mock.Runtime do
  defstruct [:real_runtime, :real_id]

  def new(real_runtime) do
    %__MODULE__{real_runtime: real_runtime, real_id: TemporalEngine.Runtime.id(real_runtime)}
  end

  def mocked_for_id(id) do
    case :ets.lookup(TemporalEngine.Mock.Storage.set(), {:runtime, id}) do
      [{_, mocked}] -> {:ok, mocked}
      _ -> {:error, "No mocks found"}
    end
  end
end

defimpl TemporalEngine.Runtime, for: TemporalEngine.Mock.Runtime do
  alias TemporalEngine.Mock

  def id(runtime) do
    "mocked(#{TemporalEngine.Runtime.id(runtime.real_runtime)})"
  end

  def create_client(runtime, opts) do
    Mock.Storage.initialize!()

    with {:ok, real_client} <- TemporalEngine.Runtime.create_client(runtime.real_runtime, opts) do
      client_id = TemporalEngine.Client.id(real_client)

      mocked = Mock.Client.new(real_client)
      :ets.insert(Mock.Storage.set(), {{:client, client_id}, mocked})
      :ets.insert(Mock.Storage.bag(), {{:clients, runtime.real_id}, mocked})

      {:ok, mocked}
    end
  end
end
