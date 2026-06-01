defmodule Temporal.Polls.WorkflowActivityPoll do
  use GenStage

  alias Temporal.Comms.Worker.TaskQueueComms

  def start_link(args) do
    GenStage.start_link(__MODULE__, args)
  end

  @impl GenStage
  def init(worker), do: {:producer, %{worker: worker}}

  @impl GenStage
  def handle_demand(demand, state) when demand > 0 do
    TaskQueueComms.next_poll_request(state.worker)

    {:noreply, [], state}
  end
end
