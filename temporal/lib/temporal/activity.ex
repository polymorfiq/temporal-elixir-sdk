defmodule Temporal.Activity do
  require Record

  Record.defrecord(:activity_context, [:executor])
  @type activity_context :: record(:activity_context, executor: pid())

  @spec get_activity_context() :: activity_context()
  def get_activity_context() do
    activity_context(executor: Process.get(:_temporal_executor))
  end

  @spec record_heartbeat(activity_context(), details :: [term()]) :: :ok
  def record_heartbeat(activity_context(executor: executor), details \\ []) do
    send(executor, {:record_heartbeat, details})
    :ok
  end
end
