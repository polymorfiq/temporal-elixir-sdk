defmodule Temporal.CoreSdk.Data.ClientHttpConnectProxyOpts do
  defstruct [:target_host, basic_auth_user: nil, basic_auth_pass: nil]

  @type t :: %__MODULE__{
          target_host: String.t(),
          basic_auth_user: String.t() | nil,
          basic_auth_pass: String.t() | nil
        }
end
