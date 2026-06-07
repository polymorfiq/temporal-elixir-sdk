defmodule Temporal.CoreSdk.Data.WorkflowCommandUpdateResponse do
  defstruct [:protocol_instance_id, response: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          protocol_instance_id: String.t(),
          response: Data.WorkflowCommandUpdateResponseStatus.t() | nil
        }

  @type opts :: [
          {:protocol_instance_id, String.t()}
          | {:response, Data.WorkflowCommandUpdateResponseStatus.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    resp = struct!(__MODULE__, opts)

    resp =
      if opts[:response] do
        update_in(
          resp,
          [Access.key(:response)],
          &Data.WorkflowCommandUpdateResponseStatus.with_opts!/1
        )
      else
        resp
      end

    resp
  end
end
