defmodule Temporal.TaskQueue do
  defstruct [:queue_name, :client, default_workflow_opts: []]

  alias Temporal.Client
  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.Data.Callback
  alias Temporal.CoreSdk.Data.Link
  alias Temporal.CoreSdk.Data.WorkflowDefinition
  alias Temporal.CoreSdk.Data.WorkflowStartOptions
  alias Temporal.CoreSdk.Data.WorkflowArguments
  alias Temporal.CoreSdk.Data.WorkflowInput
  alias Temporal.CoreSdk.Data.ClientPriority
  alias Temporal.Workflows.WorkflowExecHandle
  alias Temporal.Workflows.WorkflowName

  @type t() :: %__MODULE__{
          queue_name: String.t(),
          client: Client.t(),
          default_workflow_opts: workflow_opts()
        }

  @type workflow_opts :: [
          {:id_reuse_policy, WorkflowStartOptions.id_reuse_policy()}
          | {:id_conflict_policy, WorkflowStartOptions.id_conflict_policy()}
          | {:enable_eager_workflow_start, bool()}
          | {:links, [Link.t()]}
          | {:completion_callbacks, [Callback.t()]}
          | {:priority, ClientPriority.t()}
        ]

  @type queue_opts :: [
          {:default_workflow_opts, workflow_opts()}
        ]

  @spec new(Client.t(), queue_name :: String.t(), queue_opts()) :: t()
  def new(client, queue_name, opts \\ []) do
    %__MODULE__{
      client: client,
      queue_name: queue_name,
      default_workflow_opts: Keyword.get(opts, :default_workflow_opts, [])
    }
  end

  @spec start_workflow(
          t(),
          workflow_id :: String.t(),
          workflow_name :: WorkflowName.t(),
          inputs :: [term()],
          opts :: workflow_opts()
        ) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def start_workflow(queue, workflow_id, workflow_name, inputs, opts \\ []) do
    opts = queue.default_workflow_opts ++ opts

    with :ok <- validate_workflow_inputs(workflow_name, inputs) do
      args =
        Enum.map(inputs, fn
          {:bytes, val} -> {:bytes, val}
          input -> WorkflowInput.new(input)
        end)

      parent = self()

      {pid, ref} =
        spawn_monitor(fn ->
          with {:ok, runtime_core} <- Client.core_runtime(queue.client),
               {:ok, client_core} <- Client.core_for_identity(queue.client.identity) do
            CoreSdk._client_start_workflow(
              runtime_core.core,
              client_core.core,
              %WorkflowDefinition{name: WorkflowName.server_recognized_name(workflow_name)},
              %WorkflowArguments{args: args},
              %WorkflowStartOptions{
                task_queue: queue.queue_name,
                workflow_id: workflow_id,
                id_reuse_policy: Keyword.get(opts, :id_reuse_policy, :unspecified),
                id_conflict_policy: Keyword.get(opts, :id_conflict_policy, :unspecified),
                enable_eager_workflow_start:
                  Keyword.get(opts, :enable_eager_workflow_start, false),
                links: Keyword.get(opts, :links, []),
                completion_callbacks: Keyword.get(opts, :completion_callbacks, []),
                priority:
                  Keyword.get(opts, :priority, %ClientPriority{
                    priority_key: 0,
                    fairness_key: "",
                    fairness_weight: 1.0
                  })
              },
              self()
            )
          end
          |> case do
            {:ok, _} -> :ok
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
