defmodule Temporal.Workflow.WorkflowQueryExecutor do
  use GenServer

  require Logger
  require Record
  Record.defrecordp(:queries_state, [:run_id, :workflow_id, :worker_id, :module, handlers: %{}])

  def start_link({exec_ctx, server_opts}) do
    GenServer.start_link(
      __MODULE__,
      exec_ctx,
      server_opts
    )
  end

  def init(exec_ctx) do
    {:ok,
     queries_state(
       run_id: exec_ctx.run_id,
       workflow_id: exec_ctx.workflow_id,
       worker_id: exec_ctx.worker_id
     )}
  end

  def set_handler(pid, name, handler_fn) do
    GenServer.cast(pid, {:set_handler, name, handler_fn})
  end

  def query(pid, name, args) do
    GenServer.call(pid, {:query, name, args}, :infinity)
  end

  def handle_cast({:set_handler, name, handler_fn}, state) do
    handlers = queries_state(state, :handlers)
    {:arity, arity} = Function.info(handler_fn, :arity)
    {:noreply, queries_state(state, handlers: Map.put(handlers, {"#{name}", arity}, handler_fn))}
  end

  def handle_call({:query, name, args}, _from, state) do
    handlers = queries_state(state, :handlers)
    arity = Enum.count(args)

    resp =
      if handler_fn = handlers[{"#{name}", arity}] do
        try do
          apply(handler_fn, args)
        rescue
          err -> {:error, err}
        end
      else
        {:error, "No query with the name '#{name}' and arity (#{arity}) was found"}
      end

    {:reply, resp, state}
  end
end
