defmodule Temporal.CoreSdk.CoreClient do
  use GenServer
  defstruct [:core]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.ClientOpts
  alias Temporal.CoreSdk.Data.ClientRetryOpts
  alias Temporal.CoreSdk.Data.ClientKeepAliveOpts
  alias Temporal.CoreSdk.Data.ClientTlsOpts
  alias Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts

  require Record
  Record.defrecordp(:server_state, [:identity, :runtime, :core])

  @type t :: %__MODULE__{core: term()}

  @type client_opts() :: [
          {:target_host, String.t()}
          | {:namespace, String.t()}
          | {:client_name, String.t()}
          | {:client_version, String.t()}
          | {:identity, String.t()}
          | {:rpc_retry, rpc_retry_opts()}
          | {:headers, %{String.t() => String.t()}}
          | {:binary_headers, %{String.t() => [byte()]}}
          | {:api_key, String.t()}
          | {:tls, tls_opts()}
          | {:keep_alive, keepalive_opts()}
          | {:http_connect_proxy, http_proxy_opts()}
          | {:dns_load_balancing, dns_load_balancing_opts()}
        ]

  @type rpc_retry_opts() :: [
          {:initial_interval_secs, float()}
          | {:randomization_factor, float()}
          | {:multiplier, float()}
          | {:max_interval_secs, float()}
          | {:max_elapsed_time_secs, float()}
          | {:max_retries, pos_integer()}
        ]

  @type tls_opts() :: [
          {:client_cert, binary()}
          | {:client_private_key, binary()}
          | {:server_root_ca_cert, binary()}
          | {:domain, String.t()}
        ]

  @type http_proxy_opts() :: [
          {:target_host, String.t()}
          | {:basic_auth_user, String.t()}
          | {:basic_auth_pass, String.t()}
        ]

  @type keepalive_opts() :: [{:interval_secs, float()} | {:timeout_secs, float()}]
  @type dns_load_balancing_opts() :: [{:resolution_interval_secs, float()}]

  @spec start_link({CoreRuntime.t(), client_opts(), keyword()}) :: {:ok, pid()} | {:error, term()}
  def start_link({runtime, opts, server_opts}) do
    GenServer.start_link(__MODULE__, {runtime, opts}, server_opts)
  end

  @impl true
  @spec init({CoreRuntime.t(), opts :: client_opts()}) :: {:ok, t()} | {:error, term()}
  def init({runtime, opts}) do
    parent = self()
    client_opts = struct!(ClientOpts, opts)

    retry_opts = Keyword.fetch!(opts, :rpc_retry)
    client_opts = %{client_opts | rpc_retry: struct!(ClientRetryOpts, retry_opts)}

    Process.set_label({:core_client, client_opts.identity})

    client_opts =
      if tls_opts = opts[:tls] do
        %{client_opts | tls: struct!(ClientTlsOpts, tls_opts)}
      else
        client_opts
      end

    client_opts =
      if http_proxy_opts = opts[:http_connect_proxy] do
        %{client_opts | http_connect_proxy: struct!(ClientTlsOpts, http_proxy_opts)}
      else
        client_opts
      end

    client_opts =
      if keepalive = opts[:keep_alive] do
        %{client_opts | keep_alive: struct!(ClientKeepAliveOpts, keepalive)}
      else
        client_opts
      end

    client_opts =
      if dns_lb = opts[:dns_load_balancing] do
        %{client_opts | keep_alive: struct!(ClientDnsLoadBalancingOpts, dns_lb)}
      else
        client_opts
      end

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_client(runtime.core, client_opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize client from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, client} ->
            send(parent, {self(), {:ok, client}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    client_resp =
      receive do
        {^pid, response} ->
          response

        {:DOWN, ^ref, :process, ^pid, reason} ->
          {:error, reason}
      end

    with {:ok, core} <- client_resp do
      {:ok, server_state(identity: client_opts.identity, runtime: runtime, core: core)}
    end
  end

  def get_core(pid), do: GenServer.call(pid, :get_core)
  def get_identity(pid), do: GenServer.call(pid, :get_identity)

  @impl true
  def handle_call(:get_core, _from, state),
    do: {:reply, {:ok, %__MODULE__{core: server_state(state, :core)}}, state}

  @impl true
  def handle_call(:get_identity, _from, state),
    do: {:reply, {:ok, server_state(state, :identity)}, state}

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state),
      do: {:noreply, state}
end
