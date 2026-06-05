defmodule Temporal.CoreSdk.CoreClient do
  defstruct [:runtime, :client]

  alias Temporal.CoreSdk
  alias Temporal.CoreSdk.CoreRuntime
  alias Temporal.CoreSdk.Data.ClientOpts

  @type t :: %__MODULE__{
          runtime: CoreRuntime.t(),
          client: term()
        }

  @spec new(runtime :: CoreRuntime.t(), opts :: ClientOpts.t()) :: {:ok, t()} | {:error, term()}
  def new(runtime, opts) do
    parent = self()

    {pid, ref} =
      spawn_monitor(fn ->
        CoreSdk._create_client(runtime.core, opts, self())
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

    with {:ok, client} <- client_resp do
      {:ok, %__MODULE__{runtime: runtime, client: client}}
    end
  end
end
