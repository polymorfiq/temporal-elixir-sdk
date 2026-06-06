defmodule Temporal.Supervisor.WorkflowSupervisor do
  use Supervisor

  @type run_id :: String.t()

  @spec start_link({run_id(), CoreRuntime.t(), CoreClient.t(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({workflow_id, runtime_core, client_core, server_opts}) do
    Supervisor.start_link(__MODULE__, {workflow_id, runtime_core, client_core}, server_opts)
  end

  @impl true
  def init({_worker_id, _runtime_core, _client_core}) do
    children = []

    Supervisor.init(children, strategy: :one_for_all)
  end
end
