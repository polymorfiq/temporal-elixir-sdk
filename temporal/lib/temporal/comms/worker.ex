defmodule Temporal.Comms.Worker do
  use GenServer
  @moduledoc """
  An agent that polls the Temporal Server (Namespace, Task Queue) for work to do, workflows and activities to run.

  When new work is received, the worker performs the work while informing the Temporal Server of progress and needed resources.
  """

  import TemporalEngine.Config
  require Record

  alias Temporal.Comms.Client
  alias TemporalEngine.Config

  Record.defrecordp(:worker, [:core, :pid])
  Record.defrecordp(:worker_state, [:client, :worker, :config])

  @opaque t() :: TemporalEngine.Worker.t()

  @spec new(Client.t(), Config.worker_config_opts()) :: {:ok, t()} | {:error, term()}
  def new(client, opts \\ []) do

    with {:ok, config} <- worker_config_from_opts(opts) do
      identity = worker_config(config, :client_identity_override) || TemporalEngine.Client.id(client)
      id = "#{identity}_#{worker_config(config, :namespace)}"

      name = {:via, Registry, {Temporal.TemporalRegistry, {:worker, id}}}

      with {:ok, pid} <- DynamicSupervisor.start_child(Temporal.Workers, {__MODULE__, {name, client, config}}) do
        {:ok, pid}
      else
        {:error, {:already_started, pid}} -> {:ok, pid}
      end
    end
  end

  def start_link({name, client, config}) do
    GenServer.start_link(__MODULE__, {client, config}, name: name)
  end

  def init({client, config}) do
    identity = worker_config(config, :client_identity_override) || TemporalEngine.Client.id(client)
    Process.set_label({:worker, worker_config(config, :namespace), identity})

    with {:ok, worker} <- TemporalEngine.Client.create_worker(client, config) do
      {:ok, worker_state(client: client, worker: worker, config: config)}
    end
  end
end