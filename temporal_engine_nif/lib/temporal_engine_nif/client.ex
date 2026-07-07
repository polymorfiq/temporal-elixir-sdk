defmodule TemporalEngineNif.Client do
  defstruct [:id, :namespace, :core, :runtime]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Client, for: TemporalEngineNif.Client do
  import TemporalEngine.Data.Payload
  import TemporalEngine.Config
  import TemporalEngine.Opts.WorkflowOpts

  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Runtime
  alias TemporalEngineNif.WorkflowHandle
  alias TemporalEngineNif.Worker

  @impl true
  def id(client), do: client.id

  @impl true
  def namespace(client), do: client.namespace

  @impl true
  def create_worker(client, config) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_worker(client.runtime.core, client.core, config, self())
        |> case do
          :ok -> :ok
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
                    id: worker_config(config, :id),
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
        Process.demonitor(ref, [:flush])
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
          Process.demonitor(ref, [:flush])
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
  def get_workflow_handle(client, workflow_id) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._client_get_workflow_handle(
          client.runtime.core,
          client.core,
          workflow_id,
          self()
        )
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not get workflow handle via Core SDK: #{inspect(err)}"
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
                  workflow_id: workflow_id
                }}}
            )

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        Process.demonitor(ref, [:flush])
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def list_workflows(client, query, limit) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._client_list_workflows(
          client.runtime.core,
          client.core,
          query,
          limit,
          self()
        )
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could not list workflows via Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, execs} ->
            send(parent, {self(), {:ok, execs}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        Process.demonitor(ref, [:flush])
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def start_workflow(client, definition, args, opts) do
    parent = self()

    inputs = workflow_arguments(args: args)

    {pid, ref} =
      spawn_monitor(fn ->
        Core._client_start_workflow(
          client.runtime.core,
          client.core,
          definition,
          inputs,
          opts,
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
                  workflow_name: workflow_definition(definition, :name),
                  workflow_id: workflow_start_opts(opts, :id),
                  task_queue: workflow_start_opts(opts, :task_queue)
                }}}
            )

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        Process.demonitor(ref, [:flush])
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end
end
