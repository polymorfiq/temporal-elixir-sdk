defmodule TemporalEngineNif.Worker do
  defstruct [:id, :core, :client, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Worker, for: TemporalEngineNif.Worker do
  require Logger

  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Data.ActivityTask
  alias TemporalEngineNif.Data.WorkflowActivation

  @impl true
  def poll_workflow_activation(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activations_poll, worker.id})

        Logger.debug("Polling workflow activations...")

        Core._worker_poll_workflow_activation(worker.runtime.core, worker.core, self())
        |> case do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling activity tasks: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, task}} ->
        {:ok, WorkflowActivation.to_record(task)}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def poll_activity_task(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activity_task_poll, worker.id})

        Logger.debug("Polling activity tasks...")

        Core._worker_poll_activity_task(worker.runtime.core, worker.core, self())
        |> case do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling activity tasks: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, task}} ->
        {:ok, ActivityTask.to_record(task)}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def poll_nexus_task(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_nexus_task_poll, worker.id})

        Logger.debug("Polling nexus tasks...")

        Core._worker_poll_nexus_task(worker.runtime.core, worker.core, self())
        |> case do
          :ok ->
            receive do
              {:ok, task} ->
                send(parent, {self(), {:ok, task}})

              {:error, error} ->
                send(parent, {self(), {:error, error}})
            end

          resp ->
            send(parent, {self(), {:error, "Error polling nexus tasks: #{inspect(resp)}"}})
        end
      end)

    receive do
      {^child, {:ok, task}} ->
        {:ok, task}

      {^child, {:error, err}} ->
        {:error, err}
    end
  end

  @impl true
  def complete_workflow_activation(worker, completion) do
    parent = self()

    child =
      spawn_link(fn ->
        Core._worker_complete_workflow_activation(
          worker.runtime.core,
          worker.core,
          completion,
          self()
        )
        |> case do
          :ok ->
            receive do
              {:ok, _} ->
                send(parent, {self(), :ok})

              {:error, err} ->
                send(parent, {self(), {:error, err}})
                Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
            end

          other_resp ->
            send(parent, {self(), other_resp})
        end
      end)

    receive do
      {^child, resp} ->
        resp
    end
  end

  @impl true
  def complete_activity_task(worker, completion) do
    parent = self()

    child =
      spawn_link(fn ->
        Core._worker_complete_activity_task(
          worker.runtime.core,
          worker.core,
          completion,
          self()
        )
        |> case do
             :ok ->
               receive do
                 {:ok, _} ->
                   send(parent, {self(), :ok})

                 {:error, err} ->
                   send(parent, {self(), {:error, err}})
                   Logger.error("Workflow Complete Activation Error - #{inspect(err)}")
               end

             other_resp ->
               send(parent, {self(), other_resp})
           end
      end)

    receive do
      {^child, resp} ->
        resp
    end
  end

  @impl true
  def initiate_shutdown(worker) do
    with :ok <- Core._worker_initiate_shutdown(worker.core) do
      Logger.debug("Worker (#{worker.id}) shutdown initiated.")
      :ok
    else
      {:error, err} ->
        Logger.error("Worker (#{worker.id}) error initiating shutdown - #{inspect(err)}")
        {:error, err}
    end
  end

  @impl true
  def finalize_shutdown(worker) do
    with :ok <- Core._worker_finalize_shutdown(worker.core) do
      Logger.debug("Worker (#{worker.id}) shutdown finalized.")
      :ok
    else
      {:error, err} ->
        Logger.error("Worker (#{worker.id}) error finalizing shutdown - #{inspect(err)}")
        {:error, err}
    end
  end
end
