defmodule Temporal.CoreSdk.Data.ClientPayloads do
  defstruct [:payloads]

  alias Temporal.CoreSdk.Data.ClientPayload

  @type t :: %__MODULE__{payloads: [ClientPayload.t()]}
  @type opts :: [{:payloads, [ClientPayload.opts()]}] | [ClientPayload.opts()]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    cond do
      Keyword.keyword?(opts) ->
        args = struct!(__MODULE__, opts)

        args =
          update_in(args, [Access.key(:payloads)], fn inputs ->
            Enum.map(inputs, &ClientPayload.with_opts!/1)
          end)

        args

      is_list(opts) ->
        %__MODULE__{payloads: Enum.map(opts, &ClientPayload.with_opts!/1)}

      true ->
        raise "Unknown argument type received: #{inspect(opts)}"
    end
  end
end
