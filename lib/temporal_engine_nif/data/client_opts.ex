defmodule TemporalEngineNif.Data.ClientOpts do
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

  alias TemporalEngineNif.Data.ClientRetryOpts
  alias TemporalEngineNif.Data.ClientTlsOpts
  alias TemporalEngineNif.Data.ClientKeepAliveOpts
  alias TemporalEngineNif.Data.ClientHttpConnectProxyOpts
  alias TemporalEngineNif.Data.ClientDnsLoadBalancingOpts

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

  @type opts() :: [
          {:target_host, String.t()}
          | {:namespace, String.t()}
          | {:client_name, String.t()}
          | {:client_version, String.t()}
          | {:identity, String.t()}
          | {:rpc_retry, ClientRetryOpts.t()}
          | {:headers, %{String.t() => String.t()}}
          | {:binary_headers, %{String.t() => [byte()]}}
          | {:api_key, String.t()}
          | {:tls, ClientTlsOpts.opts()}
          | {:keep_alive, ClientKeepAliveOpts.opts()}
          | {:http_connect_proxy, ClientHttpConnectProxyOpts.opts()}
          | {:dns_load_balancing, ClientDnsLoadBalancingOpts.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    client_opts = struct!(__MODULE__, opts)

    client_opts = update_in(client_opts, [Access.key(:rpc_retry)], &ClientRetryOpts.with_opts!/1)

    client_opts =
      if opts[:tls] do
        update_in(client_opts, [Access.key(:tls)], &ClientTlsOpts.with_opts!/1)
      else
        client_opts
      end

    client_opts =
      if opts[:http_connect_proxy] do
        update_in(
          client_opts,
          [Access.key(:http_connect_proxy)],
          &ClientHttpConnectProxyOpts.with_opts!/1
        )
      else
        client_opts
      end

    client_opts =
      if opts[:keep_alive] do
        update_in(
          client_opts,
          [Access.key(:keep_alive)],
          &ClientKeepAliveOpts.with_opts!/1
        )
      else
        client_opts
      end

    client_opts =
      if opts[:dns_load_balancing] do
        update_in(
          client_opts,
          [Access.key(:dns_load_balancing)],
          &ClientDnsLoadBalancingOpts.with_opts!/1
        )
      else
        client_opts
      end

    client_opts
  end
end
