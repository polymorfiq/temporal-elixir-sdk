defmodule TemporalEngine.Opts.ClientOpts do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Constants
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Opts.ClientOpts

  deftype :runtime_opts do
    @doc "A unique identifier for this Runtime"
    @type id :: required :: String.t()

    @doc "Optional worker heartbeat interval - This configures the heartbeat setting of all workers created using this runtime."
    @default [seconds: 30]
    @type heartbeat_interval :: nested!(Duration.duration())
  end

  deftype :connection_opts do
    @doc "The server to connect to."
    @type target :: required :: String.t()

    @doc "Namespace the client will connect to"
    @default "default"
    @type namespace :: required :: String.t()

    @doc "A human-readable string that can identify this process. Defaults to empty string."
    @default ""
    @type identity :: required :: String.t()

    @doc "Name of the client (Lang SDK)"
    @default Constants.sdk_name()
    @type client_name :: required :: String.t()

    @doc "Version of the client (Lang SDK)"
    @default Constants.sdk_version()
    @type client_version :: required :: String.t()

    @doc """
    If specified, use TLS as configured by the TlsOptions struct.

    If this is set core will attempt to use TLS when connecting to the Temporal server.

    Lang SDK is expected to pass any certs or keys as bytes, loading them from disk itself if needed.
    """
    @type tls_options :: nested!(ClientOpts.tls_opts())

    @doc """
    If set, override the origin used when connecting.

    May be useful in rare situations where tls verification needs to use a different name from what should be set as the :authority header.

    If TlsOptions::domain is set, and this is not, this will be set to https://<domain>, effectively making the :authority header consistent with the domain override.
    """
    @type override_origin :: String.t()

    @doc "An API key to use for auth. If set, TLS will be enabled by default, but without any mTLS specific settings."
    @type api_key :: String.t()

    @doc "Retry configuration for the server client. Default is RetryOptions::default"
    @default [
      initial_interval: [seconds: 0, nanos: 100_000_000],
      randomization_factor: 0.2,
      multiplier: 1.7,
      max_interval: [seconds: 5, nanos: 0],
      max_elapsed_time: [seconds: 10, nanos: 0],
      max_retries: 10
    ]

    @type retry_options :: nested!(ClientOpts.retry_opts())

    @doc "If set, HTTP2 gRPC keep alive will be enabled."
    @default [
      interval: [seconds: 30, nanos: 0],
      timeout: [seconds: 15, nanos: 0]
    ]
    @type keep_alive :: nested!(ClientOpts.keep_alive_opts())

    @doc """
    HTTP headers to include on every RPC call.

    These must be valid gRPC metadata keys, and must not be binary metadata keys (ending in `-bin`). To set binary headers, use `:binary_headers`.

    Invalid header keys or values will cause an error to be returned when connecting.
    """
    @type headers :: %{String.t() => String.t()}

    @doc """
    HTTP headers to include on every RPC call as binary gRPC metadata (encoded as base64).

    These must be valid binary gRPC metadata keys (and end with a -bin suffix).

    Invalid header keys will cause an error to be returned when connecting.
    """
    @type binary_headers :: %{String.t() => binary()}

    @doc "HTTP CONNECT proxy to use for this client."
    @type http_connect_proxy :: nested!(ClientOpts.http_proxy_opts())

    @doc """
    If set, DNS-based load balancing is enabled.

    When the target is a hostname (not an IP literal), DNS is resolved to all addresses and requests are distributed across them.

    Incompatible with `:service_override` and `:http_connect_proxy`. Setting either in addition to this field is an error. Set to `nil` to disable.
    """
    @default [resolution_interval: [seconds: 30, nanos: 0]]
    @type dns_load_balancing :: nested!(ClientOpts.dns_lb_opts())

    @doc "If set true, error code labels will not be included on request failure metrics."
    @default false
    @type disable_error_code_metric_tags :: bool()
  end

  deftype :tls_opts do
    @doc "Bytes representing the root CA certificate used by the server. If not set, and the server’s cert is issued by someone the operating system trusts, verification will still work (ex: Cloud offering)."
    @type server_root_ca_cert :: binary()

    @doc "Sets the domain name against which to verify the server’s TLS certificate. If not provided, the domain name will be extracted from the URL used to connect."
    @type domain :: binary()

    @doc "TLS info for the client. If specified, core will attempt to use mTLS."
    @type client_tls_options :: nested!(ClientOpts.client_tls_opts())
  end

  deftype :client_tls_opts do
    @structdoc "If using mTLS, both the client cert and private key must be specified, this contains them."

    @doc "The certificate for this client, encoded as PEM"
    @type client_cert :: required :: binary()

    @doc "client_private_key"
    @type client_private_key :: required :: binary()
  end

  deftype :retry_opts do
    @structdoc "Configuration for retrying requests to the server"

    @doc "initial wait time before the first retry."
    @type initial_interval :: required :: nested!(Duration.duration())

    @doc "Randomization jitter that is used as a multiplier for the current retry interval and is added or subtracted from the interval length."
    @type randomization_factor :: required :: float()

    @doc "Rate at which retry time should be increased, until it reaches max_interval."
    @type multiplier :: required :: float()

    @doc "Maximum amount of time to wait between retries."
    @type max_interval :: required :: nested!(Duration.duration())

    @doc "Maximum total amount of time requests should be retried for, if None is set then no limit will be used."
    @type max_elapsed_time :: nested!(Duration.duration())

    @doc "Maximum number of retry attempts."
    @type max_retries :: non_neg_integer()
  end

  deftype :keep_alive_opts do
    @structdoc "Client keep alive configuration."

    @doc "Interval to send HTTP2 keep alive pings."
    @type interval :: required :: nested!(Duration.duration())

    @doc "Timeout that the keep alive must be responded to within or the connection will be closed."
    @type timeout :: required :: nested!(Duration.duration())
  end

  deftype :http_proxy_opts do
    @structdoc "Options for HTTP CONNECT proxy."

    @doc "The host:port to proxy through for TCP, or unix:/path/to/unix.sock for Unix socket (which means it must start with “unix:/”)."
    @type target_addr :: required :: String.t()

    @doc "Optional HTTP basic auth for the proxy as user/pass tuple."
    @type basic_auth :: {String.t(), String.t()}
  end

  deftype :dns_lb_opts do
    @doc "How often to re-resolve DNS. Defaults to 30 seconds."
    @type resolution_interval :: required :: nested!(Duration.duration())
  end
end
