defmodule TemporalEngine.Constants do
  def sdk_name, do: "temporal-elixir"
  def sdk_version, do: "v#{Application.spec(:temporal_engine)[:vsn]}"
end
