defmodule Temporal do
  alias Temporal.Client.DialClient
  alias Temporal.Worker

  @spec dial_client(host_port :: DialClient.host_port(), opts :: [DialClient.client_opt()]) ::
          {:ok, DialClient.t()} | {:error, term()}
  def dial_client(host_port, opts \\ []) do
    DialClient.new(host_port, opts)
  end

  @spec worker(Client.t(), task_queue :: Worker.task_queue(), opts :: [Worker.worker_opt()]) ::
          {:ok, Worker.t()} | {:error, term()}
  def worker(client, task_queue, opts \\ []) do
    Worker.new(client, task_queue, opts)
  end
end
