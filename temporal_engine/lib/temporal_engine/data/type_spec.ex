defmodule TemporalEngine.Data.TypeSpec do
  import TemporalEngine.Helpers.CodePatterns

  defmacro __using__(_opts) do
    quote do
      require Record
      import TemporalEngine.Data.TypeSpec
    end
  end

  patterns(:patterns) do
    doc :: @doc extract!(contents)
    require :: @required extract!(is_required)
    field :: @type extract!(type_name) :: extract!(typespec)
  end

  defmacro deftype(name, do: do_block) do
    extracted =
      extract_with_patterns(@patterns, do_block)
      |> Enum.chunk_while(
        %{},
        fn
          {:field, tag}, acc ->
            {:cont, Map.put(acc, :field, tag), %{}}

          {tag_type, tag}, acc ->
            {:cont, Map.put(acc, tag_type, tag)}
        end,
        fn
          %{} -> {:cont, %{}}
          acc -> {:cont, acc, %{}}
        end
      )

    fields =
      Enum.filter(extracted, & &1.field)
      |> Enum.map(& &1.field[:type_name])
      |> Enum.map(&elem(&1, 0))

    fields_to_types =
      Enum.filter(extracted, & &1.field)
      |> Enum.map(
        &{
          elem(&1.field[:type_name], 0),
          if(&1[:require], do: &1.field[:typespec], else: {:|, [], [&1.field[:typespec], nil]})
        }
      )

    quote do
      @type unquote({name, [], nil}) ::
              record(unquote(name), unquote(fields_to_types))

      Record.defrecord(unquote(name), unquote(fields))
    end
  end
end
