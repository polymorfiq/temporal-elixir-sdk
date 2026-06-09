defmodule Temporal.Activity do
  defmacro __using__(opts) do
    activities = Keyword.get(opts, :activities)

    if activities do
      quote do
        def _temporal_activities, do: unquote(activities)
      end
    end
  end

  def name_for_type(activity_type) do
    cond do
      is_binary(activity_type) ->
        {:ok, activity_type}

      is_function(activity_type) ->
        {:module, module_name} = Function.info(activity_type, :module)
        {:name, function_name} = Function.info(activity_type, :name)
        {:arity, arity} = Function.info(activity_type, :arity)

        module_name = Module.split(module_name) |> List.last()

        "#{module_name}.#{function_name}/#{arity}"

      is_atom(activity_type) ->
        {:ok, "#{activity_type}"}
    end
  end
end
