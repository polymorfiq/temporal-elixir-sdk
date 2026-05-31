defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:operation, 0)

  field(:namespace, 1, type: :string)
  field(:task_queue, 2, type: :string, json_name: "taskQueue")
  field(:conflict_token, 3, type: :bytes, json_name: "conflictToken")

  field(:insert_assignment_rule, 4,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.InsertBuildIdAssignmentRule,
    json_name: "insertAssignmentRule",
    oneof: 0
  )

  field(:replace_assignment_rule, 5,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceBuildIdAssignmentRule,
    json_name: "replaceAssignmentRule",
    oneof: 0
  )

  field(:delete_assignment_rule, 6,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteBuildIdAssignmentRule,
    json_name: "deleteAssignmentRule",
    oneof: 0
  )

  field(:add_compatible_redirect_rule, 7,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.AddCompatibleBuildIdRedirectRule,
    json_name: "addCompatibleRedirectRule",
    oneof: 0
  )

  field(:replace_compatible_redirect_rule, 8,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.ReplaceCompatibleBuildIdRedirectRule,
    json_name: "replaceCompatibleRedirectRule",
    oneof: 0
  )

  field(:delete_compatible_redirect_rule, 9,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.DeleteCompatibleBuildIdRedirectRule,
    json_name: "deleteCompatibleRedirectRule",
    oneof: 0
  )

  field(:commit_build_id, 10,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.CommitBuildId,
    json_name: "commitBuildId",
    oneof: 0
  )
end
