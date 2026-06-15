defmodule TemporalEngine.Mock.Storage do
  @set TemporalEngine.Mock.Storage.Set
  @bag TemporalEngine.Mock.Storage.Bag

  def initialize! do
    Registry.start_link(keys: {:duplicate, :key}, name: TemporalEngine.Mock.Registry)

    try do
      :ets.new(@set, [:set, :public, :named_table])
    rescue
      ArgumentError ->
        # Table already exists
        :ok
    end

    try do
      :ets.new(@bag, [:bag, :public, :named_table])
    rescue
      ArgumentError ->
        # Table already exists
        :ok
    end
  end

  def set, do: @set
  def bag, do: @bag
end
