defmodule Temporal.CoreSdk do
  use Rustler,
      otp_app: :temporal,
      crate: :temporalcoresdk

  def new_runtime, do: :erlang.nif_error(:nif_not_loaded)
end