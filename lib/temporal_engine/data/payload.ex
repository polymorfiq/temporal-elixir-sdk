defmodule TemporalEngine.Data.Payload do
  require Record

  Record.defrecord(:payload, [
    :data,
    metadata: %{},
    external_payloads: []
  ])

  @type payload ::
          record(:payload,
            metadata: %{String.t() => binary()},
            data: binary(),
            external_payloads: [external()]
          )

  Record.defrecord(:external, [:size_bytes])
  @type external :: record(:external, size_bytes: pos_integer())
end
