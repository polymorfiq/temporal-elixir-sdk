defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowTaskCompletedMetadata do
  @moduledoc """
  Automatically generated module for WorkflowTaskCompletedMetadata

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`core_used_flags`** | `uint32` | Internal flags used by the core SDK. SDKs using flags must comply with the following behavior: |
  | 2 | **`lang_used_flags`** | `uint32` | Flags used by the SDK lang. No attempt is made to distinguish between different SDK languages |
  | 3 | **`sdk_name`** | `string` | Name of the SDK that processed the task. This is usually something like "temporal-go" and is |
  | 4 | **`sdk_version`** | `string` | Version of the SDK that processed the task. This is usually something like "1.20.0" and is |

  ### Additional Notes

    * `core_used_flags` (`uint32`): Internal flags used by the core SDK. SDKs using flags must comply with the following behavior:

      During replay:
      * If a flag is not recognized (value is too high or not defined), it must fail the workflow
        task.
      * If a flag is recognized, it is stored in a set of used flags for the run. Code checks for
        that flag during and after this WFT are allowed to assume that the flag is present.
      * If a code check for a flag does not find the flag in the set of used flags, it must take
        the branch corresponding to the absence of that flag.

      During non-replay execution of new WFTs:
      * The SDK is free to use all flags it knows about. It must record any newly-used (IE: not
        previously recorded) flags when completing the WFT.

      SDKs which are too old to even know about this field at all are considered to produce
      undefined behavior if they replay workflows which used this mechanism.

      (-- api-linter: core::0141::forbidden-types=disabled
          aip.dev/not-precedent: These really shouldn't have negative values. --)
    * `lang_used_flags` (`uint32`): Flags used by the SDK lang. No attempt is made to distinguish between different SDK languages
      here as processing a workflow with a different language than the one which authored it is
      already undefined behavior. See `core_used_patches` for more.

      (-- api-linter: core::0141::forbidden-types=disabled
          aip.dev/not-precedent: These really shouldn't have negative values. --)
    * `sdk_name` (`string`): Name of the SDK that processed the task. This is usually something like "temporal-go" and is
      usually the same as client-name gRPC header. This should only be set if its value changed
      since the last time recorded on the workflow (or be set on the first task).

      (-- api-linter: core::0122::name-suffix=disabled
          aip.dev/not-precedent: We're ok with a name suffix here. --)
    * `sdk_version` (`string`): Version of the SDK that processed the task. This is usually something like "1.20.0" and is
      usually the same as client-version gRPC header. This should only be set if its value changed
      since the last time recorded on the workflow (or be set on the first task).

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :core_used_flags, 1, repeated: true, type: :uint32, json_name: "coreUsedFlags"
  field :lang_used_flags, 2, repeated: true, type: :uint32, json_name: "langUsedFlags"
  field :sdk_name, 3, type: :string, json_name: "sdkName"
  field :sdk_version, 4, type: :string, json_name: "sdkVersion"
end
