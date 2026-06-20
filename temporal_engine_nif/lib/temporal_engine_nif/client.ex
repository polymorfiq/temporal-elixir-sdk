defmodule TemporalEngineNif.Client do
  defstruct [:id, :core, :runtime]

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
  def create_worker(client, config) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_worker(client.runtime.core, client.core, config, self())
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
                  workflow_id: workflow_start_opts(opts, :workflow_id),
                  task_queue: workflow_start_opts(opts, :task_queue)
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
