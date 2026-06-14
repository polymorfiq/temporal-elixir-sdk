defmodule TemporalEngineNif.Data.ActivityTaskVariant do
  alias TemporalEngineNif.Data

  @type t :: {:start, Data.ActivityTaskStart.t()} | {:cancel, Data.ActivityTaskCancel.t()}
end
