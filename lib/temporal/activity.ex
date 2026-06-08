defmodule Temporal.Activity do
  def name_for_type(activity_type) do
    cond do
      is_binary(activity_type) ->
        {:ok, activity_type}

      is_function(activity_type) ->
        {:module, module_name} = Function.info(activity_type, :module)
        {:name, function_name} = Function.info(activity_type, :name)
        {:arity, arity} = Function.info(activity_type, :arity)

        module_name =
          case "#{module_name}" do
            "Elixir." <> name -> name
            other -> other
          end

        "&#{module_name}.#{function_name}/#{arity}"

      is_atom(activity_type) ->
        {:ok, "#{activity_type}"}
    end
  end
end
