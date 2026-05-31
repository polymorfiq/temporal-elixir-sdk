defmodule Temporal.MixProject do
  use Mix.Project

  def project do
    [
      app: :temporal,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Temporal SDK",
      source_url: "https://github.com/polymorfiq/temporal-sdk",
      homepage_url: "https://hex.pm/packages/temporal-sdk",
      docs: [
        # The main page in the docs
        main: "Temporal SDK",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :os_mon],
      mod: {Temporal.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:grpc, "~> 0.11"},
      {:protobuf, "~> 0.16"},
      {:protobuf_generate, "~> 0.2", only: [:dev]},
      {:elixir_uuid, "~> 1.2"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
