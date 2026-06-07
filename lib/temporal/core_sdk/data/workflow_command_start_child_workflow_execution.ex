defmodule Temporal.CoreSdk.Data.WorkflowCommandStartChildWorkflowExecution do
  defstruct [
    :seq,
    :namespace,
    :workflow_id,
    :workflow_type,
    :task_queue,
    :input,
    :cron_schedule,
    :cancellation_type,
    headers: %{},
    memo: %{},
    workflow_id_reuse_policy: :unspecified,
    parent_close_policy: :unspecified,
    versioning_intent: :unspecified,
    workflow_execution_timeout: nil,
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    retry_policy: nil,
    search_attributes: nil,
    priority: nil
  ]

  alias Temporal.CoreSdk.Data

  @type workflow_id_reuse_policy ::
          :unspecified
          | :allow_duplicate
          | :allow_duplicate_failed_only
          | :reject_duplicate
          | :terminate_if_running
  @type parent_close_policy :: :unspecified | :terminate | :abandon | :request_cancel
  @type versioning_intent :: :unspecified | :compatible | :default
  @type cancellation_type ::
          :abandon | :try_cancel | :wait_cancellation_completed | :wait_cancellation_requested

  @type t :: %__MODULE__{
          seq: pos_integer(),
          namespace: String.t(),
          workflow_id: String.t(),
          workflow_type: String.t(),
          task_queue: String.t(),
          input: [Data.Payload.t()],
          workflow_execution_timeout: Data.Duration.t() | nil,
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          parent_close_policy: parent_close_policy(),
          workflow_id_reuse_policy: workflow_id_reuse_policy(),
          retry_policy: Data.RetryPolicy.t() | nil,
          cron_schedule: String.t(),
          headers: %{String.t() => Data.Payload.t()},
          memo: %{String.t() => Data.Payload.t()},
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          cancellation_type: cancellation_type(),
          versioning_intent: versioning_intent(),
          priority: Data.Priority.t() | nil
        }

  @type opts :: [
          {:seq, pos_integer()}
          | {:namespace, String.t()}
          | {:workflow_id, String.t()}
          | {:workflow_type, String.t()}
          | {:task_queue, String.t()}
          | {:input, [Data.Payload.opts()]}
          | {:workflow_execution_timeout, Data.Duration.opts()}
          | {:workflow_run_timeout, Data.Duration.opts()}
          | {:workflow_task_timeout, Data.Duration.opts()}
          | {:parent_close_policy, parent_close_policy()}
          | {:workflow_id_reuse_policy, workflow_id_reuse_policy()}
          | {:retry_policy, Data.RetryPolicy.opts()}
          | {:cron_schedule, String.t()}
          | {:headers, %{String.t() => Data.Payload.opts()}}
          | {:memo, %{String.t() => Data.Payload.opts()}}
          | {:search_attributes, Data.WorkflowSearchAttributes.opts()}
          | {:cancellation_type, cancellation_type()}
          | {:versioning_intent, versioning_intent()}
          | {:priority, Data.Priority.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    cmd = struct!(__MODULE__, opts)

    cmd =
      update_in(cmd, [Access.key(:input)], fn inputs ->
        Enum.map(inputs, &Data.Payload.with_opts!/1)
      end)

    cmd =
      update_in(cmd, [Access.key(:headers)], fn headers ->
        Map.new(headers, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    cmd =
      update_in(cmd, [Access.key(:memo)], fn memo ->
        Map.new(memo, fn {k, v} -> {k, Data.Payload.with_opts!(v)} end)
      end)

    cmd =
      if opts[:workflow_execution_timeout] do
        update_in(cmd, [Access.key(:workflow_execution_timeout)], &Data.Duration.with_opts!/1)
      else
        cmd
      end

    cmd =
      if opts[:workflow_run_timeout] do
        update_in(cmd, [Access.key(:workflow_run_timeout)], &Data.Duration.with_opts!/1)
      else
        cmd
      end

    cmd =
      if opts[:workflow_task_timeout] do
        update_in(cmd, [Access.key(:workflow_task_timeout)], &Data.Duration.with_opts!/1)
      else
        cmd
      end

    cmd =
      if opts[:retry_policy] do
        update_in(cmd, [Access.key(:retry_policy)], &Data.RetryPolicy.with_opts!/1)
      else
        cmd
      end

    cmd =
      if opts[:search_attributes] do
        update_in(
          cmd,
          [Access.key(:search_attributes)],
          &Data.WorkflowSearchAttributes.with_opts!/1
        )
      else
        cmd
      end

    cmd =
      if opts[:priority] do
        update_in(cmd, [Access.key(:priority)], &Data.Priority.with_opts!/1)
      else
        cmd
      end

    cmd
  end
end
