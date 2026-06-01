defmodule Temporal.WorkflowTest do
  use ExUnit.Case
  doctest Temporal.Worker

  alias Temporal.Client
  alias Temporal.Worker

  setup_all do
    {:ok, client} = Temporal.dial_client("localhost:7233")

    on_exit(fn ->
      Client.stop_workers(client)
    end)

    {:ok, client: client}
  end

  test "can register with Workers", %{client: c} do
    {:ok, w} = Worker.new(c, "default")

    defmodule MyWorkflow do
      def execute(_ctx) do
        {:ok, "response"}
      end
    end

    Worker.register_workflow(w, MyWorkflow)
  end
end
