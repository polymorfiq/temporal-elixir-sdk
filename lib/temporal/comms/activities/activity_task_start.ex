defmodule Temporal.Comms.Activities.ActivityTaskStart do
  defstruct [
    :workflow_namespace,
    :workflow_type,
    :activity_id,
    :activity_type,
    :header_fields,
    :input,
    :heartbeat_details,
    :attempt,
    :is_local,
    :run_id,
    workflow_execution: nil,
    scheduled_time: nil,
    current_attempt_scheduled_time: nil,
    started_time: nil,
    schedule_to_close_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ]

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Duration
  alias Temporal.Comms.Shared.Priority
  alias Temporal.Comms.Shared.RetryPolicy
  alias Temporal.Comms.Shared.Timestamp
  alias Temporal.Comms.Workflows.WorkflowExecution

  @type activity_task_start :: {:start, activity_id(), activity_type(), opts()}
  @type activity_id :: String.t()
  @type activity_type :: String.t()

  @type opts :: %{
          workflow_namespace: String.t(),
          workflow_type: String.t(),
          workflow_execution: WorkflowExecution.t() | nil,
          header_fields: map(),
          input: [Payload.t()],
          heartbeat_details: [Payload.t()],
          scheduled_time: Timestamp.t() | nil,
          current_attempt_scheduled_time: Timestamp.t() | nil,
          started_time: Timestamp.t() | nil,
          attempt: pos_integer(),
          schedule_to_close_timeout: Duration.t() | nil,
          start_to_close_timeout: Duration.t() | nil,
          heartbeat_timeout: Duration.t() | nil,
          retry_policy: RetryPolicy.t() | nil,
          priority: Priority.t(),
          is_local: bool(),
          run_id: String.t()
        }

  @type t :: %__MODULE__{
          workflow_namespace: String.t(),
          workflow_type: String.t(),
          workflow_execution: WorkflowExecution.t() | nil,
          activity_id: String.t(),
          activity_type: String.t(),
          header_fields: map(),
          input: [Payload.t()],
          heartbeat_details: [Payload.t()],
          scheduled_time: Timestamp.t() | nil,
          current_attempt_scheduled_time: Timestamp.t() | nil,
          started_time: Timestamp.t() | nil,
          attempt: pos_integer(),
          schedule_to_close_timeout: Duration.t() | nil,
          start_to_close_timeout: Duration.t() | nil,
          heartbeat_timeout: Duration.t() | nil,
          retry_policy: RetryPolicy.t() | nil,
          priority: Priority.t(),
          is_local: bool(),
          run_id: String.t()
        }

  @spec send_to_sdk(t()) :: activity_task_start()
  def send_to_sdk(%__MODULE__{} = start) do
    opts = start |> Map.from_struct()

    opts =
      if opts[:workflow_execution] do
        update_in(opts, [:workflow_execution], &WorkflowExecution.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:input] do
        update_in(opts, [:input], fn inputs -> Enum.map(inputs, &Payload.send_to_sdk/1) end)
      else
        opts
      end

    opts =
      if opts[:heartbeat_details] do
        update_in(opts, [:heartbeat_details], fn inputs ->
          Enum.map(inputs, &Payload.send_to_sdk/1)
        end)
      else
        opts
      end

    opts =
      if opts[:scheduled_time] do
        update_in(opts, [:scheduled_time], &Timestamp.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:current_attempt_scheduled_time] do
        update_in(opts, [:current_attempt_scheduled_time], &Timestamp.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:started_time] do
        update_in(opts, [:started_time], &Timestamp.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:schedule_to_close_timeout] do
        update_in(opts, [:schedule_to_close_timeout], &Duration.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:start_to_close_timeout] do
        update_in(opts, [:start_to_close_timeout], &Duration.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:heartbeat_timeout] do
        update_in(opts, [:heartbeat_timeout], &Duration.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:retry_policy] do
        update_in(opts, [:retry_policy], &RetryPolicy.send_to_sdk/1)
      else
        opts
      end

    opts =
      if opts[:priority] do
        update_in(opts, [:priority], &Priority.send_to_sdk/1)
      else
        opts
      end

    opts = opts |> Map.drop([:activity_id, :activity_types])
    {:start, start.activity_id, start.activity_type, opts}
  end
end
