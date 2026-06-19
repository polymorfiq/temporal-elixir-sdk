defmodule TemporalEngineNif.Client do
  defstruct [:id, :core, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Client, for: TemporalEngineNif.Client do
  alias TemporalEngine.Opts.WorkflowOpts.WorkflowDefinition
  alias TemporalEngine.Opts.WorkflowOpts.WorkflowStartOpts
  alias TemporalEngine.Config.WorkerConfig
  alias TemporalEngineNif.Core
  alias TemporalEngine.Data.Payload.Payload
  alias TemporalEngine.Data.Payload.WorkflowArguments
  alias TemporalEngineNif.Runtime
  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngineNif.Worker

  @impl true
  def id(client), do: client.id

  @impl true
  def create_worker(client, config) do
    parent = self()

    worker_opts = WorkerConfig.from_record!(config)

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_worker(client.runtime.core, client.core, worker_opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize worker from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, worker} ->
            with :ok <- validate(worker, client.runtime) do
              send(
                parent,
                {self(),
                 {:ok,
                  %Worker{
                    id: worker_opts.id,
                    core: worker,
                    client: client,
                    runtime: client.runtime
                  }}}
              )
            else
              {:error, err} ->
                send(parent, {self(), {:error, err}})
            end

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  @spec validate(worker_ref :: term(), Runtime.t()) :: :ok | {:error, term()}
  def validate(worker_ref, runtime) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._validate_worker(runtime.core, worker_ref, self())
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not validate worker via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, _} ->
            send(parent, {self(), :ok})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    validate_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    case validate_resp do
      :ok -> :ok
      {:error, err} -> {:error, "Validation error: #{inspect(err)}"}
    end
  end

  @impl true
  def start_workflow(client, definition, args, opts) do
    parent = self()

    wf_def = WorkflowDefinition.from_record!(definition)
    inputs = %WorkflowArguments{args: Enum.map(args, &Payload.from_record!/1)}

    with {:ok, start_opts} <- WorkflowStartOpts.from_record(opts) do
      {pid, ref} =
        spawn_monitor(fn ->
          Core._client_start_workflow(
            client.runtime.core,
            client.core,
            wf_def,
            inputs,
            start_opts,
            self()
          )
          |> case do
            :ok -> :ok
            {:error, err} -> raise "Could not start workflow via Core SDK: #{inspect(err)}"
          end

          receive do
            {:ok, workflow_handle} ->
              send(
                parent,
                {self(),
                 {:ok,
                  %WorkflowHandle{
                    client: client,
                    core: workflow_handle,
                    workflow_name: wf_def.name,
                    workflow_id: start_opts.workflow_id,
                    task_queue: start_opts.task_queue
                  }}}
              )

            {:error, err} ->
              send(parent, {self(), {:error, err}})
          end
        end)

      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end
    end
  end
end
