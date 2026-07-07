defmodule TemporalEngine.Mock.Client do
  defstruct [:real_client, :real_id]

  def new(real_client) do
    %__MODULE__{real_client: real_client, real_id: TemporalEngine.Client.id(real_client)}
  end

  def mocked_for_id(id) do
    case :ets.lookup(TemporalEngine.Mock.Storage.set(), {:client, id}) do
      [{_, mocked}] -> {:ok, mocked}
      _ -> {:error, "No mocks found"}
    end
  end
end

defimpl TemporalEngine.Client, for: TemporalEngine.Mock.Client do
  alias TemporalEngine.Mock

  def id(client) do
    "mocked(#{TemporalEngine.Client.id(client.real_client)})"
  end

  def namespace(client),
    do: TemporalEngine.Client.namespace(client.real_client)

  def create_worker(client, opts) do
    with {:ok, real_worker} <- TemporalEngine.Client.create_worker(client.real_client, opts) do
      worker_id = TemporalEngine.Worker.id(real_worker)
      mocked = TemporalEngine.Mock.Worker.new(real_worker)

      :ets.insert(Mock.Storage.set(), {{:worker, worker_id}, mocked})
      :ets.insert(Mock.Storage.bag(), {{:clients, client.real_id}, mocked})

      {:ok, mocked}
    end
  end

  def start_workflow(client, definition, args, opts) do
    TemporalEngine.Client.start_workflow(client.real_client, definition, args, opts)
  end

  def get_workflow_handle(client, workflow_id) do
    TemporalEngine.Client.get_workflow_handle(client.real_client, workflow_id)
  end

  def list_workflows(client, query, limit) do
    TemporalEngine.Client.list_workflows(client.real_client, query, limit)
  end
end
