defmodule Temporal.Comms.Shared.FailureInfo do
  defstruct []

  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Duration

  defmodule Application do
    defstruct [
      :failure_type,
      :non_retryable,
      category: :unspecified,
      details: nil,
      next_retry_delay: nil
    ]

    @type category :: :unspecified | :benign
    @type t :: %__MODULE__{
            failure_type: String.t(),
            non_retryable: bool(),
            details: Payload.t(),
            next_retry_delay: Duration.t() | nil,
            category: category()
          }

    @type failure_type :: String.t()
    @type application :: {:application, failure_type(), category(), opts()}
    @type opts :: [
            {:non_retryable, bool()}
            | {:details, Payload.payload()}
            | {:next_retry_delay, Duration.duration()}
          ]

    @spec send_to_sdk(t()) :: application()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:details] do
          update_in(opts, [:details], &Payload.send_to_sdk/1)
        else
          opts
        end

      opts =
        if opts[:next_retry_delay] do
          update_in(opts, [:next_retry_delay], &Duration.send_to_sdk/1)
        else
          opts
        end

      opts = opts |> Keyword.new() |> Keyword.drop([:failure_type, :category])
      {:application, info.failure_type, info.category, opts}
    end

    @spec send_to_engine(application()) :: t()
    def send_to_engine({:application, failure_type, category, opts}) do
      opts = Keyword.merge(opts, failure_type: failure_type, category: category) |> Map.new()

      opts =
        if opts[:details] do
          update_in(opts, [:details], &Payload.send_to_engine/1)
        else
          opts
        end

      opts =
        if opts[:next_retry_delay] do
          update_in(opts, [:next_retry_delay], &Duration.send_to_engine/1)
        else
          opts
        end

      struct!(__MODULE__, opts)
    end
  end

  defmodule Timeout do
    defstruct timeout_type: :unspecified,
              last_heartbeat_details: nil

    @type t :: %__MODULE__{
            timeout_type: timeout_type(),
            last_heartbeat_details: Payload.t() | nil
          }

    @type timeout_info ::
            {:timeout, timeout_type(), [{:last_heartbeat_details, Payload.payload()}]}
    @type timeout_type ::
            :unspecified | :start_to_close | :schedule_to_start | :schedule_to_close | :heartbeat

    @spec send_to_sdk(t()) :: timeout_info()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:last_heartbeat_details] do
          update_in(opts, [:last_heartbeat_details], &Payload.send_to_sdk/1)
        else
          opts
        end

      opts = opts |> Keyword.new() |> Keyword.drop([:timeout_type])
      {:timeout, info.timeout_type, opts}
    end

    @spec send_to_engine(timeout_info()) :: t()
    def send_to_engine({:timeout, timeout_type, opts}) do
      opts = Keyword.merge(opts, timeout_type: timeout_type) |> Map.new()

      opts =
        if opts[:last_heartbeat_details] do
          update_in(opts, [:last_heartbeat_details], &Payload.send_to_engine/1)
        else
          opts
        end

      struct!(__MODULE__, opts)
    end
  end

  defmodule Cancelled do
    defstruct [
      :identity,
      details: nil
    ]

    @type t :: %__MODULE__{
            identity: String.t(),
            details: Payload.t() | nil
          }

    @type cancelled :: {:cancelled, identity(), [{:details, Payload.payload()}]}
    @type identity :: String.t()

    @spec send_to_sdk(t()) :: cancelled()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:details] do
          update_in(opts, [:details], &Payload.send_to_sdk/1)
        else
          opts
        end

      opts = opts |> Keyword.new() |> Keyword.drop([:identity])
      {:cancelled, info.identity, opts}
    end

    @spec send_to_engine(cancelled()) :: t()
    def send_to_engine({:cancelled, identity, opts}) do
      opts = Keyword.merge(opts, identity: identity) |> Map.new()

      opts =
        if opts[:details] do
          update_in(opts, [:details], &Payload.send_to_engine/1)
        else
          opts
        end

      struct!(__MODULE__, opts)
    end
  end

  defmodule Terminated do
    defstruct [
      :identity
    ]

    @type t :: %__MODULE__{
            identity: String.t()
          }

    @type terminated :: {:terminated, identity()}
    @type identity :: String.t()

    @spec send_to_sdk(t()) :: terminated()
    def send_to_sdk(info) do
      {:terminated, info.identity}
    end

    @spec send_to_engine(terminated()) :: t()
    def send_to_engine({:terminated, identity}) do
      %__MODULE__{identity: identity}
    end
  end

  defmodule Server do
    defstruct [:non_retryable]

    @type t :: %__MODULE__{
            non_retryable: bool()
          }

    @type server :: {:server, [{:non_retryable, bool()}]}

    @spec send_to_sdk(t()) :: server()
    def send_to_sdk(info) do
      {:server, [non_retryable: info.non_retryable]}
    end

    @spec send_to_engine(server()) :: t()
    def send_to_engine({:server, opts}) do
      struct!(__MODULE__, opts)
    end
  end

  defmodule ResetWorkflow do
    defstruct last_heartbeat_details: nil

    @type t :: %__MODULE__{
            last_heartbeat_details: Payload.t() | nil
          }
    @type reset_workflow :: {:reset_workflow, [{:last_heartbeat_details, bool()}]}

    @spec send_to_sdk(t()) :: reset_workflow()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:last_heartbeat_details] do
          update_in(opts, [:last_heartbeat_details], &Payload.send_to_engine/1)
        else
          opts
        end

      {:reset_workflow, Keyword.new(opts)}
    end

    @spec send_to_engine(reset_workflow()) :: t()
    def send_to_engine({:reset_workflow, opts}) do
      opts = Map.new(opts)

      opts =
        if opts[:last_heartbeat_details] do
          update_in(opts, [:last_heartbeat_details], &Payload.send_to_engine/1)
        else
          opts
        end

      struct!(__MODULE__, Keyword.new(opts))
    end
  end

  defmodule Activity do
    defstruct [
      :scheduled_event_id,
      :started_event_id,
      :identity,
      :activity_id,
      retry_state: :unspecified,
      activity_type: nil
    ]

    defmodule ActivityType do
      defstruct [:name]

      @type t :: %__MODULE__{name: String.t()}
    end

    @type t :: %__MODULE__{
            scheduled_event_id: integer(),
            started_event_id: integer(),
            identity: String.t(),
            activity_type: ActivityType.t() | nil,
            activity_id: String.t(),
            retry_state: integer()
          }

    @type activity :: {:activity, activity_type(), retry_state(), activity_id(), opts()}

    @type retry_state ::
            :unspecified
            | :in_progress
            | :non_retryable_failure
            | :timeout
            | :maximum_attempts_reached
            | :retry_policy_not_set
            | :internal_server_error
            | :cancel_requested

    @type activity_type :: String.t()
    @type activity_id :: String.t()
    @type opts :: [
            {:scheduled_event_id, integer(), {:started_event_id, integer()},
             {:identity, String.t()}}
          ]

    @spec send_to_sdk(t()) :: activity()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:activity_type] do
          update_in(opts, [:activity_type], & &1.name)
        else
          opts
        end

      opts = opts |> Keyword.new() |> Keyword.drop([:activity_type, :retry_state, :activity_id])
      {:activity, opts[:activity_type], info.retry_state, info.activity_id, opts}
    end

    @spec send_to_engine(activity()) :: t()
    def send_to_engine({:activity, activity_type, retry_state, activity_id, opts}) do
      opts =
        Keyword.merge(opts,
          activity_type: activity_type,
          retry_state: retry_state,
          activity_id: activity_id
        )
        |> Map.new()

      opts =
        if activity_type = opts[:activity_type] do
          Map.put(opts, :activity_type, %ActivityType{name: activity_type})
        else
          opts
        end

      struct!(__MODULE__, Keyword.new(opts))
    end
  end

  defmodule ChildExecution do
    defstruct [
      :namespace,
      :initiated_event_id,
      :started_event_id,
      :retry_state,
      workflow_execution: nil,
      workflow_type: nil
    ]

    alias Temporal.Comms.Workflows.WorkflowExecution

    defmodule WorkflowType do
      defstruct [:name]

      @type t :: %__MODULE__{name: String.t()}
    end

    @type t :: %__MODULE__{
            namespace: String.t(),
            workflow_execution: WorkflowExecution.t() | nil,
            workflow_type: WorkflowType.t() | nil,
            initiated_event_id: integer(),
            started_event_id: integer(),
            retry_state: integer()
          }

    @type child_execution :: {:activity, namespace(), workflow_type(), retry_state(), opts()}
    @type namespace :: String.t()
    @type workflow_type :: String.t()
    @type retry_state ::
            :unspecified
            | :in_progress
            | :non_retryable_failure
            | :timeout
            | :maximum_attempts_reached
            | :retry_policy_not_set
            | :internal_server_error
            | :cancel_requested

    @type opts :: [
            {:workflow_execution, WorkflowExecution.execution()}
            | {:initiated_event_id, integer()}
            | {:started_event_id, integer()}
          ]

    @spec send_to_sdk(t()) :: child_execution()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct()

      opts =
        if opts[:workflow_execution] do
          update_in(opts, [:workflow_execution], &WorkflowExecution.send_to_sdk/1)
        else
          opts
        end

      workflow_type =
        if wf_type = opts[:workflow_type] do
          wf_type.name
        end

      opts = opts |> Keyword.new() |> Keyword.drop([:namespace, :workflow_type, :retry_state])
      {:child_execution, info.namespace, workflow_type, info.retry_state, opts}
    end

    @spec send_to_engine(child_execution()) :: t()
    def send_to_engine({:child_execution, namespace, workflow_type, retry_state, opts}) do
      opts =
        Keyword.merge(opts,
          namespace: namespace,
          workflow_type: workflow_type,
          retry_state: retry_state
        )
        |> Map.new()

      opts =
        if opts[:workflow_execution] do
          update_in(opts, [:workflow_execution], &WorkflowExecution.send_to_engine/1)
        else
          opts
        end

      opts =
        if workflow_type = opts[:workflow_type] do
          Map.put(opts, :workflow_type, %WorkflowType{name: workflow_type})
        else
          opts
        end

      opts = Keyword.new(opts)
      struct!(__MODULE__, opts)
    end
  end

  defmodule NexusOperation do
    defstruct [
      :scheduled_event_id,
      :endpoint,
      :service,
      :operation,
      :operation_id,
      :operation_token
    ]

    @type t :: %__MODULE__{
            scheduled_event_id: integer(),
            endpoint: String.t(),
            service: String.t(),
            operation: String.t(),
            operation_id: String.t(),
            operation_token: String.t()
          }

    @type nexus_operation :: {:nexus_operation, service(), operation(), opts()}
    @type service :: String.t()
    @type operation :: String.t()
    @type opts :: [
            {:endpoint, String.t()}
            | {:operation_id, String.t()}
            | {:operation_token, String.t()}
            | {:scheduled_event_id, integer()}
          ]

    @spec send_to_sdk(t()) :: nexus_operation()
    def send_to_sdk(info) do
      opts = info |> Map.from_struct() |> Keyword.new() |> Keyword.drop([:service, :operation])

      {:nexus_operation, info.service, info.operation, opts}
    end

    @spec send_to_engine(nexus_operation()) :: t()
    def send_to_engine({:nexus_operation, service, operation, opts}) do
      opts = Keyword.merge(opts, service: service, operation: operation)
      struct!(__MODULE__, opts)
    end
  end

  defmodule NexusHandler do
    defstruct [
      :failure_type,
      retry_behavior: :unspecified
    ]

    @type retry_behavior :: :unspecified | :retryable | :non_retryable
    @type t :: %__MODULE__{failure_type: String.t(), retry_behavior: retry_behavior()}
    @type nexus_handler :: {:nexus_handler, retry_behavior(), failure_type :: String.t()}

    @spec send_to_sdk(t()) :: nexus_handler()
    def send_to_sdk(info) do
      {:nexus_handler, info.retry_behavior, info.failure_type}
    end

    @spec send_to_engine(nexus_handler()) :: t()
    def send_to_engine({:nexus_handler, retry_behavior, failure_type}) do
      %__MODULE__{retry_behavior: retry_behavior, failure_type: failure_type}
    end
  end

  @type failure_info ::
          Application.application()
          | Timeout.timeout_info()
          | Cancelled.cancelled()
          | Terminated.terminated()
          | Server.server()
          | ResetWorkflow.reset_workflow()
          | Activity.activity()
          | ChildExecution.child_execution()
          | NexusOperation.nexus_operation()
          | NexusHandler.nexus_handler()

  @type t ::
          {:application, Application.t()}
          | {:timeout, Timeout.t()}
          | {:cancelled, Cancelled.t()}
          | {:terminated, Terminated.t()}
          | {:server, Server.t()}
          | {:reset_workflow, ResetWorkflow.t()}
          | {:activity, Activity.t()}
          | {:child_execution, ChildExecution.t()}
          | {:nexus_operation, NexusOperation.t()}
          | {:nexus_handler, NexusHandler.t()}

  @spec send_to_sdk(t()) :: failure_info()
  def send_to_sdk({:application, app}), do: Application.send_to_sdk(app)
  def send_to_sdk({:timeout, app}), do: Timeout.send_to_sdk(app)
  def send_to_sdk({:cancelled, app}), do: Cancelled.send_to_sdk(app)
  def send_to_sdk({:terminated, app}), do: Terminated.send_to_sdk(app)
  def send_to_sdk({:server, app}), do: Server.send_to_sdk(app)
  def send_to_sdk({:reset_workflow, app}), do: ResetWorkflow.send_to_sdk(app)
  def send_to_sdk({:activity, app}), do: Activity.send_to_sdk(app)
  def send_to_sdk({:child_execution, app}), do: ChildExecution.send_to_sdk(app)
  def send_to_sdk({:nexus_operation, app}), do: NexusOperation.send_to_sdk(app)
  def send_to_sdk({:nexus_handler, app}), do: NexusHandler.send_to_sdk(app)

  @spec send_to_engine(failure_info()) :: t()
  def send_to_engine(tuple) when is_tuple(tuple), do: send_to_engine(elem(tuple, 0), tuple)
  def send_to_engine(:application, tuple), do: Application.send_to_engine(tuple)
  def send_to_engine(:timeout, tuple), do: Timeout.send_to_engine(tuple)
  def send_to_engine(:cancelled, tuple), do: Cancelled.send_to_engine(tuple)
  def send_to_engine(:terminated, tuple), do: Terminated.send_to_engine(tuple)
  def send_to_engine(:server, tuple), do: Server.send_to_engine(tuple)
  def send_to_engine(:reset_workflow, tuple), do: ResetWorkflow.send_to_engine(tuple)
  def send_to_engine(:activity, tuple), do: Activity.send_to_engine(tuple)
  def send_to_engine(:child_execution, tuple), do: ChildExecution.send_to_engine(tuple)
  def send_to_engine(:nexus_operation, tuple), do: NexusOperation.send_to_engine(tuple)
  def send_to_engine(:nexus_handler, tuple), do: NexusHandler.send_to_engine(tuple)
end
