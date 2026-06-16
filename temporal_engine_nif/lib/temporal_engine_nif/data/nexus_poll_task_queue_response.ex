defmodule TemporalEngineNif.Data.NexusPollTaskQueueResponse do
  defstruct [
    :task_token,
    :poller_group_id,
    :poller_group_infos,
    request: nil,
    poller_scaling_decision: nil
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          task_token: [byte()],
          request: Data.NexusRequest.t() | nil,
          poller_scaling_decision: Data.PollerScalingDecision.t(),
          poller_group_id: String.t(),
          poller_group_infos: [Data.PollerGroupInfo.t()]
        }
end
