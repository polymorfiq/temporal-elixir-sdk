defmodule Temporal.Workflow do
  defmacro __using__(_opts) do
    quote do
      @behaviour Temporal.Workflow
    end
  end
end
