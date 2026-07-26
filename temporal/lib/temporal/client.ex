defmodule Temporal.Client do
  @moduledoc """
  Contains an instance of a namespace-bound client for interacting with the Temporal server.

  Can be utilized to create workers or start/interact with Temporal Workflows.
  """

  import TemporalEngine.Data.Queries
  import TemporalEngine.Data.Updates
  import TemporalEngine.Data.Signals

  require TemporalEngine.Data.Queries
  require TemporalEngine.Data.Failure
  require TemporalEngine.Opts.ClientOpts
  require TemporalEngine.Opts.WorkflowOpts
  require TemporalEngine.WorkflowHandle

  alias Temporal.Constants
  alias Temporal.Converter.DefaultDataConverter
  alias Temporal.Runtime
  alias Temporal.Workflows.WorkflowName
  alias TemporalEngine.Converter.DataConverter
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Queries
  alias TemporalEngine.Data.Signals
  alias TemporalEngine.Data.Updates
  alias TemporalEngine.Opts.{ClientOpts, WorkflowOpts}
  alias TemporalEngine.WorkflowHandle

  @opaque t :: TemporalEngine.Client.t()

  @typedoc "A target URI where the Temporal Server can be found. Such as 'localhost:7233'"
  @type target :: String.t()

  @doc "Creates a new instance of a Temporal Client"
  @spec new(target :: String.t(), [ClientOpts.connection_opts_opt() | {:runtime, Runtime.t()}]) ::
          {:ok, t()} | {:error, term()}
  def new(target, opts \\ []) do
    opts = opts ++ [target: target]
    opts = ensure_identity(opts)

    {extra_opts, opts} = Keyword.split(opts, [:runtime])
    {runtime_opts, opts} = Keyword.split(opts, [:engine])

    {data_converter_opts, opts} = Keyword.split(opts, [:data_converter])

    data_converter =
      Keyword.get_lazy(data_converter_opts, :data_converter, fn ->
        %DefaultDataConverter{}
      end)

    runtime =
      Keyword.get_lazy(extra_opts, :runtime, fn ->
        Runtime.global(runtime_opts)
      end)

    with {:ok, validated} <- ClientOpts.connection_opts_from_opts(opts) do
      TemporalEngine.Runtime.create_client(runtime,
        connection: validated,
        data_converter: data_converter
      )
    end
  end

  @doc "Creates a new instance of a Temporal Client"
  @spec new!(target :: String.t(), [ClientOpts.connection_opts_opt() | {:runtime, Runtime.t()}]) ::
          t()
  def new!(target, opts \\ []),
    do: new(target, opts) |> then(fn {:ok, client} -> client end)

  @spec execute_workflow(
          t(),
          WorkflowName.t(),
          inputs :: [term()],
          [WorkflowOpts.workflow_start_opts_opt()]
        ) :: {:ok, WorkflowHandle.t()} | {:error, term()}
  def execute_workflow(client, name, inputs, opts) do
    {:ok, name} = WorkflowName.server_recognized_name(name)

    conv = TemporalEngine.Client.data_converter(client)
    {:ok, args} = DataConverter.to_payloads(conv, inputs)
    definition = WorkflowOpts.workflow_definition(name: name)

    with {:ok, opts} <- WorkflowOpts.workflow_start_opts_from_opts(opts) do
      TemporalEngine.Client.start_workflow(client, definition, args, opts)
    end
  end

  @spec query_workflow(
          WorkflowHandle.t(),
          query_name :: atom() | String.t(),
          query_args :: [term()],
          query_opts :: [Queries.query_options_opt()]
        ) :: {:ok, term()} | {:error, term()}
  def query_workflow(handle, query_name, query_args \\ [], query_opts \\ []) do
    client = WorkflowHandle.client(handle)
    conv = TemporalEngine.Client.data_converter(client)
    {:ok, args} = DataConverter.to_payloads(conv, query_args)

    with {:ok, opts} <- Queries.query_options_from_opts(query_opts) do
      resp = TemporalEngine.WorkflowHandle.query(handle, "#{query_name}", args, opts)

      case resp do
        {:ok, query_workflow_response(query_rejected: query_rejected(status: status))} ->
          {:error, status}

        {:ok, query_workflow_response(query_result: [result])} ->
          val =
            if result do
              {:ok, decoded} = DataConverter.from_payload(conv, result)
              decoded
            else
              nil
            end

          case val do
            {:error, Failure.failure() = failure} ->
              {:error, Failure.to_map(failure) |> Map.put(:error_code, :query_failed)}

            {:error, err} ->
              {:error, err}

            _ ->
              {:ok, val}
          end

        {:error, err} ->
          {:error, err}
      end
    end
  end

  @spec update_workflow(
          WorkflowHandle.t(),
          update_name :: atom() | String.t(),
          update_args :: [term()],
          update_opts :: [Updates.update_options_opt()]
        ) :: {:ok, term()} | {:error, term()}
  def update_workflow(handle, update_name, update_args \\ [], update_opts \\ []) do
    client = WorkflowHandle.client(handle)
    conv = TemporalEngine.Client.data_converter(client)
    {:ok, args} = DataConverter.to_payloads(conv, update_args)

    update_opts = Keyword.put_new_lazy(update_opts, :id, fn -> random_string(10) end)

    with {:ok, opts} <- Updates.update_options_from_opts(update_opts) do
      resp = TemporalEngine.WorkflowHandle.update(handle, "#{update_name}", args, opts)

      case resp do
        {:ok,
         workflow_update_response(outcome: update_outcome(value: Failure.failure() = failure))} ->
          {:error, failure}

        {:ok, workflow_update_response(stage: :admitted)} ->
          {:error, {:status, :admitted}}

        {:ok, workflow_update_response(stage: :accepted)} ->
          {:error, {:status, :accepted}}

        {:ok,
         workflow_update_response(outcome: update_outcome(value: [result]), stage: :completed)} ->
          {:ok, val} = DataConverter.from_payload(conv, result)

          case val do
            {:error, Failure.failure() = failure} ->
              {:error, Failure.to_map(failure) |> Map.put(:error_code, :query_failed)}

            {:error, err} ->
              {:error, err}

            _ ->
              {:ok, val}
          end

        {:error, err} ->
          {:error, err}
      end
    end
  end

  @spec signal_workflow(
          WorkflowHandle.t(),
          signal_name :: atom() | String.t(),
          signal_args :: [term()],
          signal_opts :: [Signals.signal_workflow_request_opt()]
        ) :: {:ok, term()} | {:error, term()}
  def signal_workflow(handle, signal_name, signal_args \\ [], signal_opts \\ []) do
    client = WorkflowHandle.client(handle)
    conv = TemporalEngine.Client.data_converter(client)
    {:ok, args} = DataConverter.to_payloads(conv, signal_args)

    signal_opts = Keyword.merge(signal_opts, signal_name: "#{signal_name}", input: signal_args)
    signal_opts = Keyword.put_new_lazy(signal_opts, :request_id, fn -> random_string(10) end)

    with {:ok, opts} <- Signals.signal_workflow_request_from_opts(signal_opts) do
      resp = TemporalEngine.WorkflowHandle.signal(handle, "#{signal_name}", args, opts)

      case resp do
        {:ok, signal_workflow_response(link: link)} ->
          {:ok, link}

        {:error, err} ->
          {:error, err}
      end
    end
  end

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

  defp random_string(size) do
    symbols = ~c"0123456789abcdef"
    symbol_count = Enum.count(symbols)
    for _ <- 1..size, into: "", do: <<Enum.at(symbols, :rand.uniform(symbol_count) - 1)>>
  end
end
