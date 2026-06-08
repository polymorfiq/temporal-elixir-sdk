defmodule Temporal.Client do
  defstruct [:identity, :namespace, :runtime_id]

  alias Temporal.ClientRegistry
  alias Temporal.Constants
  alias Temporal.Internal.Hash
  alias Temporal.Runtime
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.RuntimeSupervisor
  alias Temporal.Workflows.WorkflowHandle
  alias Temporal.CoreSdk.Data.ClientOpts

  @type t :: %__MODULE__{identity: String.t(), namespace: String.t(), runtime_id: String.t()}
  @type target_host :: String.t()

  @type rpc_opts :: [
          {:initial_interval_secs, float()}
          | {:randomization_factor, float()}
          | {:multiplier, float()}
          | {:max_interval_secs, float()}
          | {:max_elapsed_time_secs, float()}
          | {:max_retries, pos_integer()}
        ]
  @type client_opts :: [
          {:namespace, String.t()}
          | {:identity, String.t()}
          | {:rpc, rpc_opts()}
        ]

  @default_namespace "default"
  @default_rpc_opts [
    initial_interval_secs: 30.0,
    randomization_factor: 5.0,
    multiplier: 2.0,
    max_interval_secs: 60.0,
    max_elapsed_time_secs: 60.0,
    max_retries: 30
  ]

  @spec new(target_host(), client_opts()) :: {:ok, t()} | {:error, term()}
  def new(target_host, opts \\ []) do
    with {:ok, opts} <- validate_opts(opts) do
      initialize_client(target_host, opts)
    else
      {:error, err} -> {:error, {:invalid_opts, err}}
    end
  end

  def core_runtime(client),
    do: Runtime.core_for_id(client.runtime_id)

  def core_for_identity(identity),
    do: ClientSupervisor.core_for_identity(identity)

  @spec validate_opts(keyword()) :: {:ok, client_opts()} | {:error, term()}
  defp validate_opts(opts) do
    opts_validate =
      Keyword.validate(opts, [
        :rpc,
        :runtime,
        :identity,
        :namespace
      ])

    rpc_validate = Keyword.validate(opts[:rpc] || [], @default_rpc_opts)

    cond do
      match?({:error, _}, opts_validate) ->
        opts_validate

      match?({:error, _}, rpc_validate) ->
        {:error, err} = rpc_validate
        {:error, [rpc: err]}

      true ->
        {:ok, opts} = opts_validate
        {:ok, rpc} = rpc_validate
        {:ok, opts ++ [rpc: rpc]}
    end
  end

  defp initialize_client(target_host, opts) do
    namespace = Keyword.get(opts, :namespace, @default_namespace)
    rpc_opts = @default_rpc_opts ++ Keyword.get(opts, :rpc_retry, [])

    identity =
      Keyword.get_lazy(opts, :identity, fn ->
        "#{Hash.random_hash(8)}@#{to_string(:net_adm.localhost())}"
      end)

    client_opts =
      ClientOpts.with_opts!(
        target_host: target_host,
        namespace: namespace,
        client_name: Constants.sdk_name(),
        client_version: Constants.sdk_version(),
        identity: identity,
        rpc_retry: [
          initial_interval_secs: rpc_opts[:initial_interval_secs],
          randomization_factor: rpc_opts[:randomization_factor],
          multiplier: rpc_opts[:multiplier],
          max_interval_secs: rpc_opts[:max_interval_secs],
          max_elapsed_time_secs: rpc_opts[:max_elapsed_time_secs],
          max_retries: rpc_opts[:max_retries]
        ]
      )

    runtime_resp =
      if runtime = Keyword.get(opts, :runtime) do
        {:ok, runtime}
      else
        Runtime.global()
      end

    reg_name = {:via, Registry, {ClientRegistry, {:client, identity}}}

    with {:ok, runtime} <- runtime_resp,
         {:ok, runtime_core} <- Runtime.core_for_id(runtime.id),
         {:ok, clients_sup} <- RuntimeSupervisor.clients_sup_for_id(runtime.id) do
      child_started =
        DynamicSupervisor.start_child(
          clients_sup,
          Supervisor.child_spec(
            {ClientSupervisor,
             {
               runtime_core,
               client_opts,
               [name: reg_name]
             }},
            restart: :transient
          )
        )

      with {:ok, _} <- child_started do
        {:ok, %__MODULE__{identity: identity, namespace: namespace, runtime_id: runtime.id}}
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
end
