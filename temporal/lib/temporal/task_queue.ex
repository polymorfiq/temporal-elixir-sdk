defmodule Temporal.TaskQueue do
  defstruct [:queue_name, :client, default_workflow_opts: [], default_worker_opts: []]

  alias Temporal.Client
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias Temporal.Workflows.WorkflowName
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Opts.WorkflowOpts

  @type t() :: %__MODULE__{
          queue_name: String.t(),
          client: Client.t(),
          default_workflow_opts: WorkflowOpts.workflow_start_opts_opts()
        }

  @type opts :: [
          {:default_workflow_opts, WorkflowOpts.workflow_start_opts_opts()}
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
          opts :: WorkflowOpts.workflow_start_opts_opts()
        ) :: {:ok, WorkflowExecHandle.t()} | {:error, term()}
  def start_workflow(queue, workflow_id, workflow_name, inputs, opts \\ []) do
    wf_server_name =
      case workflow_name do
        {workflow_name, execute_fn} ->
          WorkflowName.server_recognized_name(workflow_name, execute_fn)

        _ ->
          WorkflowName.server_recognized_name(workflow_name, :execute)
      end

    workflow_def = WorkflowOpts.workflow_definition_from_opts!(name: wf_server_name)
    inputs = Enum.map(inputs, &Payload.record_from_value/1)

    opts = queue.default_workflow_opts ++ opts
    opts = opts ++ [workflow_id: workflow_id, task_queue: queue.queue_name]

    with {:ok, start_opts} <- WorkflowOpts.workflow_start_opts_from_opts(opts),
         {:ok, core_client} <- CoreClient.existing_for_identity(queue.client.identity),
         :ok <- validate_workflow_inputs(workflow_name, inputs) do
      TemporalEngine.Client.start_workflow(core_client.core, workflow_def, inputs, start_opts)
    end
  end

  @spec validate_workflow_inputs(WorkflowName.t(), [term()]) :: :ok | {:error, term()}
  defp validate_workflow_inputs(workflow_name, inputs) do
    {workflow_name, execute_fn} =
      case workflow_name do
        {name, execute} when is_atom(execute) ->
          {name, execute}

        workflow_name ->
          {workflow_name, :execute}
      end

    case WorkflowName.execution_arities(workflow_name, execute_fn) do
      {:ok, arities} ->
        given_arity = Enum.count(inputs)
        arity_with_ctx = given_arity + 1

        if Enum.member?(arities, arity_with_ctx) do
          :ok
        else
          server_name =
            case workflow_name do
              {workflow_name, execute_fn} ->
                WorkflowName.server_recognized_name(workflow_name, execute_fn)

              workflow_name ->
                WorkflowName.server_recognized_name(workflow_name, :execute)
            end

          {:error, "#{server_name} workflow does not implement execute/#{given_arity + 1}"}
        end

      {:error, :unknown} ->
        :ok
    end
  end
end
