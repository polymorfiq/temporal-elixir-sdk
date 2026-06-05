defmodule Temporal.Workflows.WorkflowHandle do
  defstruct [:client, :name, :opts]

  alias Temporal.Client

  @type t :: %{client: t(), name: String.t(), module: module() | nil}
  @type handle_opts :: [
          {:name, String.t()}
          | {:module, module()}
        ]

  @spec new(Client.t(), handle_opts()) :: t()
  def new(client, opts) do
    name = Keyword.fetch!(opts, :name)

    %__MODULE__{client: client, name: name, opts: opts}
  end
end
