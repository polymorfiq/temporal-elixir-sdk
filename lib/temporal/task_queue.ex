defmodule Temporal.TaskQueue do
  defstruct [:queue_name, :client, default_workflow_opts: [], default_worker_opts: []]

  alias Temporal.Client
  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.CoreSdk.Data.WorkflowDefinition
  alias Temporal.CoreSdk.Data.WorkflowStartOptions
  alias Temporal.CoreSdk.Data.WorkflowArguments
  alias Temporal.Workflows.WorkflowExecHandle
  alias Temporal.Workflows.WorkflowName

  @type t() :: %__MODULE__{
          queue_name: String.t(),
          client: Client.t(),
          default_workflow_opts: WorkflowStartOptions.opts()
        }

  @type opts :: [
          {:default_workflow_opts, WorkflowStartOptions.opts()}
          | {:default_worker_opts, WorkerOpts.opts()}
        ]

  @spec new(Client.t(), queue_name :: String.t(), opts()) :: t()
  def new(client, queue_name, opts \\ []) do
    %__MODULE__{
      client: client,
      queue_name: queue_name,
      default_workflow_opts: Keyword.get(opts, :default_workflow_opts, []),
      default_worker_opts: Keyword.get(opts, :default_worker_opts, [])
    }
  end

  @spec start_workflow(
          t(),
          workflow_id :: String.t(),
          workflow_name :: WorkflowName.t(),
          inputs :: [term()],
          opts :: WorkflowStartOptions.opts()
        ) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def start_workflow(queue, workflow_id, workflow_name, inputs, opts \\ []) do
    wf_server_name = WorkflowName.server_recognized_name(workflow_name)
    workflow_def = WorkflowDefinition.with_opts!(name: wf_server_name)

    opts = queue.default_workflow_opts ++ opts
    opts = opts ++ [workflow_id: workflow_id, task_queue: queue.queue_name]
    start_opts = WorkflowStartOptions.with_opts!(opts)

    with :ok <- validate_workflow_inputs(workflow_name, inputs) do
      args = WorkflowArguments.with_opts!(args: inputs)

      parent = self()

      {pid, ref} =
        spawn_monitor(fn ->
          with {:ok, runtime_core} <- Client.core_runtime(queue.client),
               {:ok, client_core} <- CoreClient.existing_for_identity(queue.client.identity) do
            CoreSdk._client_start_workflow(
              runtime_core.core,
              client_core.core,
              workflow_def,
              args,
              start_opts,
              self()
            )
          end
          |> case do
            :ok -> :ok
            {:error, err} -> raise "Could not start workflow via Core SDK: #{inspect(err)}"
          end

          receive do
            {:ok, workflow_handle} ->
              send(
                parent,
                {self(),
                 {:ok,
                  WorkflowExecHandle.new(
                    queue.client,
                    workflow_handle,
                    workflow_name: workflow_name,
                    workflow_id: workflow_id,
                    task_queue: queue.queue_name
                  )}}
              )

            {:error, err} ->
              send(parent, {self(), {:error, err}})
          end
        end)

      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end
    end
  end

  @spec validate_workflow_inputs(WorkflowName.t(), [term()]) :: :ok | {:error, term()}
  defp validate_workflow_inputs(workflow_name, inputs) do
    case WorkflowName.execution_arities(workflow_name) do
      {:ok, arities} ->
        given_arity = Enum.count(inputs)
        arity_with_ctx = given_arity + 1

        if Enum.member?(arities, arity_with_ctx) do
          :ok
        else
          server_name = WorkflowName.server_recognized_name(workflow_name)
          {:error, "#{server_name} workflow does not implement execute/#{given_arity + 1}"}
        end

      {:error, :unknown} ->
        :ok
    end
  end
end
