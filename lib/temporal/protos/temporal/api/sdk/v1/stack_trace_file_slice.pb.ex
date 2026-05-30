defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileSlice do
  @moduledoc """
  "Slice" of a file starting at line_offset -- a line offset and code fragment corresponding to the worker's stack.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`content`** | `string` | Slice of a file with the respective OS-specific line terminator. |
  | 1 | **`line_offset`** | `uint32` | Only used (possibly) to trim the file without breaking syntax highlighting. This is not optional, unlike |

  ### Additional Notes

    * `line_offset` (`uint32`): Only used (possibly) to trim the file without breaking syntax highlighting. This is not optional, unlike
      the `line` property of a `StackTraceFileLocation`.
      (-- api-linter: core::0141::forbidden-types=disabled
          aip.dev/not-precedent: These really shouldn't have negative values. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :line_offset, 1, type: :uint32, json_name: "lineOffset"
  field :content, 2, type: :string
end
