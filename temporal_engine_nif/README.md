# Temporal Engine (NIF)

A backend implementation of a [Temporal Engine](https://github.com/polymorfiq/temporal-engine).


The [Temporal Elixir SDK](https://github.com/polymorfiq/temporal-elixir-sdk) is split into **Frontend** (which provides a programming interface for defining workflows, activities, monitoring workers and so-on...) and the **Backend** which handles facilitating ongoing communication with the server and management of the various stateful activities involved in correctly processing those requests.

This is a backend sits atop the Rust-based [Temporal Core SDK](https://github.com/temporalio/sdk-rust#temporal-core-sdk) in order to stay as closely tied to the ongoing feature development and benefit from continuous improvements of the Core.

There could perhaps one day be an pure-Elixir Temporal Engine, utilizing gRPC entirely within BEAM. The primary goal of separating the backend from the frontend is so that someone could swap out this backend for that one, or vice-versa, without changing much about their application's Workflow Definitions, Activities, monitoring or so-on. The frontend can develop an easy-to-use, feature-rich way of interacting with the service and the backend can focus on the nitty-gritty of the fault-less communication.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `temporal_engine_nif` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:temporal_engine_nif, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/temporal_engine_nif>.

