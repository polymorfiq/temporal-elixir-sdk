# Temporal Elixir SDK

This is a Frontend library that, when paired through the [Temporal Engine](/temporal_engine) protocols to a [Temporal Backend library](/temporal_engine_nif), becomes the Temporal Elixir SDK.

This is in active development and this README will be updated when it is ready for general use.

Here is a [project of example Workflows](/temporal_samples) for using the SDK, that will be expanded as I continue building out the features and building tests!

# Installation

```elixir
defp deps do
  [
    ...
    {:temporal, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", branch: "main", subdir: "temporal"}
    {:temporal_engine_nif, "~> 0.1.0", github: "polymorfiq/temporal-elixir-sdk", branch: "main", subdir: "temporal_engine_nif"}
  ]
end
```

# Glossary of Terms

For learning how to interact with the Temporal Core SDK, this [Glossary of Terms](https://github.com/temporalio/sdk-rust/blob/main/ARCHITECTURE.md#glossary-of-terms) can be helpful.

# References (for building Lang SDKs)

**A collection of useful references I've found so far, for building Temporal Lang SDKs**

The [Core SDK Architecture Document](https://github.com/temporalio/sdk-rust/blob/main/ARCHITECTURE.md) is the best resource for understanding the relationship between your Lang SDK, the Core SDK, and the Temporal Server.

Once you know the vocabulary around working with the Temporal Server, the [Temporal SDK Core](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/index.html) docs are by far the most helpful resource for understanding the internal workings of the Core SDK.

The [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby/tree/main/temporalio/ext/src) utilizes the Core SDK and so is a good example of how to utilize it in a production environment.



