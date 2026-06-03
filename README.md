# Temporal Elixir SDK

**This is an (in progress) Temporal Language SDK for the Elixir programming language, that utilizes an NIF of the [Temporal Core SDK](https://github.com/temporalio/sdk-rust#temporal-core-sdk). This is not yet tested or fit for production usage.**

Though, it's MIT Licensed so feel free to fork it and go crazy in making it production-ready!

# Installation

```elixir
defp deps do
  [
    ...
    {:temporal, "~> 0.0.1", github: "polymorfiq/temporal-elixir-sdk", branch: "main"}
  ]
end
```


