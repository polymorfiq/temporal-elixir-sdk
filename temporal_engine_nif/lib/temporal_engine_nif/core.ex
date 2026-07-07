defmodule TemporalEngineNif.Core do
  use Rustler,
    otp_app: :temporal_engine_nif,
    crate: :temporalcoresdk

  require TemporalEngine.Data.ActivationCompletion
  require TemporalEngine.Data.ActivityTaskCompletion
  require TemporalEngine.Data.Payload
  require TemporalEngine.Data.Updates
  require TemporalEngine.Config
  require TemporalEngine.Opts.ClientOpts
  require TemporalEngine.Opts.HandleOpts
  require TemporalEngine.Opts.WorkflowOpts

  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngine.Config
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.ActivityTaskCompletion
  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Updates
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
  @spec _client_get_workflow_handle(
          runtime :: term(),
          client :: term(),
          workflow_id :: String.t(),
          run_id :: String.t() | nil,
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _client_get_workflow_handle(_runtime, _client, _workflow_id, run_id, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _client_list_workflows(
          runtime :: term(),
          client :: term(),
          query :: String.t(),
          limit :: pos_integer() | nil,
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _client_list_workflows(_runtime, _client, _query, _limit, _resp_pid),
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
  @spec _handle_update_workflow(
          runtime :: term(),
          handle :: WorkflowHandle.t(),
          update_id :: String.t(),
          request :: Updates.workflow_update(),
          wait_policy :: Updates.update_wait_policy(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _handle_update_workflow(
        _runtime,
        _handle,
        _update_id,
        _request,
        _wait_policy,
        _resp_pid
      ),
      do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _handle_signal_workflow(
          runtime :: term(),
          handle :: WorkflowHandle.t(),
          signal :: Updates.workflow_update(),
          resp_pid :: pid()
        ) :: :ok | {:error, term()}
  def _handle_signal_workflow(
        _runtime,
        _handle,
        _signal,
        _resp_pid
      ),
      do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _workflow_handle_get_result(
          runtime :: term(),
          workflow_handle :: term(),
          opts :: HandleOpts.get_workflow_result(),
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

  @doc false
  @spec _worker_record_activity_heartbeat(worker :: term(), task_token :: String.t(),
          payloads: [Payload.payload()]
        ) :: :ok
  def _worker_record_activity_heartbeat(_worker, _task_token, _payloads),
    do: :erlang.nif_error(:nif_not_loaded)
end
