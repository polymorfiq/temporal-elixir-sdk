defmodule TemporalEngine.Data.TypeSpec do
  import TemporalEngine.Helpers.CodePatterns

  require Logger

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
        typespec =
          if field[:required] do
            field.field[:typespec]
          else
            {:|, [], [field.field[:typespec], nil]}
          end

        {elem(field[:field][:type_name], 0), typespec}
      end)

    fields_to_opt_types =
      fields_to_types
      |> Enum.map(fn {name, ast} -> {name, nested_to_opts_type(ast)} end)

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

    to_or = fn
      [a], _ -> a
      [a, b], _ -> {:|, [], [a, b]}
      [a | rest], continue -> {:|, [], [a, continue.(rest, continue)]}
      [], _ -> {:none, [], []}
    end

    opts_type_ast =
      fields_to_opt_types
      |> Enum.map(fn {name, ast} -> {name, nested_to_type(ast, __CALLER__)} end)
      |> to_or.(to_or)

    validate_opts_name = :"validate_#{name}_opts"
    field_opts_types_name = :"get_#{name}_field_opts_types"
    field_types_name = :"get_#{name}_field_types"
    from_opts_name = :"#{name}_from_opts"
    from_opts_bang_name = :"#{name}_from_opts!"
    opts_name = :"#{name}_opts"
    opt_name = :"#{name}_opt"

    quote do
      @typedoc unquote(~s|#{structdoc}\n\n---\n\n#{Enum.join(fields_to_docs, "\n\n")}|)
      @type unquote({name, [], nil}) ::
              record(unquote(name), unquote(nested_to_type(fields_to_types, __CALLER__)))

      @doc "#{unquote(structdoc)}\n\nSee `t:#{unquote(name)}/0` for more details."
      Record.defrecord(unquote(name), unquote(field_names))

      @typedoc "See `t:#{unquote(name)}/0` for more details."
      @type unquote({opt_name, [], nil}) :: unquote(opts_type_ast)

      @typedoc "See `t:#{unquote(name)}/0` for more details."
      @type unquote({opts_name, [], nil}) :: [unquote({opt_name, [], []})]

      @doc false
      @spec unquote(validate_opts_name)(opts :: keyword(), base_name :: String.t() | nil) ::
              {:ok, validated :: keyword()} | {:error, keyword()}
      def unquote(validate_opts_name)(opts, base_name \\ nil),
        do:
          TemporalEngine.Data.TypeSpec.validate(
            opts,
            %{name: unquote(name), full_name: base_name, module: unquote(__CALLER__.module)},
            unquote(expand_nested_modules(field_names, __CALLER__))
          )

      @doc "Produces #{unquote(name)} from a keyword list of options"
      @spec unquote(from_opts_bang_name)(opts :: unquote(opts_name)()) :: unquote(name)()
      def unquote(from_opts_bang_name)(opts) do
        {:ok, record} = unquote(from_opts_name)(opts)
        record
      end

      if !unquote(fields[:_opts_type]) do
        @doc "Produces #{unquote(name)} from a keyword list of options"
        @spec unquote(from_opts_name)(opts :: unquote(opts_name)()) ::
                {:ok, unquote(name)()} | {:error, keyword()}
        def unquote(from_opts_name)(opts),
          do:
            TemporalEngine.Data.TypeSpec.from_opts(
              opts,
              %{name: unquote(name), full_name: nil, module: unquote(__CALLER__.module)},
              unquote(expand_nested_modules(field_names, __CALLER__))
            )
      end

      @doc false
      @spec unquote(field_types_name)() :: term()
      def unquote(field_types_name)(),
        do: unquote(Macro.escape(expand_nested_modules(fields_to_types, __CALLER__)))

      if !unquote(fields[:_opts_type]) do
        @doc false
        @spec unquote(field_opts_types_name)() :: term()
        def unquote(field_opts_types_name)(),
          do: unquote(Macro.escape(expand_nested_modules(fields_to_opt_types, __CALLER__)))
      end
    end
  end

  @spec from_record(tuple(), module(), module(), atom()) :: {:ok, term()} | {:error, term()}
  def from_record(record, to_module, from_module, name) do
    field_types = apply(from_module, :"get_#{name}_field_types", [])

    fields =
      field_types
      |> Enum.with_index()
      |> Enum.map(fn {{name, type}, idx} ->
        val = elem(record, idx + 1)
        {:ok, val_from_record} = struct_val_from_type(type, val)
        {name, val_from_record}
      end)

    {:ok, struct(to_module, fields)}
  end

  defp struct_val_from_type(_, nil), do: {:ok, nil}

  defp struct_val_from_type([{:byte, _, []}], val) when is_binary(val) do
    {:ok, :erlang.binary_to_list(val)}
  end

  defp struct_val_from_type([ast], vals) do
    Enum.reduce(vals, {:ok, []}, fn curr, acc ->
      with {:ok, validated} <- acc, {:ok, val} <- struct_val_from_type(ast, curr) do
        {:ok, validated ++ [val]}
      end
    end)
  end

  defp struct_val_from_type({:|, _, [a, b]} = type, val) do
    resp =
      with {:ok, validated} <- struct_val_from_type(a, val) do
        {:ok, validated}
      else
        {:error, _} -> struct_val_from_type(b, val)
      end

    with {:ok, val} <- resp do
      {:ok, val}
    else
      {:error, _} ->
        {:error,
         "Expected `#{pretty_type_name(type)}` but got `#{inspect(val)}` when creating struct"}
    end
  end

  defp struct_val_from_type(
         {:nested!, _, [{{:., _, [{:__aliases__, _, aliases}, type_name]}, _, []}]},
         val
       ) do
    mod = Module.concat(aliases ++ [Macro.camelize("#{type_name}")])
    apply(mod, :from_record, [val])
  end

  defp struct_val_from_type({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, []}, val) do
    {:ok, val}
  end

  defp struct_val_from_type({:%{}, _, [{k_type, v_type}]}, vals) do
    {:ok,
     Map.new(vals, fn {k, v} ->
       {:ok, parsed_k} = struct_val_from_type(k_type, k)
       {:ok, parsed_v} = struct_val_from_type(v_type, v)
       {parsed_k, parsed_v}
     end)}
  end

  defp struct_val_from_type({name, _, []}, val) when is_atom(name) do
    {:ok, val}
  end

  defp struct_val_from_type(nil, val) when is_nil(val) do
    {:ok, val}
  end

  defp struct_val_from_type(nil, val) do
    {:error, "Expected `nil` but got `#{inspect(val)}` when creating struct"}
  end

  defp struct_val_from_type(type, val) when is_atom(type) and type == val do
    {:ok, val}
  end

  defp struct_val_from_type(type, val) when is_atom(type) do
    {:error, "Expected `#{inspect(type)}` but got `#{inspect(val)}` when creating struct"}
  end

  defp struct_val_from_type(type, val) do
    Logger.warning("Unknown type when creating struct: #{inspect(type)} for #{inspect(val)}")
    {:ok, val}
  end

  @spec to_record(term(), module(), module(), atom()) :: {:ok, tuple()} | {:error, term()}
  def to_record(data, _to_module, from_module, name) do
    field_types = apply(from_module, :"get_#{name}_field_types", [])

    fields =
      field_types
      |> Enum.map(fn {name, type} ->
        val = get_in(data, [Access.key(name)])
        {:ok, val_from_record} = record_val_from_type(type, val)
        val_from_record
      end)

    {:ok, Enum.concat([name], fields) |> List.to_tuple()}
  end

  defp record_val_from_type(_, nil), do: {:ok, nil}

  defp record_val_from_type([ast], vals) do
    Enum.reduce(vals, {:ok, []}, fn curr, acc ->
      with {:ok, validated} <- acc, {:ok, val} <- record_val_from_type(ast, curr) do
        {:ok, validated ++ [val]}
      end
    end)
  end

  defp record_val_from_type({:|, _, [a, b]} = type, val) do
    resp =
      with {:ok, validated} <- record_val_from_type(a, val) do
        {:ok, validated}
      else
        {:error, _} -> record_val_from_type(b, val)
      end

    with {:ok, val} <- resp do
      {:ok, val}
    else
      {:error, _} ->
        {:error,
         "Expected `#{pretty_type_name(type)}` but got `#{inspect(val)}` when creating record"}
    end
  end

  defp record_val_from_type(
         {:nested!, _, [{{:., _, [{:__aliases__, _, _aliases}, _type_name]}, _, []}]},
         val
       ) do
    %data_mod{} = val
    data_mod.to_record(val)
  end

  defp record_val_from_type({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, []}, val) do
    {:ok, val}
  end

  defp record_val_from_type({:%{}, _, [{k_type, v_type}]}, vals) do
    {:ok,
     Map.new(vals, fn {k, v} ->
       {:ok, parsed_k} = record_val_from_type(k_type, k)
       {:ok, parsed_v} = record_val_from_type(v_type, v)
       {parsed_k, parsed_v}
     end)}
  end

  defp record_val_from_type({name, _, []}, val) when is_atom(name) do
    {:ok, val}
  end

  defp record_val_from_type(type, val) when is_atom(type) and type == val do
    {:ok, val}
  end

  defp record_val_from_type(type, val) when is_atom(type) do
    {:error, "Expected `#{inspect(type)}` but got `#{inspect(val)}` when creating record"}
  end

  defp record_val_from_type(nil, val) when is_nil(val) do
    {:ok, val}
  end

  defp record_val_from_type(nil, val) do
    {:error, "Expected `nil` but got `#{inspect(val)}` when creating record"}
  end

  defp record_val_from_type(type, val) do
    Logger.warning("Unknown type when creating record: #{inspect(type)} for #{inspect(val)}")
    {:ok, val}
  end

  @type field_names :: [atom() | {atom(), default :: term()}]
  @spec from_opts(
          opts :: keyword(),
          env :: map(),
          field_names :: field_names()
        ) :: {:ok, term()} | {:error, keyword()}
  def from_opts(opts, env, field_names) do
    with {:ok, validated} <- validate(opts, env, field_names) do
      field_types = apply(env.module, :"get_#{env.name}_field_types", [])

      fields =
        Enum.map(field_names, fn
          {field_name, _} -> field_name
          field_name -> field_name
        end)

      parsed =
        Enum.reduce(fields, {:ok, []}, fn field_name, acc ->
          val = Keyword.get(validated, field_name)
          name_comps = [env.full_name, field_name] |> Enum.filter(& &1)

          with {:ok, fields} <- acc,
               {:ok, field} <-
                 from_nested_opts(
                   field_types[field_name],
                   %{env | full_name: Enum.join(name_comps, ".")},
                   val
                 ) do
            {:ok, [field | fields]}
          end
        end)

      with {:ok, fields} <- parsed do
        {:ok, List.to_tuple([env.name | Enum.reverse(fields)])}
      end
    end
  end

  defp from_nested_opts(_, _, nil), do: {:ok, nil}

  defp from_nested_opts([ast], env, vals) do
    Enum.reduce(vals, {:ok, []}, fn curr, acc ->
      with {:ok, validated} <- acc, {:ok, val} <- from_nested_opts(ast, env, curr) do
        {:ok, validated ++ [val]}
      end
    end)
  end

  defp from_nested_opts({:|, _, [a, b]} = type, env, val) do
    resp =
      with {:ok, validated} <- from_nested_opts(a, env, val) do
        {:ok, validated}
      else
        {:error, _} -> from_nested_opts(b, env, val)
      end

    with {:ok, val} <- resp do
      {:ok, val}
    else
      {:error, _} ->
        {:error,
         "Expected `#{pretty_type_name(type)}` but got `#{inspect(val)}` when creating nested opts"}
    end
  end

  defp from_nested_opts(
         {:nested!, _, [{{:., _, [{:__aliases__, _, aliases}, type_name]}, _, []}]},
         _env,
         val
       ) do
    mod = Module.concat(aliases)
    apply(mod, :"#{type_name}_from_opts", [val])
  end

  defp from_nested_opts({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, []}, _env, val) do
    {:ok, val}
  end

  defp from_nested_opts({:%{}, _, [{k_type, v_type}]}, env, vals) do
    {:ok,
     Map.new(vals, fn {k, v} ->
       {:ok, parsed_k} = from_nested_opts(k_type, env, k)
       {:ok, parsed_v} = from_nested_opts(v_type, env, v)
       {parsed_k, parsed_v}
     end)}
  end

  defp from_nested_opts({name, _, []}, _env, val) when is_atom(name) do
    {:ok, val}
  end

  defp from_nested_opts(other, _env, val) when other == val do
    {:ok, val}
  end

  defp from_nested_opts(other, _env, val) when is_atom(other) and is_atom(val) do
    {:ok, val}
  end

  defp from_nested_opts(other, _env, val) do
    Logger.warning("Unrecognized nested opts: #{inspect(other)} for #{inspect(val)}")
    {:ok, val}
  end

  @spec validate(
          opts :: keyword(),
          env :: map(),
          field_names :: field_names()
        ) :: {:ok, validated :: keyword()} | {:error, term()}
  def validate(opts, env, field_names) do
    opts_with_defaults =
      Enum.flat_map(field_names, fn
        name when is_atom(name) ->
          if Keyword.has_key?(opts, name) do
            [{name, opts[name]}]
          else
            []
          end

        {name, default} when is_atom(name) ->
          if Keyword.has_key?(opts, name) do
            [{name, opts[name]}]
          else
            [{name, default}]
          end
      end)

    field_types = apply(env.module, :"get_#{env.name}_field_opts_types", [])

    all_validations =
      Enum.map(field_types, fn {name, type} ->
        name_comps = [env.full_name, name] |> Enum.filter(& &1)

        opt = opts_with_defaults[name]

        with {:ok, validated} <-
               validate_type(
                 type,
                 %{env | name: name, full_name: Enum.join(name_comps, ".")},
                 opt
               ) do
          {name, validated}
        else
          {:error, errors} ->
            {name, {:error, errors}}
        end
      end)

    validation_errors =
      all_validations
      |> Enum.filter(fn {_name, val} -> match?({:error, _}, val) end)
      |> Enum.flat_map(fn {_name, {:error, errors}} -> errors end)

    unknown_options = Keyword.drop(opts, Keyword.keys(opts_with_defaults))

    cond do
      Enum.any?(unknown_options) ->
        {:error,
         [{env.name, "Unexpected fields given for #{env.name} - #{inspect(unknown_options)}"}]}

      Enum.any?(validation_errors) ->
        {:error, validation_errors}

      true ->
        {:ok, all_validations}
    end
  end

  defp validate_type({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, []}, _env, val)
       when is_binary(val),
       do: {:ok, val}

  defp validate_type({{:., _, [{:__aliases__, _, [:String]}, :t]}, _, []}, env, val) do
    {:error,
     [
       {env.name,
        "Expected '#{inspect(env.full_name)}' to be 'String.t()' but received '#{inspect(val)}'"}
     ]}
  end

  defp validate_type([ast], env, vals) when is_list(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce({:ok, []}, fn {val, idx}, acc ->
      with {:ok, validated} <- acc,
           {:ok, valid} <- validate_type(ast, %{env | full_name: "#{env.full_name}[#{idx}]"}, val) do
        {:ok, validated ++ [valid]}
      end
    end)
  end

  defp validate_type([ast], env, val) do
    {:error,
     [
       {env.name,
        "Expected '#{inspect(env.full_name)}' to be '[#{pretty_type_name(ast)}]' but received '#{inspect(val)}'"}
     ]}
  end

  defp validate_type(
         {:nested!, _, [{{:., _, [{:__aliases__, _, aliases}, type_name]}, _, []}]},
         env,
         val
       ) do
    mod = Module.concat(aliases)
    Code.ensure_loaded?(mod)

    validation_fn_name =
      try do
        String.to_existing_atom("validate_#{type_name}")
      rescue
        ArgumentError -> nil
      end

    cond do
      !Code.ensure_loaded?(mod) ->
        {:error,
         [
           {env.name,
            "#{inspect(env.full_name)}: Module '#{inspect(mod)}' was not found for '#{mod}.#{type_name}/0'"}
         ]}

      !validation_fn_name ->
        {:error,
         [
           {env.name,
            "#{inspect(env.full_name)}: Could not find referenced type #{mod}.#{type_name}/0"}
         ]}

      !Kernel.function_exported?(mod, validation_fn_name, 2) ->
        {:error,
         [
           {env.name,
            "#{inspect(env.full_name)}: Module '#{inspect(mod)}' did not have type '#{type_name}/0'"}
         ]}

      val == nil ->
        {:ok, nil}

      true ->
        with {:ok, validated} <- apply(mod, validation_fn_name, [val, env.full_name]) do
          {:ok, validated}
        else
          {:error, errors} ->
            errors =
              Enum.map(errors, fn {_name, error} ->
                {env.name, error}
              end)

            {:error, errors}
        end
    end
  end

  defp validate_type({:%{}, _, [{k_type, v_type}]}, env, val) when is_map(val) do
    with {:ok, validated} <-
           Enum.reduce(val, {:ok, []}, fn {k, v}, acc ->
             with {:ok, validated} <- acc,
                  {:ok, k_validated} <-
                    validate_type(k_type, %{env | full_name: "#{env.full_name}[]"}, k),
                  {:ok, v_validated} <-
                    validate_type(
                      v_type,
                      %{env | full_name: "#{env.full_name}[#{inspect(k)}]"},
                      v
                    ) do
               {:ok, validated ++ [{k_validated, v_validated}]}
             end
           end) do
      {:ok, Map.new(validated)}
    end
  end

  defp validate_type({:%{}, _, _}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'map()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:any, _, []}, _env, val), do: {:ok, val}
  defp validate_type({:term, _, []}, _env, val), do: {:ok, val}

  defp validate_type({:none, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'none()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:binary, _, []}, _env, val) when is_binary(val), do: {:ok, val}

  defp validate_type({:binary, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'binary()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:integer, _, []}, _env, val) when is_number(val), do: {:ok, val}

  defp validate_type({:integer, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:non_neg_integer, _, []}, _env, val) when is_number(val) and val >= 0,
    do: {:ok, val}

  defp validate_type({:non_neg_integer, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'non_neg_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:pos_integer, _, []}, _env, val) when is_number(val) and val > 0,
    do: {:ok, val}

  defp validate_type({:pos_integer, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'pos_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:neg_integer, _, []}, _env, val) when is_number(val) and val < 0,
    do: {:ok, val}

  defp validate_type({:neg_integer, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'neg_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:atom, _, []}, _env, val) when is_atom(val), do: {:ok, val}

  defp validate_type({:atom, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'atom()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:map, _, []}, _env, val) when is_map(val), do: {:ok, val}

  defp validate_type({:map, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'map()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:pid, _, []}, _env, val) when is_pid(val), do: {:ok, val}

  defp validate_type({:pid, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'pid()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:port, _, []}, _env, val) when is_port(val), do: {:ok, val}

  defp validate_type({:port, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'port()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:reference, _, []}, _env, val) when is_reference(val), do: {:ok, val}

  defp validate_type({:reference, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'reference()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:tuple, _, []}, _env, val) when is_tuple(val), do: {:ok, val}

  defp validate_type({:tuple, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'tuple()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:float, _, []}, _env, val) when is_float(val), do: {:ok, val}

  defp validate_type({:float, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'float()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:arity, _, []}, _env, val)
       when is_number(val) and val >= 0 and val <= 255, do: {:ok, val}

  defp validate_type({:arity, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'arity()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:bitstring, _, []}, _env, val) when is_bitstring(val),
    do: {:ok, val}

  defp validate_type({:bitstring, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'bitstring()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:bool, _, []}, _env, val) when is_boolean(val), do: {:ok, val}

  defp validate_type({:bool, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'boolean()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:boolean, _, []}, _env, val) when is_boolean(val), do: {:ok, val}

  defp validate_type({:boolean, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'boolean()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:byte, _, []}, _env, val)
       when is_number(val) and val >= 0 and val <= 255, do: {:ok, val}

  defp validate_type({:byte, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'byte()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:char, _, []}, _env, val)
       when is_number(val) and val >= 0 and val <= 0x10FFFF, do: {:ok, val}

  defp validate_type({:char, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'char()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:charlist, _, []}, env, val),
    do: validate_type({:list, {:char, [], []}}, env, val)

  defp validate_type({:nonempty_charlist, _, []}, env, val),
    do: validate_type({:nonempty_list, {:char, [], []}}, env, val)

  defp validate_type({:fun, _, []}, _env, val) when is_function(val), do: {:ok, val}

  defp validate_type({:fun, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'fun()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:function, _, []}, _env, val) when is_function(val), do: {:ok, val}

  defp validate_type({:function, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'function()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:identifier, _, []}, _env, val) when is_pid(val), do: {:ok, val}
  defp validate_type({:identifier, _, []}, _env, val) when is_port(val), do: {:ok, val}
  defp validate_type({:identifier, _, []}, _env, val) when is_reference(val), do: {:ok, val}

  defp validate_type({:identifier, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'identifier()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:keyword, _, []}, env, val) when is_list(val) do
    if Keyword.keyword?(val) do
      {:ok, val}
    else
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'keyword()' but received '#{inspect(val)}'"}
       ]}
    end
  end

  defp validate_type({:keyword, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'keyword()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:list, _, []}, _env, val) when is_list(val), do: {:ok, val}

  defp validate_type({:list, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:nonempty_list, _, []}, env, []),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'nonempty_list()' but received '[]'"}
       ]}

  defp validate_type({:nonempty_list, _, []}, _env, val) when is_list(val), do: {:ok, val}

  defp validate_type({:nonempty_list, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'nonempty_list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:mfa, _, []}, _env, {m, a1, a2} = val)
       when is_atom(m) and is_atom(a1) and is_atom(a2), do: {:ok, val}

  defp validate_type({:mfa, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'mfa()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:module, _, []}, _env, val) when is_atom(val), do: {:ok, val}

  defp validate_type({:module, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'module()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:node, _, []}, _env, val) when is_atom(val), do: {:ok, val}

  defp validate_type({:node, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'node()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:number, _, []}, _env, val) when is_number(val), do: {:ok, val}

  defp validate_type({:number, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'number()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:struct, _, []}, _env, val) when is_struct(val), do: {:ok, val}

  defp validate_type({:struct, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'struct()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:timeout, _, []}, _env, :infinity), do: {:ok, :infinity}

  defp validate_type({:timeout, _, []}, _env, val) when is_number(val) and val >= 0,
    do: {:ok, val}

  defp validate_type({:timeout, _, []}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'timeout()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:list, _, [val_type]}, env, vals) when is_list(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce({:ok, []}, fn {val, idx}, acc ->
      with {:ok, validated} <- acc,
           {:ok, valid_v} <-
             validate_type(val_type, %{env | full_name: "#{env.full_name}[#{idx}]"}, val) do
        {:ok, validated ++ [valid_v]}
      end
    end)
  end

  defp validate_type({:list, _, [_val_type]}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:nonempty_list, _, [_val_type]}, env, []),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'nonempty_list()' but received '[]'"}
       ]}

  defp validate_type({:nonempty_list, _, [val_type]}, env, vals) when is_list(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce({:ok, []}, fn {val, idx}, acc ->
      with {:ok, validated} <- acc,
           {:ok, valid_v} <-
             validate_type(val_type, %{env | full_name: "#{env.full_name}[#{idx}]"}, val) do
        {:ok, validated ++ [valid_v]}
      end
    end)
  end

  defp validate_type({:nonempty_list, _, [_val_type]}, env, val),
    do:
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be 'nonempty_list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:|, _, [a, b]} = type, env, val) do
    valid_type =
      with {:ok, val} <- validate_type(a, env, val) do
        {:ok, val}
      else
        {:error, _} ->
          validate_type(b, env, val)
      end

    if match?({:ok, _}, valid_type) do
      valid_type
    else
      {:error,
       [
         {env.name,
          "Expected '#{inspect(env.full_name)}' to be one of (#{pretty_type_name(type)}) but got '#{inspect(val)}'"}
       ]}
    end
  end

  defp validate_type(nil, _env, val) when is_nil(val), do: {:ok, nil}

  defp validate_type(nil, env, val),
    do:
      {:error,
       [
         {env.name,
          ["Expected '#{inspect(env.full_name)}' to be `nil` but got '#{inspect(val)}'"]}
       ]}

  defp validate_type(type, _env, val) when is_atom(type) and type == val do
    {:ok, val}
  end

  defp validate_type(type, env, val) when is_atom(type) do
    {:error, [{env.name, "Expected `#{inspect(type)}` bot got `#{inspect(val)}`"}]}
  end

  defp validate_type(type, _env, val) do
    Logger.warning("Could not validate type: #{inspect(type)}")
    {:ok, val}
  end

  def type_to_opts_type(types, env) when is_list(types),
    do: Enum.map(types, fn type -> type_to_opts_type(type, env) end)

  def type_to_opts_type(type, _env) do
    type
  end

  defp pretty_type_name([ast]), do: "[#{pretty_type_name(ast)}]"
  defp pretty_type_name({:nested!, _, [type]}), do: "#{pretty_type_name(type)}"

  defp pretty_type_name({{:., _, [{:__aliases__, _, aliases}, type_name]}, _, _}) do
    "#{Module.concat(aliases)}.#{type_name}()"
  end

  defp pretty_type_name({:map, key_type, val_type}),
    do: "%{#{pretty_type_name(key_type)} => #{pretty_type_name(val_type)}}"

  defp pretty_type_name({:|, _, [a, b]}),
    do: "#{pretty_type_name(a)} | #{pretty_type_name(b)}"

  defp pretty_type_name({name, _, []}) when is_atom(name), do: "#{name}()"
  defp pretty_type_name({name, _, []}) when is_atom(name), do: "#{name}()"
  defp pretty_type_name(name) when is_atom(name), do: "#{inspect(name)}"

  defp expand_nested_modules(ast, env) do
    {new_ast, _} =
      Macro.prewalk(ast, [], fn
        {:nested!, meta, [{{:., m1, [{:__aliases__, m2, _} = alias, type_name]}, m3, []}]}, acc ->
          expanded =
            {:nested!, meta,
             [
               {{:., m1,
                 [
                   {:__aliases__, m2,
                    Macro.expand(alias, env) |> Module.split() |> Enum.map(&String.to_atom/1)},
                   type_name
                 ]}, m3, []}
             ]}

          {expanded, acc}

        other, acc ->
          {other, acc}
      end)

    new_ast
  end

  defp nested_to_type(ast, env) do
    expanded = expand_nested_modules(ast, env)

    {typespec, _} =
      Macro.prewalk(expanded, [], fn
        {:nested!, _, [nested]}, acc -> {nested, acc}
        other, acc -> {other, acc}
      end)

    typespec
  end

  defp nested_to_opts_type(
         {:nested!, meta, [{{:., m1, [{:__aliases__, m2, aliases}, type_name]}, m3, []}]}
       ) do
    {:nested!, meta, [{{:., m1, [{:__aliases__, m2, aliases}, :"#{type_name}_opts"]}, m3, []}]}
  end

  defp nested_to_opts_type(asts) when is_list(asts) do
    Enum.map(asts, &nested_to_opts_type/1)
  end

  defp nested_to_opts_type({:|, meta, [a, b]}) do
    {:|, meta, [nested_to_opts_type(a), nested_to_opts_type(b)]}
  end

  defp nested_to_opts_type({:%{}, meta, [{k_type, val_type}]}) do
    {:%{}, meta, [{nested_to_opts_type(k_type), nested_to_opts_type(val_type)}]}
  end

  defp nested_to_opts_type(other), do: other
end
