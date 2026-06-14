defmodule TemporalEngineNif.Runtime do
  defstruct [:core]

  @type t :: %{core: term()}
end

defimpl TemporalEngine.Runtime, for: TemporalEngineNif.Runtime do
  import TemporalEngine.Runtime
  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Data.ClientOpts
  alias TemporalEngineNif.Data.Duration
  alias TemporalEngineNif.Client

  @impl true
  def create_client(runtime, opts) do
    client_opts = %ClientOpts{
      target_host: client_opts(opts, :target_host),
      namespace: client_opts(opts, :namespace),
      client_name: client_opts(opts, :client_name),
      client_version: client_opts(opts, :client_version),
      identity: client_opts(opts, :identity),
      rpc_retry: client_opts(opts, :rpc_retry) |> to_opts(),
      headers: client_opts(opts, :headers),
      binary_headers: client_opts(opts, :binary_headers),
      api_key: client_opts(opts, :api_key),
      tls: client_opts(opts, :tls) |> to_opts(),
      keep_alive: client_opts(opts, :keep_alive) |> to_opts(),
      http_connect_proxy: client_opts(opts, :http_connect_proxy) |> to_opts(),
      dns_load_balancing: client_opts(opts, :dns_load_balancing) |> to_opts()
    }

    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_client(runtime.core, client_opts, self())
        |> case do
          {:ok, _} -> :ok
          {:error, err} -> raise "Could initialize client from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, client} ->
            send(parent, {self(), {:ok, %Client{core: client, runtime: runtime}}})

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end

  defp to_opts(nil), do: nil

  defp to_opts(retry_policy() = policy) do
    %TemporalEngineNif.Data.ClientRetryOpts{
      initial_interval: Duration.from_record(retry_policy(policy, :initial_interval)),
      randomization_factor: retry_policy(policy, :randomization_factor),
      multiplier: retry_policy(policy, :multiplier),
      max_interval: Duration.from_record(retry_policy(policy, :max_interval)),
      max_elapsed_time: Duration.from_record(retry_policy(policy, :max_elapsed_time)),
      max_retries: retry_policy(policy, :max_retries)
    }
  end

  defp to_opts(tls() = opts) do
    %TemporalEngineNif.Data.ClientTlsOpts{
      client_cert: tls(opts, :client_cert),
      client_private_key: tls(opts, :client_private_key),
      server_root_ca_cert: tls(opts, :server_root_ca_cert),
      domain: tls(opts, :domain)
    }
  end

  defp to_opts(keep_alive() = opts) do
    %TemporalEngineNif.Data.ClientKeepAliveOpts{
      interval: Duration.from_record(keep_alive(opts, :interval)),
      timeout: Duration.from_record(keep_alive(opts, :timeout))
    }
  end

  defp to_opts(http_proxy() = opts) do
    %TemporalEngineNif.Data.ClientHttpConnectProxyOpts{
      target_host: http_proxy(opts, :target_host),
      basic_auth_user: http_proxy(opts, :basic_auth_user),
      basic_auth_pass: http_proxy(opts, :basic_auth_pass)
    }
  end

  defp to_opts(lb() = opts) do
    %TemporalEngineNif.Data.ClientDnsLoadBalancingOpts{
      resolution_interval: Duration.from_record(lb(opts, :resolution_interval))
    }
  end
end
