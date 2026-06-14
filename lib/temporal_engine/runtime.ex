defprotocol TemporalEngine.Runtime do
  alias TemporalEngine.Client
  alias TemporalEngine.Data.Duration

  require Record

  Record.defrecord(:client_opts, [
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
  ])

  @type client_opts ::
          record(:client_opts,
            target_host: String.t(),
            namespace: String.t(),
            client_name: String.t(),
            client_version: String.t(),
            identity: String.t(),
            rpc_retry: retry_policy(),
            headers: %{String.t() => String.t()} | nil,
            binary_headers: %{String.t() => binary()} | nil,
            api_key: String.t() | nil,
            tls: tls() | nil,
            keep_alive: keep_alive() | nil,
            http_connect_proxy: http_proxy() | nil,
            dns_load_balancing: lb() | nil
          )

  Record.defrecord(:retry_policy, [
    :initial_interval,
    :randomization_factor,
    :multiplier,
    :max_interval,
    :max_elapsed_time,
    :max_retries
  ])

  @type retry_policy ::
          record(:retry_policy,
            initial_interval: Duration.t(),
            randomization_factor: float(),
            multiplier: float(),
            max_interval: Duration.t(),
            max_elapsed_time: Duration.t(),
            max_retries: pos_integer()
          )

  Record.defrecord(:tls,
    client_cert: nil,
    client_private_key: nil,
    server_root_ca_cert: nil,
    domain: nil
  )

  @type tls ::
          record(:tls,
            client_cert: binary(),
            client_private_key: binary(),
            server_root_ca_cert: binary(),
            domain: String.t()
          )

  Record.defrecord(:keep_alive, [:interval, :timeout])

  @type keep_alive ::
          record(:keep_alive,
            interval: Duration.t(),
            timeout: Duration.t()
          )

  Record.defrecord(:http_proxy, [:target_host, basic_auth_user: nil, basic_auth_pass: nil])

  @type http_proxy ::
          record(:http_proxy,
            target_host: String.t(),
            basic_auth_user: String.t() | nil,
            basic_auth_pass: String.t() | nil
          )

  Record.defrecord(:lb, [:resolution_interval])
  @type lb :: record(:lb, resolution_interval: Duration.t())

  @spec create_client(t(), client_opts()) :: {:ok, Client.t()} | {:error, reason :: term()}
  def create_client(runtime, opts)
end
