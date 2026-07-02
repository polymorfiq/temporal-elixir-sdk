defmodule TemporalEngineNif.Worker do
  defstruct [:id, :core, :client, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Worker, for: TemporalEngineNif.Worker do
  require Logger
  require TemporalEngine.Data.Commands

  import TemporalEngine.Data.ActivationCompletion
  import TemporalEngine.Data.ActivityTaskCompletion

  alias TemporalEngineNif.Core

  @impl true
  def id(worker), do: worker.id

  @impl true
  def poll_workflow_activation(worker) do
    parent = self()

    child =
      spawn_link(fn ->
        Process.set_label({:long_activations_poll, worker.id})

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
        {:ok, task}

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
        {:ok, task}

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
  def complete_workflow_activation(worker, completion() = complete) do
    parent = self()

    child =
      spawn_link(fn ->
        Core._worker_complete_workflow_activation(
          worker.runtime.core,
          worker.core,
          complete,
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
  def complete_activity_task(worker, task_completion() = completion) do
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
                Logger.error("Workflow Complete Activity Task Error - #{inspect(err)}")
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
      :telemetry.execute([:temporalio, :worker, :shutdown_initiated], %{}, %{
        worker_id: worker.id
      })

      :ok
    else
      {:error, err} ->
        {:error, err}
    end
  end

  @impl true
  def finalize_shutdown(worker) do
    with :ok <- Core._worker_finalize_shutdown(worker.core) do
      :telemetry.execute([:temporalio, :worker, :shutdown_finalized], %{}, %{
        worker_id: worker.id
      })

      :ok
    else
      {:error, err} ->
        {:error, err}
    end
  end
end
