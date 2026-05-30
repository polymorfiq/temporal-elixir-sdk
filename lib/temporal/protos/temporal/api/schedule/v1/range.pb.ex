defmodule Temporal.Protos.Temporal.Api.Schedule.V1.Range do
  @moduledoc """
  Range represents a set of integer values, used to match fields of a calendar
  time in StructuredCalendarSpec. If end < start, then end is interpreted as
  equal to start. This means you can use a Range with start set to a value, and
  end and step unset (defaulting to 0) to represent a single value.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`end`** | `int32` | End of range (inclusive). |
  | 1 | **`start`** | `int32` | Start of range (inclusive). |
  | 3 | **`step`** | `int32` | Step (optional, default 1). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :start, 1, type: :int32
  field :end, 2, type: :int32
  field :step, 3, type: :int32
end
