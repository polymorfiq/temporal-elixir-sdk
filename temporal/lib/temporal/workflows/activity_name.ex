defprotocol Temporal.Workflows.ActivityName do
  @spec server_recognized_name(t()) :: String.t()
  def server_recognized_name(_name)

  @spec activity_module(t()) :: {:ok, module()} | {:error, term()}
  def activity_module(_name)

  @spec activity_fn(t()) :: {:ok, atom()} | {:error, term()}
  def activity_fn(_name)

  @spec activity_arities(t()) :: {:ok, [pos_integer()]} | {:error, term()}
  def activity_arities(_name)
end

defimpl Temporal.Workflows.ActivityName, for: BitString do
  def server_recognized_name(name), do: {:ok, name}
  def activity_module(name), do: {:error, "Unknown Activity Module: #{inspect(name)}"}
  def activity_fn(name), do: {:error, "Unknown Activity Function: #{inspect(name)}"}
  def activity_arities(name), do: {:error, "Unknown Activity Arities: #{inspect(name)}"}
end

defimpl Temporal.Workflows.ActivityName, for: Tuple do
  def server_recognized_name({module, activity_fn}) do
    short_name = Module.split(module) |> List.last() |> to_string()
    {:ok, "#{short_name}.#{activity_fn}"}
  end

  def activity_module({module, _activity_fn}) do
    if is_module?(module) do
      {:ok, module}
    else
      {:error, "Not an Activity module: #{inspect(module)}"}
    end
  end

  def activity_fn({module, activity_fn}) do
    cond do
      !is_module?(module) ->
        {:error, "Could not find Activity Module: #{inspect(module)}"}

      !is_atom(activity_fn) ->
        {:error, "Activity Function is not atom: #{inspect(activity_fn)}"}

      !Keyword.has_key?(module.__info__(:functions), activity_fn) ->
        {:error, "Module #{inspect(module)} does not contain Activity Function: #{inspect(activity_fn)}"}

      true ->
        {:ok, activity_fn}
    end
  end

  def activity_arities({module, activity_fn}) do
    if is_module?(module) do
      {:ok, module.__info__(:functions) |> Keyword.get_values(activity_fn) |> Enum.uniq()}
    else
      {:error, "Could not find Activity Module: #{inspect(module)}"}
    end
  end

  defp is_module?(name) when is_atom(name) do
    _ = Code.ensure_loaded(name)

    Kernel.function_exported?(name, :__info__, 1)
  end

  defp is_module?(_), do: false
end
