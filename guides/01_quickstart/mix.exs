defmodule TemporalGettingStarted.MixProject do
  use Mix.Project

  def project do
    [
      app: :temporal_getting_started,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TemporalGettingStarted.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:temporal, "~> 0.1.0", path: "../../../temporal"},
      {:temporal_engine, "~> 0.1.0", path: "../../../temporal_engine"},
      {:temporal_engine_nif, "~> 0.1.0", path: "../../../temporal_engine_nif"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
