defmodule TemporalEngineNif.Core do
  use Rustler,
    otp_app: :temporal_engine_nif,
    crate: :temporalcoresdk

  require TemporalEngine.Data.ActivationCompletion
  require TemporalEngine.Data.ActivityTaskCompletion
  require TemporalEngine.Data.Payload
  require TemporalEngine.Config
  require TemporalEngine.Opts.ClientOpts
  require TemporalEngine.Opts.HandleOpts
  require TemporalEngine.Opts.WorkflowOpts

  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngine.Config
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.ActivityTaskCompletion
  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Opts.ClientOpts
  alias TemporalEngine.Opts.HandleOpts
  alias TemporalEngine.Opts.WorkflowOpts

  @doc false
  @spec _create_runtime(opts :: ClientOpts.runtime_opts()) :: {:ok, term()} | {:error, term()}
  def _create_runtime(_opts), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_client(runtime :: term(), opts :: ClientOpts.connection_opts(), resp_pid :: pid()) ::
          :ok | {:error, term()}
  def _create_client(_runtime, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_worker(
          runtime :: term(),
          client :: term(),
          opts :: Config.worker_config(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _create_worker(_runtime, _client, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _validate_worker(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          :ok | {:error, term()}
  def _validate_worker(_runtime, _worker, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_workflow_activation(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          :ok | {:error, term()}
  def _worker_poll_workflow_activation(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_activity_task(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          :ok | {:error, term()}
  def _worker_poll_activity_task(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_nexus_task(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          :ok | {:error, term()}
  def _worker_poll_nexus_task(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_complete_workflow_activation(
          runtime :: term(),
          worker :: term(),
          completion :: ActivationCompletion.completion(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _worker_complete_workflow_activation(_runtime, _worker, _completion, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_complete_activity_task(
          runtime :: term(),
          worker :: term(),
          completion :: ActivityTaskCompletion.task_completion(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _worker_complete_activity_task(_runtime, _worker, _completion, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _client_start_workflow(
          runtime :: term(),
          client :: term(),
          workflow :: WorkflowOpts.workflow_definition(),
          input :: Payload.workflow_arguments(),
          opts :: WorkflowOpts.workflow_start_opts(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _client_start_workflow(_runtime, _client, _workflow, _input, _opts, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _handle_query_workflow(
          runtime :: term(),
          handle :: WorkflowHandle.t(),
          query :: Queries.workflow_query(),
          query_reject_condition :: Queries.query_reject_condition(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _handle_query_workflow(
        _runtime,
        _handle,
        _query,
        _query_reject_condition,
        _resp_pid
      ),
      do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _workflow_handle_get_result(
          runtime :: term(),
          workflow_handle :: term(),
          opts :: HandleOpts.get_workflow_result_opts(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _workflow_handle_get_result(_runtime, _workflow_handle, _opts, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_initiate_shutdown(worker :: term()) :: :ok | {:error, term()}
  def _worker_initiate_shutdown(_worker),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_finalize_shutdown(worker :: term()) :: :ok | {:error, term()}
  def _worker_finalize_shutdown(_worker),
    do: :erlang.nif_error(:nif_not_loaded)
end
