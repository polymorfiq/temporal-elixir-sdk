defmodule Temporal.CoreSdk.CoreWorker do
  defstruct [:worker]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.CoreClient
  alias Temporal.CoreSdk.Data.WorkerOpts
  alias CoreSdk.Data.WorkflowActivation
  alias CoreSdk.Data.ActivityTask
  alias CoreSdk.Data.NexusTask

  @create_worker_message_prefix :worker_creation
  @validate_message_prefix :worker_validation
  @workflow_activations_poll_message_prefix :worker_workflow_activations_poll
  @activity_tasks_poll_message_prefix :worker_activity_tasks_poll
  @nexus_tasks_poll_message_prefix :worker_nexus_tasks_poll

  @type t :: %__MODULE__{
          worker: term()
        }

  @spec new(runtime :: CoreRuntime.t(), client :: CoreClient.t(), opts :: WorkerOpts.t()) ::
          {:ok, t()} | {:error, term()}
  def new(runtime, client, opts) do
    create_worker_async(runtime, client, opts)

    worker_resp =
      receive do
        {@create_worker_message_prefix, resp} -> resp
      end

    with {:ok, worker_ref} <- worker_resp,
         :ok <- validate(worker_ref, runtime) do
      {:ok, %__MODULE__{worker: worker_ref}}
    end
  end

  defp create_worker_async(runtime, client, opts) do
    parent = self()

    spawn_link(fn ->
      CoreSdk._create_worker(runtime.runtime, client.client, opts, self())

      receive do
        {:ok, worker} ->
          send(parent, {@create_worker_message_prefix, {:ok, worker}})

        {:error, err} ->
          send(parent, {@create_worker_message_prefix, {:error, err}})
      end
    end)
  end

  @spec validate(worker_ref :: term(), CoreRuntime.t()) :: :ok | {:error, term()}
  def validate(worker_ref, runtime) do
    validate_async(worker_ref, runtime)

    validate_resp =
      receive do
        {@validate_message_prefix, resp} -> resp
      end

    case validate_resp do
      :ok -> :ok
      {:error, err} -> {:error, "Validation error: #{inspect(err)}"}
    end
  end

  @spec validate_async(worker_ref :: term(), runtime :: CoreRuntime.t()) :: :ok | {:error, term()}
  defp validate_async(worker_ref, runtime) do
    parent = self()

    spawn_link(fn ->
      CoreSdk._validate_worker(runtime.runtime, worker_ref, self())

      receive do
        {:ok, _} ->
          send(parent, {@validate_message_prefix, :ok})

        {:error, err} ->
          send(parent, {@validate_message_prefix, {:error, {:connection_error, err}}})
      end
    end)
  end

  @spec poll_workflow_activations(t(), CoreRuntime.t()) ::
          {:ok, WorkflowActivation.t() | nil} | {:error, term()}
  def poll_workflow_activations(worker, runtime) do
    poll_workflow_activations_async(worker, runtime)

    validate_resp =
      receive do
        {@workflow_activations_poll_message_prefix, resp} -> resp
      end

    case validate_resp do
      {:ok, activation} -> {:ok, activation}
      {:error, err} -> {:error, "Workflow activation poll error: #{inspect(err)}"}
    end
  end

  @spec poll_workflow_activations_async(worker :: t(), runtime :: CoreRuntime.t()) ::
          :ok | {:error, term()}
  def poll_workflow_activations_async(worker, runtime) do
    parent = self()

    spawn_link(fn ->
      CoreSdk._worker_poll_workflow_activation(runtime.runtime, worker.worker, self())

      receive do
        {:ok, activation} ->
          send(parent, {@workflow_activations_poll_message_prefix, {:ok, activation}})

        {:error, err} ->
          send(parent, {@workflow_activations_poll_message_prefix, {:error, err}})
      end
    end)
  end

  @spec poll_activity_tasks(t(), CoreRuntime.t()) ::
          {:ok, ActivityTask.t() | nil} | {:error, term()}
  def poll_activity_tasks(worker, runtime) do
    poll_activity_tasks_async(worker, runtime)

    validate_resp =
      receive do
        {@activity_tasks_poll_message_prefix, resp} -> resp
      end

    case validate_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Activity task poll error: #{inspect(err)}"}
    end
  end

  @spec poll_activity_tasks_async(worker :: t(), runtime :: CoreRuntime.t()) ::
          :ok | {:error, term()}
  def poll_activity_tasks_async(worker, runtime) do
    parent = self()

    spawn_link(fn ->
      CoreSdk._worker_poll_activity_task(runtime.runtime, worker.worker, self())

      receive do
        {:ok, task} ->
          send(parent, {@activity_tasks_poll_message_prefix, {:ok, task}})

        {:error, err} ->
          send(parent, {@activity_tasks_poll_message_prefix, {:error, err}})
      end
    end)
  end

  @spec poll_nexus_tasks(t(), CoreRuntime.t()) :: {:ok, NexusTask.t() | nil} | {:error, term()}
  def poll_nexus_tasks(worker, runtime) do
    poll_nexus_tasks_async(worker, runtime)

    validate_resp =
      receive do
        {@nexus_tasks_poll_message_prefix, resp} -> resp
      end

    case validate_resp do
      {:ok, task} -> {:ok, task}
      {:error, err} -> {:error, "Nexus task poll error: #{inspect(err)}"}
    end
  end

  @spec poll_nexus_tasks_async(worker :: t(), runtime :: CoreRuntime.t()) ::
          :ok | {:error, term()}
  def poll_nexus_tasks_async(worker, runtime) do
    parent = self()

    spawn_link(fn ->
      CoreSdk._worker_poll_nexus_task(runtime.runtime, worker.worker, self())

      receive do
        {:ok, task} ->
          send(parent, {@nexus_tasks_poll_message_prefix, {:ok, task}})

        {:error, err} ->
          send(parent, {@nexus_tasks_poll_message_prefix, {:error, err}})
      end
    end)
  end
end
