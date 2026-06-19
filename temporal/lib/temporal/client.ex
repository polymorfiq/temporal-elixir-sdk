defmodule Temporal.Client do
  defstruct [:identity, :namespace, :runtime_id]

  require TemporalEngine.Opts.ClientOpts

  alias TemporalEngine.Opts.ClientOpts
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.ClientRegistry
  alias Temporal.Constants
  alias Temporal.Runtime
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.RuntimeSupervisor
  alias Temporal.Workflows.WorkflowHandle

  @type t :: %__MODULE__{identity: String.t(), namespace: String.t(), runtime_id: String.t()}
  @type extra_opts :: [{:runtime, Runtime.t()} | {:namespace, String.t()}]

  @spec new(target_host :: String.t(), ClientOpts.connection_opts_opts(), extra_opts()) ::
          {:ok, t()} | {:error, term()}
  def new(target_host, opts \\ [], extra_opts \\ []) do
    opts = Keyword.put(opts, :target, target_host)

    opts =
      Keyword.put_new_lazy(opts, :identity, fn ->
        with {:ok, hostname} <- :inet.gethostname() do
          "#{Constants.sdk_name()}-#{Constants.sdk_version()}@#{hostname}"
        else
          _ ->
            "#{Constants.sdk_name()}-#{Constants.sdk_version()}@no-host"
        end
      end)

    with {:ok, validated} <- ClientOpts.connection_opts_from_opts(opts) do
      initialize_client(validated, extra_opts)
    else
      {:error, err} -> {:error, {:invalid_opts, err}}
    end
  end

  def stop(client, opts \\ []) do
    if sup = GenServer.whereis({:via, Registry, {ClientRegistry, {:client, client.identity}}}) do
      Supervisor.stop(sup, :shutdown, Keyword.get(opts, :timeout, :infinity))
    else
      {:error, :client_already_stopped}
    end
  end

  def core_runtime(client),
    do: CoreRuntime.existing_for_id(client.runtime_id)

  defp initialize_client(conn_opts, extra_opts) do
    runtime_resp =
      if runtime = Keyword.get(extra_opts, :runtime) do
        {:ok, runtime}
      else
        Runtime.global()
      end

    reg_name =
      {:via, Registry,
       {ClientRegistry, {:client, ClientOpts.connection_opts(conn_opts, :identity)}}}

    with {:ok, runtime} <- runtime_resp,
         {:ok, runtime_core} <- CoreRuntime.existing_for_id(runtime.id),
         {:ok, clients_sup} <- RuntimeSupervisor.clients_sup_for_id(runtime.id) do
      child_started =
        DynamicSupervisor.start_child(
          clients_sup,
          Supervisor.child_spec(
            {ClientSupervisor,
             {
               runtime_core,
               conn_opts,
               [name: reg_name, shutdown: 60_000]
             }},
            restart: :transient
          )
        )

      with {:ok, _} <- child_started do
        {:ok,
         %__MODULE__{
           identity: ClientOpts.connection_opts(conn_opts, :identity),
           namespace: ClientOpts.connection_opts(conn_opts, :namespace),
           runtime_id: runtime.id
         }}
      end
    end
  end

  @spec workflow(t(), workflow :: module() | String.t(), WorkflowHandle.handle_opts()) ::
          WorkflowHandle.t()
  def workflow(client, workflow, opts \\ []) do
    is_module? = is_atom(workflow) && Kernel.function_exported?(workflow, :__info__, 1)

    workflow_name =
      if is_module? do
        workflow
        |> Module.split()
        |> Enum.join(".")
      else
        "#{workflow}"
      end

    handle_opts = [name: workflow_name]
    handle_opts = if is_module?, do: [{:module, workflow} | handle_opts], else: handle_opts

    WorkflowHandle.new(client, handle_opts ++ opts)
  end

  @spec stop_all_workers(t()) :: :ok
  def stop_all_workers(client) do
    ClientSupervisor.stop_all_workers(client.identity)
  end
end
