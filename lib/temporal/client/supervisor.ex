defmodule Temporal.Client.Supervisor do
  use Supervisor

  @spec start_link(term()) :: {:ok, pid()} | {:error, term()}
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  @spec init(term()) :: Supervisor.init_result()
  def init(_init_arg) do
    children = [
      GRPC.Client.Supervisor,
      Temporal.Worker.Supervisor,
      Temporal.Environment
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
