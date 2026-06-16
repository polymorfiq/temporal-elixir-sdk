# Temporal Elixir SDK (Samples)

These are example workflows that also serve as a set of integration tests for the [Temporal Elixir SDK](https://github.com/polymorfiq/temporal-elixir-sdk)

## Using the SDK

You just pair a Frontend with your desired Backend in your Mix dependencies:
```elixir
{:temporal, "~> 0.1.0",
  github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal", ref: "975e40b"},

{:temporal_engine_nif, "~> 0.1.0",
  github: "polymorfiq/temporal-elixir-sdk", subdir: "temporal_engine_nif", ref: "975e40b"}
```

Configure the SDK to select and engine and JSON encoder:
```elixir
# config.exs

config :temporal, engine: TemporalEngineNif.Engine
config :temporal_engine, json_encoder: Jason
```

## Workflow Examples

Workflow examples can be found in [lib/workflows](lib/workflows).

## Integration Tests

If running a local instance of Temporal Server, running the test suite will perform integration tests on the SDK.

```bash
git clone git@github.com:polymorfiq/temporal-elixir-sdk-samples.git
cd temporal-elixir-sdk-samples;
mix deps.get;
mix test;
```