defmodule TemporalEngineNif.Runtime do
  defstruct [:id, :core]

  @type t :: %{core: term()}
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

    {pid, ref} =
      spawn_monitor(fn ->
        Core._create_client(runtime.core, client_opts, self())
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
                  id: connection_opts(client_opts, :identity),
                  core: client,
                  runtime: runtime,
                  namespace: connection_opts(client_opts, :namespace)
                }}}
            )

          {:error, err} ->
            send(parent, {self(), {:error, err}})
        end
      end)

    receive do
      {^pid, response} ->
        Process.demonitor(ref)
        response

      {:DOWN, ^ref, :process, ^pid, reason} ->
        {:error, reason}
    end
  end
end
