defmodule TemporalGettingStarted.Greeting do
  @moduledoc "Activities for producing greetings"

  @spec greet(name :: String.t()) :: {:ok, String.t()} | {:error, term()}
  def greet(name) do
    {:ok, "Hello #{name}"}
  end
end