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
    default :: @default extract!(value)
    deprecated :: @deprecated :: extract!(message)
    required_field :: @type extract!(type_name) :: required :: extract!(typespec)
    field :: @type extract!(type_name) :: extract!(typespec)
  end

  defmacro deftype(name, do: do_block) do
    extracted =
      extract_with_patterns(@patterns, do_block)
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
      |> Enum.map(fn
        %{field: field, default: default} ->
          {elem(field[:type_name], 0), default[:value]}

        %{field: field, required: _} ->
          elem(field[:type_name], 0)

        %{field: field} ->
          {elem(field[:type_name], 0), nil}
      end)

    fields_to_types =
      fields
      |> Enum.map(fn field ->
        typespec = if field[:required] do
          field.field[:typespec]
        else
          {:|, [], [field.field[:typespec], nil]}
        end

        {field[:field][:type_name], typespec}
      end)

    expanded_field_types =
      fields
      |> Enum.map(fn field ->
        typespec = expand_aliases(field.field[:typespec], __CALLER__)
        typespec = if field[:required] do
          typespec
        else
          {:|, [], [typespec, nil]}
        end

        {field[:field][:type_name], typespec}
      end)

    structdoc = Enum.find_value(extracted, & &1[:structdoc])

    fields_to_docs =
      fields
      |> Enum.map(fn
        %{doc: doc} = f ->
          """
          **`#{elem(f.field[:type_name], 0)}`** #{if(f[:required], do: "*[required]*", else: "")} #{if(f[:default], do: "*(default*: #{inspect(f[:default][:value])})", else: "")}


          #{doc[:contents]}
          #{if(f[:deprecated], do: "\n**Deprecated:** #{inspect(f[:deprecated][:message])})", else: "")}
          """

        f ->
          """
          **`#{elem(f.field[:type_name], 0)}`** #{if(f[:required], do: "*[required]*", else: "")} #{if(f[:default], do: "(*default*: #{inspect(f[:default][:value])})", else: "")}
          """
      end)

    map_ast =
      {:%, [],
       [{:__MODULE__, [], Elixir}, {:%{}, [], Enum.map(fields_to_types, fn {k, v} -> {k, v} end)}]}

    validate_opts_name = :"validate_#{name}_opts"
    field_types_name = :"get_#{name}_field_types"
    quote do
      @typedoc unquote(~s|#{structdoc}\n\n---\n\n#{Enum.join(fields_to_docs, "\n\n")}|)
      @type unquote({name, [], nil}) ::
              record(unquote(name), unquote(fields_to_types))

      @doc "#{unquote(structdoc)}\n\nSee `t:#{unquote(name)}/0` for more details."
      Record.defrecord(unquote(name), unquote(field_names))

      @doc false
      @spec unquote(validate_opts_name)(opts :: keyword()) :: {:ok, validated :: keyword()} | {:error, term()}
      def unquote(validate_opts_name)(opts),
          do: TemporalEngine.Data.TypeSpec.validate(opts, __MODULE__, unquote(name), unquote(field_names))

      @doc false
      @spec unquote(field_types_name)() :: term()
      def unquote(field_types_name)(),
          do: unquote(Macro.escape(expanded_field_types))

      defmodule unquote(Module.concat([__CALLER__.module, Macro.camelize("#{name}")])) do
        @moduledoc unquote(~s|#{structdoc}\n\n|)

        @typedoc unquote(~s|#{Enum.join(fields_to_docs, "\n\n")}|)
        @type t() :: unquote(Macro.expand(map_ast, __CALLER__))

        defstruct unquote(field_names)
      end
    end
  end

  @type field_names :: [atom() | {atom(), default :: term()}]
  @spec validate(opts :: keyword(), caller :: module(), name :: atom(), field_names :: field_names()) :: {:ok, validated :: keyword()} | {:error, term()}
  def validate(opts, caller, name, field_names) do
    valid_fields = Enum.map(field_names, fn
      name when is_atom(name) -> name
      {name, _default} when is_atom(name) -> name
    end)

    field_types = apply(caller, :"get_#{name}_field_types", [])
    field_types |> IO.inspect(label: "HMMm")

    unknown_options = Keyword.drop(opts, valid_fields)

    cond do
      Enum.any?(unknown_options) ->
        {:error, "Unexpected fields given for #{name} - #{inspect(unknown_options)}"}
    end

    {:ok, opts}
  end

  defp expand_aliases(asts, env) when is_list(asts) do
    Enum.map(asts, &expand_aliases(&1, env))
  end

  defp expand_aliases({:%{}, meta, [{key, value}]}, env) do
    {:%{}, meta, [{expand_aliases(key, env), expand_aliases(value, env)}]}
  end

  defp expand_aliases({:__aliases__, meta, ast_aliases}, env) do
    new_aliases = Enum.map(ast_aliases, fn curr ->
      with {:ok, expanded} <- Macro.Env.fetch_alias(env, curr) do
          expanded
      else
        :error ->
          curr
      end
    end)

    {:__aliases__, meta, new_aliases}
  end

  defp expand_aliases({name, meta, args}, env) do
    {expand_aliases(name, env), meta, expand_aliases(args, env)}
  end

  defp expand_aliases(name, _env) when is_atom(name), do: name

  def normalize_ast_type({:%{}, _, [{key, value}]}) do
    {:%{}, normalize_ast_type(key), normalize_ast_type(value)}
  end

  def normalize_ast_type({{:., _, [caller, called]}, _, args}) do
    {normalize_ast_type(caller), normalize_ast_type(called), Enum.count(args)}
  end

  def normalize_ast_type({:__aliases__, _, [name]}) do
    {:module, name}
  end

  def normalize_ast_type({name, _, args}) do
    {nil, name, Enum.count(args)}
  end

  def normalize_ast_type([type]) do
    {:list, [normalize_ast_type(type)]}
  end

  def normalize_ast_type(name) when is_atom(name), do: name
end
