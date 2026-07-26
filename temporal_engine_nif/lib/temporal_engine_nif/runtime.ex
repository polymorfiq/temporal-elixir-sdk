defmodule TemporalEngineNif.Runtime do
  defstruct [:id, :core]

  @type t :: %__MODULE__{id: term(), core: term()}
end

defimpl TemporalEngine.Runtime, for: TemporalEngineNif.Runtime do
  import TemporalEngine.Opts.ClientOpts

  alias TemporalEngineNif.Core
  alias TemporalEngineNif.Client

  @impl true
  def id(runtime), do: runtime.id

  @impl true
  def create_client(runtime, client_opts) do
    parent = self()

    conn_opts = Keyword.fetch!(client_opts, :connection)
    converter = Keyword.fetch!(client_opts, :data_converter)

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_client(runtime.core, conn_opts, self())
        |> case do
          :ok -> :ok
          {:error, err} -> raise "Could initialize client from Core SDK: #{inspect(err)}"
        end

        receive do
          {:ok, client} ->
            send(
              parent,
              {self(),
               {:ok,
                %Client{
                  id: connection_opts(conn_opts, :identity),
                  core: client,
                  runtime: runtime,
                  namespace: connection_opts(conn_opts, :namespace),
                  data_converter: converter
                }}}
            )

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        Process.demonitor(ref, [:flush])
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end
end
