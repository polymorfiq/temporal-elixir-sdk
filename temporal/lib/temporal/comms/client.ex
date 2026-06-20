defmodule Temporal.Comms.Client do
  @moduledoc """
  Contains an instance of a namespace-bound client for interacting with the Temporal server.

  Can be utilized to create workers or start/interact with Temporal Workflows.
  """

  require TemporalEngine.Opts.ClientOpts

  alias Temporal.Constants
  alias Temporal.Comms.Runtime
  alias TemporalEngine.Opts.ClientOpts

  @opaque t :: TemporalEngine.Client.t()

  @typedoc "A target URI where the Temporal Server can be found. Such as 'localhost:7233'"
  @type target :: String.t()

  @doc "Creates a new instance of a Temporal Client"
  @spec new(target :: String.t(), ClientOpts.connection_opts()) :: {:ok, t()} | {:error, term()}
  def new(target, opts \\ []) do
    opts = opts ++ [target: target]
    opts = ensure_identity(opts)
    {runtime_opts, opts} = Keyword.split(opts, [:runtime])

    runtime = Keyword.get_lazy(runtime_opts, :runtime, fn ->
      Runtime.global()
    end)

    with {:ok, validated} <- ClientOpts.connection_opts_from_opts(opts) do
      TemporalEngine.Runtime.create_client(runtime, validated)
    end
  end

  @doc "Creates a new instance of a Temporal Client"
  @spec new!(target :: String.t(), ClientOpts.connection_opts()) :: t()
  def new!(target, opts \\ []),
      do: new(target, opts) |> then(fn {:ok, client} -> client end)

  defp ensure_identity(opts) do
    Keyword.put_new_lazy(opts, :identity, fn ->
      with {:ok, hostname} <- :inet.gethostname() do
        "#{Constants.sdk_name()}-#{Constants.sdk_version()}@#{hostname}"
      else
        _ ->
          "#{Constants.sdk_name()}-#{Constants.sdk_version()}@no-host"
      end
    end)
  end
end