defmodule TemporalEngineNif.Core do
  use Rustler,
    otp_app: :temporal_engine_nif,
    crate: :temporalcoresdk

  alias TemporalEngineNif.Data
  alias TemporalEngineNif.Data.ClientOpts
  alias TemporalEngineNif.Data.RuntimeOpts
  alias TemporalEngineNif.Data.WorkerOpts
  alias TemporalEngineNif.Data.ActivityTaskCompletion
  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Opts.WorkflowOpts.WorkflowDefinition
  alias TemporalEngine.Opts.WorkflowOpts.WorkflowStartOpts

  @doc false
  @spec _create_runtime(opts :: RuntimeOpts.t()) :: {:ok, term()} | {:error, term()}
  def _create_runtime(_opts \\ nil), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_client(runtime :: term(), opts :: ClientOpts.t(), resp_pid :: pid()) ::
          {:ok, bool()} | {:error, term()}
  def _create_client(_runtime, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _create_worker(
          runtime :: term(),
          client :: term(),
          opts :: WorkerOpts.t(),
          resp_pid :: pid()
        ) ::
          {:ok, bool()} | {:error, term()}
  def _create_worker(_runtime, _client, _opts, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _validate_worker(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, term()} | {:error, term()}
  def _validate_worker(_runtime, _worker, _resp_pid), do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_workflow_activation(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, bool()} | {:error, term()}
  def _worker_poll_workflow_activation(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_activity_task(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, bool()} | {:error, term()}
  def _worker_poll_activity_task(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_poll_nexus_task(runtime :: term(), worker :: term(), resp_pid :: pid()) ::
          {:ok, bool()} | {:error, term()}
  def _worker_poll_nexus_task(_runtime, _worker, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_complete_workflow_activation(
          runtime :: term(),
          worker :: term(),
          completion :: Temporal.CoreSdk.Data.WorkflowActivationCompletion.t(),
          resp_pid :: pid()
        ) ::
          {:ok, bool()} | {:error, term()}
  def _worker_complete_workflow_activation(_runtime, _worker, _completion, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_complete_activity_task(
          runtime :: term(),
          worker :: term(),
          completion :: ActivityTaskCompletion.t(),
          resp_pid :: pid()
        ) ::
          {:ok, bool()} | {:error, term()}
  def _worker_complete_activity_task(_runtime, _worker, _completion, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _client_start_workflow(
          runtime :: term(),
          client :: term(),
          workflow :: WorkflowDefinition.t(),
          input :: [Data.WorkflowInput.t()],
          opts :: WorkflowStartOpts.t(),
          resp_pid :: pid()
        ) ::
          {:ok, bool()} | {:error, term()}
  def _client_start_workflow(_runtime, _client, _workflow, _input, _opts, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _handle_query_workflow(
          runtime :: term(),
          handle :: WorkflowHandle.t(),
          query :: Queries.workflow_query(),
          query_reject_condition :: Queries.query_reject_condition(),
          resp_pid :: pid()
        ) :: {:ok, Queries.query_workflow_response()} | {:error, term()}
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
          opts :: Data.SdkWorkflowGetResultOptions.t(),
          resp_pid :: pid()
        ) ::
          {:ok, bool()} | {:error, term()}
  def _workflow_handle_get_result(_runtime, _workflow_handle, _opts, _resp_pid),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_initiate_shutdown(worker :: term()) ::
          {:ok, bool()} | {:error, term()}
  def _worker_initiate_shutdown(_worker),
    do: :erlang.nif_error(:nif_not_loaded)

  @doc false
  @spec _worker_finalize_shutdown(worker :: term()) ::
          {:ok, bool()} | {:error, term()}
  def _worker_finalize_shutdown(_worker),
    do: :erlang.nif_error(:nif_not_loaded)
end
