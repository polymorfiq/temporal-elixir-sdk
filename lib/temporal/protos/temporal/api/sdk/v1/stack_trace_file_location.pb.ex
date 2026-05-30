defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileLocation do
  @moduledoc """
  More specific location details of a file: its path, precise line and column numbers if applicable, and function name if available.
  In essence, a pointer to a location in a file

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`column`** | `int32` | Optional; if possible, SDK should send this. |
  | 1 | **`file_path`** | `string` | Path to source file (absolute or relative). |
  | 4 | **`function_name`** | `string` | Function name this line belongs to, if applicable. |
  | 5 | **`internal_code`** | `bool` | Flag to communicate whether a location should be hidden by default in the stack view. |
  | 2 | **`line`** | `int32` | Optional; If possible, SDK should send this -- this is required for displaying the code location. |

  ### Additional Notes

    * `column` (`int32`): Optional; if possible, SDK should send this.
      If not provided, set to -1.
    * `file_path` (`string`): Path to source file (absolute or relative).
      If the paths are relative, ensure that they are all relative to the same root.
    * `function_name` (`string`): Function name this line belongs to, if applicable.
      Used for falling back to stack trace view.
    * `line` (`int32`): Optional; If possible, SDK should send this -- this is required for displaying the code location.
      If not provided, set to -1.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :file_path, 1, type: :string, json_name: "filePath"
  field :line, 2, type: :int32
  field :column, 3, type: :int32
  field :function_name, 4, type: :string, json_name: "functionName"
  field :internal_code, 5, type: :bool, json_name: "internalCode"
end
