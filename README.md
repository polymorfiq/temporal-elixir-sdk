# Temporal Elixir SDK

This is a Frontend library that, when paired through the [Temporal Engine](/temporal_engine) protocols to a [Temporal Backend library](/temporal_engine_nif), becomes the Temporal Elixir SDK.

This is in active development and this README will be updated when it is ready for general use.

# Installation

Read the **[SDK Guides](/guides/)** for installation and usage of the SDK

# References (for building Lang SDKs)

**A collection of useful references I've found so far, for building Temporal Lang SDKs**

The [Core SDK Architecture Document](https://github.com/temporalio/sdk-rust/blob/main/ARCHITECTURE.md) is the best resource for understanding the relationship between your Lang SDK, the Core SDK, and the Temporal Server.

Once you know the vocabulary around working with the Temporal Server, the [Temporal SDK Core](https://docs.rs/temporalio-sdk-core/0.4.0/temporalio_sdk_core/index.html) docs are by far the most helpful resource for understanding the internal workings of the Core SDK.

The [Temporal Ruby SDK](https://github.com/temporalio/sdk-ruby/tree/main/temporalio/ext/src) utilizes the Core SDK and so is a good example of how to utilize it in a production environment.



