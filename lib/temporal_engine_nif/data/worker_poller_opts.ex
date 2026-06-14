defmodule TemporalEngineNif.Data.WorkerPollerOpts do
  defstruct autoscaling: nil,
            simple_maximum: nil

  alias TemporalEngineNif.Data.WorkerPollerAutoscalingOpts
  alias TemporalEngineNif.Data.WorkerPollerSimpleMaximumOpts

  @type t ::
          {:autoscaling, WorkerPollerAutoscalingOpts.t()}
          | {:simple_maximum, WorkerPollerSimpleMaximumOpts.t()}

  @type opts ::
          {:autoscaling, WorkerPollerAutoscalingOpts.opts()}
          | {:simple_maximum, WorkerPollerSimpleMaximumOpts.opts()}

  @spec with_opts!(opts()) :: t()
  def with_opts!({:autoscaling, opts}) do
    {:autoscaling, WorkerPollerAutoscalingOpts.with_opts!(opts)}
  end

  def with_opts!({:simple_maximum, opts}) do
    {:simple_maximum, WorkerPollerSimpleMaximumOpts.with_opts!(opts)}
  end
end
