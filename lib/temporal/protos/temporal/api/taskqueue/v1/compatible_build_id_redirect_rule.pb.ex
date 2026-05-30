defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleBuildIdRedirectRule do
  @moduledoc """
  These rules apply to tasks assigned to a particular Build ID
  (`source_build_id`) to redirect them to another *compatible* Build ID
  (`target_build_id`).

  It is user's responsibility to ensure that the target Build ID is compatible
  with the source Build ID (e.g. by using the Patching API).

  Most deployments are not expected to need these rules, however following
  situations can greatly benefit from redirects:
   - Need to move long-running Workflow Executions from an old Build ID to a
     newer one.
   - Need to hotfix some broken or stuck Workflow Executions.

  In steady state, redirect rules are beneficial when dealing with old
  Executions ran on now-decommissioned Build IDs:
   - To redirecting the Workflow Queries to the current (compatible) Build ID.
   - To be able to Reset an old Execution so it can run on the current
     (compatible) Build ID.

  Redirect rules can be chained.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`source_build_id`** | `string` |  |
  | 2 | **`target_build_id`** | `string` | Target Build ID must be compatible with the Source Build ID; that is it |

  ### Additional Notes

    * `target_build_id` (`string`): Target Build ID must be compatible with the Source Build ID; that is it
      must be able to process event histories made by the Source Build ID by
      using [Patching](https://docs.temporal.io/workflows#patching) or other
      means.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :source_build_id, 1, type: :string, json_name: "sourceBuildId"
  field :target_build_id, 2, type: :string, json_name: "targetBuildId"
end
