defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTimedOutEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:retry_state, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )

  field(:new_execution_run_id, 2, type: :string, json_name: "newExecutionRunId")
end
