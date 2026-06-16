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
    structdoc :: @structdoc extract!(contents)
    require :: @required extract!(is_required)
    default :: @default :: extract!(value)
    required_field :: @type extract!(type_name) :: required :: extract!(typespec)
    field :: @type extract!(type_name) :: extract!(typespec)
  end

  defmacro deftype(name, do: do_block) do
    extracted =
      extract_with_patterns(@patterns, do_block)
      |> IO.inspect(label: "DEFAULT", limit: :infinity)
      |> Enum.chunk_while(
        %{},
        fn
          {:structdoc, tag}, acc ->
            {:cont, %{structdoc: tag[:contents]}, acc}

          {:required_field, tag}, acc ->
            {:cont, Map.merge(acc, %{field: tag, required: true}), %{}}

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
      Enum.filter(extracted, & &1[:field])

    field_names =
      fields
      |> Enum.map(& &1[:field][:type_name])
      |> Enum.map(&elem(&1, 0))

    fields_to_types =
      fields
      |> Enum.map(
        &{
          elem(&1[:field][:type_name], 0),
          if(&1[:required], do: &1.field[:typespec], else: {:|, [], [&1.field[:typespec], nil]})
        }
      )

    structdoc = Enum.find_value(extracted, & &1[:structdoc])

    fields_to_docs =
      fields
      |> Enum.map(fn
        %{doc: doc} = f ->
          """
          **`#{elem(f.field[:type_name], 0)}`** #{if(f[:required], do: "*[required]*", else: "")} #{if(f[:default], do: "*(default*: #{inspect(f[:default][:value])})", else: "")}


          #{doc[:contents]}
          """

        f ->
          """
          **`#{elem(f.field[:type_name], 0)}`** #{if(f[:required], do: "*[required]*", else: "")} #{if(f[:default], do: "(*default*: #{inspect(f[:default][:value])})", else: "")}
          """
      end)

    map_ast = {:%{}, [], Enum.map(fields_to_types, fn {k, v} -> {k, v} end)}

    quote do
      @typedoc unquote(~s|#{structdoc}\n\n---\n\n#{Enum.join(fields_to_docs, "\n\n")}|)
      @type unquote({name, [], nil}) ::
              record(unquote(name), unquote(fields_to_types))

      @doc "#{unquote(structdoc)}\n\nSee `t:#{unquote(name)}/0` for more details."
      Record.defrecord(unquote(name), unquote(field_names))

      defmodule unquote(Module.concat([__CALLER__.module, Macro.camelize("#{name}")])) do
        @moduledoc unquote(~s|#{structdoc}\n\n|)

        @typedoc unquote(~s|#{Enum.join(fields_to_docs, "\n\n")}|)
        @type t() :: unquote(map_ast)

        defstruct unquote(field_names)
      end
    end
  end
end
