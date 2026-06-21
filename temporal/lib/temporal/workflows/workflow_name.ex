defprotocol Temporal.Workflows.WorkflowName do
  alias Temporal.Workflows.ActivityName

  @spec server_recognized_name(t()) :: String.t()
  def server_recognized_name(_name)

  @spec workflow_module(t()) :: {:ok, module()} | {:error, term()}
  def workflow_module(_name)

  @spec execution_arities(t()) :: {:ok, [pos_integer()]} | {:error, term()}
  def execution_arities(_name)

  @spec execute_fn(t()) :: {:ok, atom()} | {:error, term()}
  def execute_fn(_name)

  @spec activities(t()) :: {:ok, [ActivityName.t()]} | {:error, term()}
  def activities(_name)
end

defimpl Temporal.Workflows.WorkflowName, for: BitString do
  def server_recognized_name(name), do: {:ok, name}
  def workflow_module(name), do: {:error, "Unknown Workflow Module: #{inspect(name)}"}
  def execute_fn(name), do: {:error, "Unknown Workflow Execution Function: #{inspect(name)}"}

  def execution_arities(name),
    do: {:error, "Unknown Workflow Execution Arities: #{inspect(name)}"}

  def activities(name), do: {:error, "Unknown Workflow Activities: #{inspect(name)}"}
end

defimpl Temporal.Workflows.WorkflowName, for: Atom do
  alias Temporal.Workflows.WorkflowName

  def server_recognized_name(name),
    do: WorkflowName.server_recognized_name({name, :execute})

  def workflow_module(name),
    do: WorkflowName.workflow_module({name, :execute})

  def execute_fn(_name),
    do: {:ok, :execute}

  def execution_arities(name),
    do: WorkflowName.execution_arities({name, :execute})

  def activities(name),
    do: WorkflowName.activities({name, :execute})
end

defimpl Temporal.Workflows.WorkflowName, for: Tuple do
  def server_recognized_name({name, execute_fn}) do
    cond do
      execute_fn == :execute && is_module?(name) &&
          Kernel.function_exported?(name, :workflow_type, 0) ->
        {:ok, name.workflow_type()}

      true ->
        short_name = Module.split(name) |> List.last() |> to_string()

        if execute_fn == :execute do
          {:ok, short_name}
        else
          {:ok, "#{short_name}.#{execute_fn}"}
        end
    end
  end

  def workflow_module({name, _execute_fn}) do
    if is_module?(name),
      do: {:ok, name},
      else: {:error, "Unknown workflow module: #{inspect(name)}"}
  end

  def execution_arities({name, execute_fn}) do
    if is_module?(name) do
      {:ok, name.__info__(:functions) |> Keyword.get_values(execute_fn) |> Enum.uniq()}
    else
      {:error, "Could not find Workflow Module: #{inspect(name)}"}
    end
  end

  def execute_fn({_name, execute_fn}), do: {:ok, execute_fn}

  def activities({name, _execute_fn}) do
    cond do
      is_module?(name) && Kernel.function_exported?(name, :_temporal_activities, 0) ->
        {:ok, apply(name, :_temporal_activities, [])}

      is_module?(name) ->
        {:ok, []}

      true ->
        {:error, :unknown_activities}
    end
  end

  defp is_module?(name) when is_atom(name) do
    _ = Code.ensure_loaded(name)

    Kernel.function_exported?(name, :__info__, 1)
  end

  defp is_module?(_), do: false
end
