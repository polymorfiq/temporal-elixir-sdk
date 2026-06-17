defmodule Temporal.Client do
  defstruct [:identity, :namespace, :runtime_id]

  import TemporalEngine.Runtime

  alias Temporal.Runtime
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.ClientRegistry
  alias Temporal.Constants
  alias Temporal.Runtime
  alias Temporal.Supervisor.ClientSupervisor
  alias Temporal.Supervisor.RuntimeSupervisor
  alias Temporal.Workflows.WorkflowHandle
  alias TemporalEngine.Data.Duration

  @type t :: %__MODULE__{identity: String.t(), namespace: String.t(), runtime_id: String.t()}

  @client_opt_schema NimbleOptions.new!(
                       target_host: [
                         required: true,
                         type: :string,
                         doc: "The server to connect to."
                       ],
                       runtime: [
                         required: false,
                         type: :any,
                         type_doc: "[Runtime.t/0](`t:TemporalEngine.Runtime.t/0`)",
                         doc:
                           "A runtime to spawn the client under. Manages concurrency and resources."
                       ],
                       namespace: [
                         type: :string,
                         default: "default",
                         doc:
                           "The default Temporal service namespace child workers will be bound to"
                       ],
                       client_name: [
                         default: Constants.sdk_name(),
                         type: :string,
                         doc:
                           "The name of the SDK being implemented on top of core. Is set as client-name header in all RPC calls"
                       ],
                       client_version: [
                         default: Constants.sdk_version(),
                         type: :string,
                         doc:
                           "The version of the SDK being implemented on top of core. Is set as client-version header in all RPC calls. The server decides if the client is supported based on this."
                       ],
                       identity: [
                         required: false,
                         type: :string,
                         doc:
                           "A human-readable string that can identify this process. Will default to (SDK)@(HOSTNAME)."
                       ],
                       rpc_retry: [
                         doc: "Retry configuration for the server client.",
                         type: :keyword_list,
                         default: [],
                         keys: [
                           initial_interval: [
                             type: {:tuple, [:pos_integer, {:in, [:seconds, :milliseconds]}]},
                             # 100 ms wait by default.
                             default: {100, :milliseconds},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ],
                           # +-20% jitter.
                           randomization_factor: [type: :float, default: 0.2],
                           #  each next retry delay will increase by 70%
                           multiplier: [type: :float, default: 1.7],
                           # until it reaches 5 seconds
                           max_interval: [
                             type: {:tuple, [:pos_integer, {:in, [:seconds]}]},
                             default: {5, :seconds},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ],
                           # 10 seconds total allocated time for all retries.
                           max_elapsed_time: [
                             type: {:tuple, [:pos_integer, {:in, [:seconds]}]},
                             default: {10, :seconds},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ],
                           max_retries: [type: :pos_integer, default: 10]
                         ]
                       ],
                       headers: [
                         required: false,
                         type: {:map, :string, :string},
                         doc: "HTTP headers to include on every RPC call."
                       ],
                       binary_headers: [
                         required: false,
                         type: {:map, :string, :string},
                         doc:
                           "HTTP headers to include on every RPC call as binary gRPC metadata (encoded as base64)."
                       ],
                       api_key: [
                         required: false,
                         type: :string,
                         doc:
                           "An API key to use for auth. If set, TLS will be enabled by default, but without any mTLS specific settings."
                       ],
                       tls: [
                         required: false,
                         type: :non_empty_keyword_list,
                         doc:
                           "If specified, use TLS as configured by the TlsOptions struct. If this is set core will attempt to use TLS when connecting to the Temporal server. Lang SDK is expected to pass any certs or keys as bytes, loading them from disk itself if needed.",
                         keys: [
                           server_root_ca_cert: [
                             required: true,
                             type: :string,
                             doc:
                               "Bytes representing the root CA certificate used by the server. If not set, and the server’s cert is issued by someone the operating system trusts, verification will still work (ex: Cloud offering)."
                           ],
                           domain: [
                             required: true,
                             type: :string,
                             doc:
                               "Sets the domain name against which to verify the server’s TLS certificate. If not provided, the domain name will be extracted from the URL used to connect."
                           ],
                           client_tls_options: [
                             required: false,
                             type: :non_empty_keyword_list,
                             doc:
                               "TLS info for the client. If specified, core will attempt to use mTLS.",
                             keys: [
                               client_cert: [
                                 required: true,
                                 type: :string,
                                 doc: "The certificate for this client, encoded as PEM"
                               ],
                               client_private_key: [
                                 required: true,
                                 type: :string,
                                 doc: "The private key for this client, encoded as PEM"
                               ]
                             ]
                           ]
                         ]
                       ],
                       keep_alive: [
                         type: :keyword_list,
                         doc: "If set, HTTP2 gRPC keep alive will be enabled",
                         default: [],
                         keys: [
                           interval: [
                             default: {30, :seconds},
                             type:
                               {:tuple,
                                [
                                  :pos_integer,
                                  {:in, [:seconds, :milliseconds]}
                                ]},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ],
                           timeout: [
                             default: {15, :seconds},
                             type:
                               {:tuple,
                                [
                                  :pos_integer,
                                  {:in, [:seconds, :milliseconds]}
                                ]},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ]
                         ]
                       ],
                       http_connect_proxy: [
                         required: false,
                         type: :non_empty_keyword_list,
                         doc: "HTTP CONNECT proxy to use for this client",
                         keys: [
                           target_host: [
                             required: true,
                             type: :string,
                             doc:
                               "The host:port to proxy through for TCP, or unix:/path/to/unix.sock for Unix socket (which means it must start with “unix:/”)."
                           ],
                           basic_auth: [
                             required: false,
                             type: :non_empty_keyword_list,
                             doc: "Optional HTTP basic auth for the proxy as user/pass tuple.",
                             keys: [
                               basic_auth_user: [required: true, type: :string],
                               basic_auth_pass: [required: true, type: :string]
                             ]
                           ]
                         ]
                       ],
                       dns_load_balancing: [
                         type: :keyword_list,
                         default: [],
                         doc:
                           "If set, DNS-based load balancing is enabled. When the target is a hostname (not an IP literal), DNS is resolved to all addresses and requests are distributed across them. Incompatible with `service_override` and `http_connect_proxy`. Setting either in addition to this field is an error. Set to `nil` to disable.",
                         keys: [
                           resolution_interval: [
                             default: {30, :seconds},
                             type:
                               {:tuple,
                                [
                                  :pos_integer,
                                  {:in, [:seconds, :milliseconds]}
                                ]},
                             type_doc:
                               "[Duration.shorthand/0](`t:TemporalEngine.Data.Duration.shorthand/0`)"
                           ]
                         ]
                       ]
                     )

  @typedoc "Supported options:\n#{NimbleOptions.docs(@client_opt_schema)}"
  @type opts :: unquote(NimbleOptions.option_typespec(@client_opt_schema))

  @spec new(target_host :: String.t(), opts()) :: {:ok, t()} | {:error, term()}
  def new(target_host, opts \\ []) do
    opts = Keyword.put(opts, :target_host, target_host)

    opts =
      Keyword.put_new_lazy(opts, :identity, fn ->
        with {:ok, hostname} <- :inet.gethostname() do
          "#{Constants.sdk_name()}-#{Constants.sdk_version()}@#{hostname}"
        else
          _ ->
            "#{Constants.sdk_name()}-#{Constants.sdk_version()}@no-host"
        end
      end)

    with {:ok, validated} <- NimbleOptions.validate(opts, @client_opt_schema) do
      initialize_client(validated)
    else
      {:error, err} -> {:error, {:invalid_opts, err}}
    end
  end

  def stop(client, opts \\ []) do
    if sup = GenServer.whereis({:via, Registry, {ClientRegistry, {:client, client.identity}}}) do
      Supervisor.stop(sup, :shutdown, Keyword.get(opts, :timeout, :infinity))
    else
      {:error, :client_already_stopped}
    end
  end

  def core_runtime(client),
    do: CoreRuntime.existing_for_id(client.runtime_id)

  defp initialize_client(opts) do
    rpc_opts = Keyword.fetch!(opts, :rpc_retry)

    client_opts =
      client_opts(
        target_host: opts[:target_host],
        namespace: opts[:namespace],
        client_name: opts[:client_name],
        client_version: opts[:client_version],
        identity: opts[:identity],
        rpc_retry:
          retry_policy(
            initial_interval: Duration.from_tuple(rpc_opts[:initial_interval]),
            randomization_factor: rpc_opts[:randomization_factor],
            multiplier: rpc_opts[:multiplier],
            max_interval: Duration.from_tuple(rpc_opts[:max_interval]),
            max_elapsed_time: Duration.from_tuple(rpc_opts[:max_elapsed_time]),
            max_retries: rpc_opts[:max_retries]
          ),
        headers: opts[:headers],
        binary_headers: opts[:binary_headers],
        api_key: opts[:api_key],
        tls:
          if(tls_opts = opts[:tls],
            do:
              tls(
                client_cert: tls_opts[:client_cert],
                client_private_key: tls_opts[:client_private_key],
                server_root_ca_cert: tls_opts[:server_root_ca_cert],
                domain: tls_opts[:domain]
              )
          ),
        keep_alive:
          if(keep_alive_opts = opts[:keep_alive],
            do:
              keep_alive(
                interval: Duration.from_tuple(keep_alive_opts[:interval]),
                timeout: Duration.from_tuple(keep_alive_opts[:timeout])
              )
          ),
        http_connect_proxy:
          if(proxy_opts = opts[:http_connect_proxy],
            do:
              http_proxy(
                target_host: proxy_opts[:target_host],
                basic_auth_user: proxy_opts[:basic_auth_user],
                basic_auth_pass: proxy_opts[:basic_auth_pass]
              )
          ),
        dns_load_balancing:
          if(lb_opts = opts[:dns_load_balancing],
            do: lb(resolution_interval: Duration.from_tuple(lb_opts[:resolution_interval]))
          )
      )

    runtime_resp =
      if runtime = Keyword.get(opts, :runtime) do
        {:ok, runtime}
      else
        Runtime.global()
      end

    reg_name = {:via, Registry, {ClientRegistry, {:client, opts[:identity]}}}

    with {:ok, runtime} <- runtime_resp,
         {:ok, runtime_core} <- CoreRuntime.existing_for_id(runtime.id),
         {:ok, clients_sup} <- RuntimeSupervisor.clients_sup_for_id(runtime.id) do
      child_started =
        DynamicSupervisor.start_child(
          clients_sup,
          Supervisor.child_spec(
            {ClientSupervisor,
             {
               runtime_core,
               client_opts,
               [name: reg_name, shutdown: 60_000]
             }},
            restart: :transient
          )
        )

      with {:ok, _} <- child_started do
        {:ok,
         %__MODULE__{
           identity: opts[:identity],
           namespace: opts[:namespace],
           runtime_id: runtime.id
         }}
      end
    end
  end

  @spec workflow(t(), workflow :: module() | String.t(), WorkflowHandle.handle_opts()) ::
          WorkflowHandle.t()
  def workflow(client, workflow, opts \\ []) do
    is_module? = is_atom(workflow) && Kernel.function_exported?(workflow, :__info__, 1)

    workflow_name =
      if is_module? do
        workflow
        |> Module.split()
        |> Enum.join(".")
      else
        "#{workflow}"
      end

    handle_opts = [name: workflow_name]
    handle_opts = if is_module?, do: [{:module, workflow} | handle_opts], else: handle_opts

    WorkflowHandle.new(client, handle_opts ++ opts)
  end

  @spec stop_all_workers(t()) :: :ok
  def stop_all_workers(client) do
    ClientSupervisor.stop_all_workers(client.identity)
  end
end
