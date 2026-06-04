defmodule Temporal.CoreSdk.Data.ClientOpts do
  defstruct [
    :target_host,
    :namespace,
    :client_name,
    :client_version,
    :identity,
    :rpc_retry,
    headers: nil,
    binary_headers: nil,
    api_key: nil,
    tls: nil,
    keep_alive: nil,
    http_connect_proxy: nil,
    dns_load_balancing: nil
  ]

  alias Temporal.CoreSdk.Data.ClientRetryOpts
  alias Temporal.CoreSdk.Data.ClientTlsOpts
  alias Temporal.CoreSdk.Data.ClientKeepAliveOpts
  alias Temporal.CoreSdk.Data.ClientHttpConnectProxyOpts
  alias Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts

  @type t :: %__MODULE__{
          target_host: String.t(),
          namespace: String.t(),
          client_name: String.t(),
          client_version: String.t(),
          identity: String.t(),
          rpc_retry: ClientRetryOpts.t(),
          headers: map() | nil,
          binary_headers: map() | nil,
          api_key: String.t() | nil,
          tls: ClientTlsOpts.t() | nil,
          keep_alive: ClientKeepAliveOpts.t() | nil,
          http_connect_proxy: ClientHttpConnectProxyOpts.t() | nil,
          dns_load_balancing: ClientDnsLoadBalancingOpts.t() | nil
        }
end
