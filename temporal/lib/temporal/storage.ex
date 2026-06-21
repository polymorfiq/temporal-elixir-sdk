defmodule Temporal.Storage do
  @moduledoc false

  @global_store Temporal.GlobalStore
  def global_store, do: @global_store

  @spec initialize!() :: :ok
  def initialize! do
    :ets.new(@global_store, [:set, :public, :named_table, read_concurrency: true])
  end
end
