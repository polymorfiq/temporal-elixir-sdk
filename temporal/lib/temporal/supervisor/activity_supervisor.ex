defmodule Temporal.Supervisor.ActivitySupervisor do
  use Supervisor

  alias Temporal.Activity.ActivityContext
  alias Temporal.Activity.ActivityExecutor
  alias Temporal.Activity.ActivityProgressReporter
  alias Temporal.ActivityRegistry
  alias Temporal.Supervisor.ExecutionContext

  @type activity_id :: String.t()

  @spec start_link({ExecutionContext.t(), Worker.worker_opts(), keyword()}) ::
          {:ok, pid()} | {:error, term()}
  def start_link({exec_ctx, server_opts}) do
    Supervisor.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  @impl true
  def init(exec_ctx) do
    Process.set_label({:activity_supervisor, exec_ctx.activity_id})

    children = [
      {ActivityContext, {exec_ctx, [name: via_registry({:context, exec_ctx.activity_id})]}},
      {ActivityProgressReporter,
       {exec_ctx, [name: via_registry({:progress_reporter, exec_ctx.activity_id})]}},
      {ActivityExecutor, {exec_ctx, [name: via_registry({:executor, exec_ctx.activity_id})]}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec stop_activity(run_id :: String.t(), activity_id :: String.t(), opts :: keyword()) :: :ok
  def stop_activity(run_id, activity_id, opts \\ []) do
    sup = GenServer.whereis(process_name(run_id, activity_id))

    cond do
      sup && opts[:wait] ->
        Supervisor.stop(sup, :shutdown, :infinity)

      sup ->
        spawn(fn ->
          Supervisor.stop(sup, :shutdown, :infinity)
        end)

        :ok

      true ->
        :ok
    end
  end

  @spec progress_reporter_pid(activity_id()) :: {:ok, term()} | {:error, term()}
  def progress_reporter_pid(activity_id) do
    if pid = GenServer.whereis(via_registry({:progress_reporter, activity_id})) do
      {:ok, pid}
    else
      {:error, :progress_reporter_not_running}
    end
  end

  @spec process_name(activity_id :: String.t()) :: {:via, atom(), term()}
  def process_name(activity_id), do: via_registry({:activity, activity_id})

  defp via_registry(name), do: {:via, Registry, {ActivityRegistry, name}}
end
