defmodule Temporal.CoreSdk.Data.ClientTlsOpts do
  defstruct client_cert: nil, client_private_key: nil, server_root_ca_cert: nil, domain: nil

  @type t :: %__MODULE__{
          client_cert: binary(),
          client_private_key: binary(),
          server_root_ca_cert: binary(),
          domain: String.t()
        }

  @type opts :: [
          {:client_cert, binary()}
          | {:client_private_key, binary()}
          | {:server_root_ca_cert, binary()}
          | {:domain, String.t()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
