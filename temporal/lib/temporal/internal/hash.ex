defmodule Temporal.Internal.Hash do
  @moduledoc false

  @doc "Generates random IDs for making collisions unlikely"
  @spec random_hash(pos_integer()) :: String.t()
  def random_hash(hash_size) do
    :crypto.strong_rand_bytes(hash_size)
    |> Base.encode16(case: :lower)
  end
end
