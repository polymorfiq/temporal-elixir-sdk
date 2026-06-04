defmodule Temporal.Client do
  defstruct [:namespace, :runtime, :core]

  alias Temporal.Constants
  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.{ClientOpts, ClientRetryOpts, WorkflowDefinition, WorkflowStartOptions, WorkflowArguments, WorkflowInput, ClientPriority}
  alias Temporal.Workflows.WorkflowHandle

  @type t :: %__MODULE__{runtime: CoreRuntime.t(), core: CoreClient.t()}
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
  @start_workflow_msg_prefix :start_workflow

  @spec new(target_host(), client_opts()) :: {:ok, t()} | {:error, term()}
  def new(target_host, opts \\ []) do
    with {:ok, opts} <- validate_opts(opts) do
      initialize_client(target_host, opts)
    else
      {:error, err} -> {:error, {:invalid_opts, err}}
    end
  end

  @spec validate_opts(keyword()) :: {:ok, client_opts()} | {:error, term()}
  defp validate_opts(opts) do
    identity =
      Keyword.get_lazy(opts, :identity, fn ->
        "#{UUID.uuid4()}@#{to_string(:net_adm.localhost())}"
      end)

    opts_validate =
      Keyword.validate(opts, [
        :rpc,
        identity: identity,
        namespace: @default_namespace
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
    rpc_opts = @default_rpc_opts ++ Keyword.get(opts, :rpc, [])

    client_opts = %ClientOpts{
      target_host: target_host,
      namespace: namespace,
      client_name: Constants.sdk_name(),
      client_version: Constants.sdk_version(),
      identity: Keyword.fetch!(opts, :identity),
      rpc_retry: %ClientRetryOpts{
        initial_interval_secs: rpc_opts[:initial_interval_secs],
        randomization_factor: rpc_opts[:randomization_factor],
        multiplier: rpc_opts[:multiplier],
        max_interval_secs: rpc_opts[:max_interval_secs],
        max_elapsed_time_secs: rpc_opts[:max_elapsed_time_secs],
        max_retries: rpc_opts[:max_retries]
      }
    }

    with {:ok, runtime} <- Temporal.CoreSdk.CoreRuntime.new(),
         {:ok, core} <- Temporal.CoreSdk.CoreClient.new(runtime, client_opts) do
      {:ok, %__MODULE__{core: core, runtime: runtime, namespace: namespace}}
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

  def start_workflow(client, task_queue, workflow_id, workflow_name, inputs) do
    args = Enum.map(inputs, fn
      {:bytes, val} -> {:bytes, val}
      input -> WorkflowInput.new(input)
    end)

    parent = self()
    spawn_link(fn ->
      CoreSdk._client_start_workflow(
        client.runtime.runtime,
        client.core.client,
        %WorkflowDefinition{name: workflow_name},
        %WorkflowArguments{args: args},
        %WorkflowStartOptions{
          task_queue: task_queue,
          workflow_id: workflow_id,
          id_reuse_policy: :allow_duplicate,
          id_conflict_policy: :fail,
          enable_eager_workflow_start: false,
          links: [],
          completion_callbacks: [],
          priority: %ClientPriority{priority_key: 1, fairness_key: "Fair", fairness_weight: 1}
        },
        self()
      )

      receive do
        {:ok, workflow_handle} ->
          send(parent, {@start_workflow_msg_prefix, {:ok, workflow_handle}})

        {:error, err} ->
          send(parent, {@start_workflow_msg_prefix, {:error, err}})
      end
    end)

    receive do
      {@start_workflow_msg_prefix, resp} -> resp
    end
  end
end
