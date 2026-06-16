defmodule Temporal.MixProject do
  use Mix.Project

  def project do
    [
      app: :temporal,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      prune_code_paths: false,
      elixirc_paths: elixirc_paths(Mix.env()),

      # Docs
      name: "Temporal SDK",
      source_url: "https://github.com/polymorfiq/temporal-elixir-sdk",
      homepage_url: "https://hex.pm/packages/temporal-elixir-sdk",
      docs: [
        # The main page in the docs
        main: "Temporal Elixir SDK",
        extras: ["README.md"]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_workflows"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:temporal_engine, "~> 0.1.0", github: "polymorfiq/temporal-engine-elixir", ref: "bdacbb1"},
      {:nimble_options, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
