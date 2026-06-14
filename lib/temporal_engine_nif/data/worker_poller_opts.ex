defmodule TemporalEngineNif.Data.WorkerPollerOpts do
  defstruct autoscaling: nil,
            simple_maximum: nil

  alias TemporalEngineNif.Data.WorkerPollerAutoscalingOpts
  alias TemporalEngineNif.Data.WorkerPollerSimpleMaximumOpts

  @type t ::
          {:autoscaling, WorkerPollerAutoscalingOpts.t()}
          | {:simple_maximum, WorkerPollerSimpleMaximumOpts.t()}
end
