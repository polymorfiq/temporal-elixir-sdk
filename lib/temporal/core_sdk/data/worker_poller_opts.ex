defmodule Temporal.CoreSdk.Data.WorkerPollerOpts do
  defstruct autoscaling: nil,
            simple_maximum: nil

  alias Temporal.CoreSdk.Data.WorkerPollerAutoscalingOpts
  alias Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts

  @type t :: %__MODULE__{
          autoscaling: WorkerPollerAutoscalingOpts.t() | nil,
          simple_maximum: WorkerPollerSimpleMaximumOpts.t() | nil
        }
end
