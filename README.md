# Temporal

**TODO: Add description**

Setup:
```shell
brew install protobuf
mix escript.install hex protobuf 0.16.0
```

Generation:
```shell
cd priv;
git clone --depth 1 --branch v1.62.13 https://github.com/temporalio/api.git;
cd ../;

mix protobuf.generate --package-prefix=temporal.protos --include-path=./deps/googleapis --include-path=./priv/api --output-path=./lib --plugin=ProtobufGenerate.Plugins.GRPCWithOptions --one-file-per-module google/api/annotations.proto google/api/http.proto ./priv/api/temporal/api/**/*.proto
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `temporal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:temporal, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/temporal>.

