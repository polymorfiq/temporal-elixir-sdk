# Temporal Engine

This is the set of protocols, data structures and behaviors that facilitate communication of Elixir-based Temporal Frontends (Workflow Definitions, Runtimes...) with a Temporal Backend service (Core NIF, Pure Erlang/Elixir gRPC..)

### Sample Usage
- [Temporal Elixir SDK Samples](https://github.com/polymorfiq/temporal-elixir-sdk-samples)

### Known Frontends

- [Temporal Elixir SDK](https://github.com/polymorfiq/temporal-elixir-sdk)

### Known Backends

- [Temporal Engine NIF](https://github.com/polymorfiq/temporal-engine-nif)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `temporal_engine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:temporal_engine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/temporal_engine>.

