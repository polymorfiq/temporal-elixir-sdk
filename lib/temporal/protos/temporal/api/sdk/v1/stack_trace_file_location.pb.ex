defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileLocation do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:file_path, 1, type: :string, json_name: "filePath")
  field(:line, 2, type: :int32)
  field(:column, 3, type: :int32)
  field(:function_name, 4, type: :string, json_name: "functionName")
  field(:internal_code, 5, type: :bool, json_name: "internalCode")
end
