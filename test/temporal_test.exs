defmodule TemporalTest do
  use ExUnit.Case
  doctest Temporal

  alias Temporal.Protos.Temporal.Api.Workflowservice.V1, as: Workflows

  test "greets the world" do
    assert Temporal.hello() == :world
  end

  test "grpc works" do
    {:ok, _pid} = DynamicSupervisor.start_link(strategy: :one_for_one, name: GRPC.Client.Supervisor)
    {:ok, channel} = GRPC.Stub.connect("localhost:7233")

    req = %Workflows.ListNamespacesRequest{page_size: 0, next_page_token: nil}
    {:ok, reply} = channel |> Workflows.WorkflowService.Stub.list_namespaces(req)
    reply |> IO.inspect(label: "hmm")
  end
end
