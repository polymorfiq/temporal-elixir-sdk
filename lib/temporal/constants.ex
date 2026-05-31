defmodule Temporal.Constants do
  def default_namespace, do: "default"
  def default_worker_heartbeat_interval, do: {30, :second}

  def temporal_prefix, do: "__temporal_"
  def temporal_prefix_error, do: "__temporal_ is a reserved prefix"
  def client_name_header_name, do: "client-name"
  def client_name_header_value, do: "temporal-elixir"
  def client_version_header_name, do: "client-version"
  def supported_versions_header_name, do: "supported-server-versions"

  def sdk_name, do: "temporal-elixir"
  def sdk_version, do: "v#{Application.spec(:temporal)[:vsn]}"

  def default_rpc_timeout_secs, do: 10
  def min_rpc_timeout_secs, do: 1
  def max_rpc_timeout_secs, do: 10
end
