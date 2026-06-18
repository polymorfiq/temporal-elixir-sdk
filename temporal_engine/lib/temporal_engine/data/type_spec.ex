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
        typespec =
          if field[:required] do
            field.field[:typespec]
          else
            {:|, [], [field.field[:typespec], nil]}
          end

        {elem(field[:field][:type_name], 0), typespec}
      end)

    expanded_field_types =
      fields
      |> Enum.map(fn field ->
        typespec = expand_aliases(field.field[:typespec], __CALLER__)

        typespec =
          if field[:required] do
            typespec
          else
            {:|, [], [typespec, nil]}
          end

        {elem(field[:field][:type_name], 0), typespec}
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

    to_or = fn
      [a], _ -> a
      [a, b], _ -> {:|, [], [a, b]}
      [a | rest], continue -> {:|, [], [a, continue.(rest, continue)]}
      [], _ -> {:none, [], []}
    end

    opts_type_ast =
      fields_to_types
      |> Enum.map(fn {name, type} -> {name, type_to_opts_type(type, __CALLER__)} end)
      |> to_or.(to_or)

    validate_opts_name = :"validate_#{name}_opts"
    field_types_name = :"get_#{name}_field_types"
    from_opts_name = :"#{name}_from_opts"
    opts_name = :"#{name}_opts"

    quote do
      @typedoc unquote(~s|#{structdoc}\n\n---\n\n#{Enum.join(fields_to_docs, "\n\n")}|)
      @type unquote({name, [], nil}) ::
              record(unquote(name), unquote(fields_to_types))

      @doc "#{unquote(structdoc)}\n\nSee `t:#{unquote(name)}/0` for more details."
      Record.defrecord(unquote(name), unquote(field_names))

      @typedoc "See `t:#{unquote(name)}/0` for more details."
      @type unquote({opts_name, [], nil}) :: unquote([opts_type_ast])

      @doc false
      @spec unquote(validate_opts_name)(opts :: keyword(), base_name :: String.t() | nil) ::
              {:ok, validated :: keyword()} | {:error, keyword()}
      def unquote(validate_opts_name)(opts, base_name \\ nil),
        do:
          TemporalEngine.Data.TypeSpec.validate(
            opts,
            __MODULE__,
            unquote(name),
            base_name,
            unquote(field_names)
          )

      @doc "Produces #{unquote(name)} from a keyword list of options"
      @spec unquote(from_opts_name)(opts :: unquote(opts_name)()) ::
              {:ok, unquote(name)()} | {:error, keyword()}
      def unquote(from_opts_name)(opts),
        do:
          TemporalEngine.Data.TypeSpec.from_opts(
            opts,
            __MODULE__,
            unquote(name),
            unquote(field_names)
          )

      @doc false
      @spec unquote(field_types_name)() :: term()
      def unquote(field_types_name)(),
        do: unquote(Macro.escape(expanded_field_types))

      defmodule unquote(Module.concat([__CALLER__.module, Macro.camelize("#{name}")])) do
        @moduledoc unquote(~s|#{structdoc}\n\n|)

        @typedoc unquote(~s|#{Enum.join(fields_to_docs, "\n\n")}|)
        @type t() :: unquote(Macro.expand(map_ast, __CALLER__))

        defstruct unquote(field_names)

        @spec from_record(tuple()) :: {:ok, t()} | {:error, term()}
        def from_record(record) do
          expanded_types = unquote(Macro.escape(expanded_field_types))
          expanded_types |> IO.inspect(label: "expanded_types")

          if unquote(name) == elem(record, 0) do
            struct_fields =
              unquote(field_names)
              |> Enum.with_index()
              |> Enum.map(fn
                {{field_name, _}, idx} -> {field_name, elem(record, idx + 1)}
                {field_name, idx} -> {field_name, elem(record, idx + 1)}
              end)

            parsed_nested =
              struct_fields
              |> Enum.map(fn {name, val} ->
                case expanded_types[name] do
                  [{{:., _, [{:__aliases__, _, [mod]}, field]}, _, []}] ->
                    vals = val
                    full_mod = Module.concat([mod, Macro.camelize("#{field}")])

                    if Code.ensure_loaded?(full_mod) &&
                         Kernel.function_exported?(full_mod, :from_record, 1) do
                      {name, Enum.map(vals, &full_mod.from_record(&1))}
                    else
                      {name, vals}
                    end

                  {{:., _, [{:__aliases__, _, [mod]}, field]}, _, []} ->
                    full_mod = Module.concat([mod, Macro.camelize("#{field}")])

                    if Code.ensure_loaded?(full_mod) &&
                         Kernel.function_exported?(full_mod, :from_record, 1) do
                      {name, full_mod.from_record(val)}
                    else
                      {name, val}
                    end

                  _ ->
                    {name, val}
                end
              end)

            struct(__MODULE__, parsed_nested)
          else
            {:error, "Not a #{unquote(name)} record..."}
          end
        end
      end
    end
  end

  @type field_names :: [atom() | {atom(), default :: term()}]
  @spec from_opts(
          opts :: keyword(),
          caller :: module(),
          name :: atom(),
          field_names :: field_names()
        ) :: {:ok, term()} | {:error, keyword()}
  def from_opts(opts, caller, name, field_names) do
    with {:ok, validated} <- validate(opts, caller, name, name, field_names) do
      field_types = apply(caller, :"get_#{name}_field_types", [])

      normalized =
        Enum.map(field_types, fn {name, type} ->
          {name, normalize_ast_type(type)}
        end)

      record_data =
        normalized
        |> Enum.reduce([name], fn
          {field_name, {:one_of, [{{:module, nested_mod}, nested_field, 0}, nil]}}, acc ->
            from_opts_fn_name =
              try do
                String.to_existing_atom("#{nested_field}_from_opts")
              rescue
                ArgumentError -> nil
              end

            cond do
              validated[field_name] == nil ->
                [validated[field_name] | acc]

              from_opts_fn_name && Code.ensure_loaded?(nested_mod) &&
                  Kernel.function_exported?(nested_mod, from_opts_fn_name, 1) ->
                [apply(nested_mod, from_opts_fn_name, [validated[field_name]]) | acc]

              true ->
                [validated[field_name] | acc]
            end

          {field_name, {{:module, nested_mod}, nested_field, 0}}, acc ->
            from_opts_fn_name =
              try do
                String.to_existing_atom("#{nested_field}_from_opts")
              rescue
                ArgumentError -> nil
              end

            cond do
              validated[field_name] == nil ->
                [validated[field_name] | acc]

              from_opts_fn_name && Code.ensure_loaded?(nested_mod) &&
                  Kernel.function_exported?(nested_mod, from_opts_fn_name, 1) ->
                [apply(nested_mod, from_opts_fn_name, [validated[field_name]]) | acc]

              true ->
                [validated[field_name] | acc]
            end

          {field_name, {:one_of, [{:list, {{:module, nested_mod}, nested_field, 0}}, nil]}},
          acc ->
            from_opts_fn_name =
              try do
                String.to_existing_atom("#{nested_field}_from_opts")
              rescue
                ArgumentError -> nil
              end

            cond do
              validated[field_name] == nil ->
                [validated[field_name] | acc]

              from_opts_fn_name && Code.ensure_loaded?(nested_mod) &&
                  Kernel.function_exported?(nested_mod, from_opts_fn_name, 1) ->
                [
                  Enum.map(validated[field_name], fn curr ->
                    {:ok, nested} = apply(nested_mod, from_opts_fn_name, [curr])
                    nested
                  end)
                  | acc
                ]

              true ->
                [validated[field_name] | acc]
            end

          {field_name, {:list, {{:module, nested_mod}, nested_field, 0}}}, acc ->
            from_opts_fn_name =
              try do
                String.to_existing_atom("#{nested_field}_from_opts")
              rescue
                ArgumentError -> nil
              end

            cond do
              validated[field_name] == nil ->
                [validated[field_name] | acc]

              from_opts_fn_name && Code.ensure_loaded?(nested_mod) &&
                  Kernel.function_exported?(nested_mod, from_opts_fn_name, 1) ->
                [
                  Enum.map(validated[field_name], fn curr ->
                    {:ok, nested} = apply(nested_mod, from_opts_fn_name, [curr])
                    nested
                  end)
                  | acc
                ]

              true ->
                [validated[field_name] | acc]
            end

          {field_name, _}, acc ->
            [validated[field_name] | acc]
        end)
        |> Enum.reverse()
        |> List.to_tuple()

      {:ok, record_data}
    end
  end

  @spec validate(
          opts :: keyword(),
          caller :: module(),
          name :: atom(),
          base_name :: String.t() | atom() | nil,
          field_names :: field_names()
        ) :: {:ok, validated :: keyword()} | {:error, term()}
  def validate(opts, caller, name, base_name, field_names) do
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

    field_types = apply(caller, :"get_#{name}_field_types", [])

    normalized =
      Enum.map(field_types, fn {name, type} ->
        {name, normalize_ast_type(type)}
      end)

    all_validations =
      Enum.map(normalized, fn {name, type} ->
        name_comps = [base_name, name] |> Enum.filter(& &1)

        opt = opts_with_defaults[name]

        with {:ok, validated} <- validate_type(type, name, Enum.join(name_comps, "."), opt) do
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
        {:error, ["Unexpected fields given for #{name} - #{inspect(unknown_options)}"]}

      Enum.any?(validation_errors) ->
        {:error, validation_errors}

      true ->
        {:ok, all_validations}
    end
  end

  defp validate_type({{:module, :String}, :t, 0}, _name, _full_name, val) when is_binary(val),
    do: {:ok, val}

  defp validate_type({{:module, :String}, :t, 0}, name, full_name, val) when is_binary(val) do
    {:error,
     [
       {name,
        "Expected '#{inspect(full_name)}' to be 'String.t()' but received '#{inspect(val)}'"}
     ]}
  end

  defp validate_type({{:module, mod}, type_name, 0}, name, full_name, val) do
    validation_fn_name =
      try do
        String.to_existing_atom("validate_#{type_name}_opts")
      rescue
        ArgumentError -> nil
      end

    cond do
      !validation_fn_name ->
        {:error,
         [{name, "#{inspect(full_name)}: Could not find referenced type #{mod}.#{name}/0"}]}

      !Code.ensure_loaded?(mod) ->
        {:error,
         [
           {name,
            "#{inspect(full_name)}: Module '#{inspect(mod)}' was not found for '#{mod}.#{name}/0'"}
         ]}

      !Kernel.function_exported?(mod, validation_fn_name, 2) ->
        {:error,
         [{name, "#{inspect(full_name)}: Module '#{inspect(mod)}' did not have type '#{name}/0'"}]}

      !is_list(val) || !Keyword.keyword?(val) ->
        {:error,
         [
           {name,
            "#{inspect(full_name)}: Expected to be opts (keyword list) but received #{inspect(val)}"}
         ]}

      true ->
        with {:ok, validated} <- apply(mod, validation_fn_name, [val, full_name]) do
          {:ok, validated}
        else
          {:error, errors} ->
            errors =
              Enum.map(errors, fn {_name, error} ->
                {name, error}
              end)

            {:error, errors}
        end
    end
  end

  defp validate_type({:map, k_type, v_type}, name, full_name, val) when is_map(val) do
    validated =
      Enum.reduce(val, {:ok, []}, fn {k, v}, acc ->
        with {:ok, validated_pairs} <- acc,
             {:ok, valid_k} <- validate_type(k_type, name, "#{full_name}(Key: #{inspect(k)})", k),
             {:ok, valid_v} <- validate_type(v_type, name, "#{full_name}[#{inspect(k)}]", v) do
          {:ok, validated_pairs ++ [{valid_k, valid_v}]}
        end
      end)

    with {:ok, validated_pairs} <- validated do
      {:ok, Map.new(validated_pairs)}
    end
  end

  defp validate_type({:map, _k_type, _v_type}, name, full_name, val),
    do:
      {:error,
       [{name, "Expected '#{inspect(full_name)}' to be 'map()' but received '#{inspect(val)}'"}]}

  defp validate_type({:any, 0}, _name, _full_name, val), do: {:ok, val}
  defp validate_type({:term, 0}, _name, _full_name, val), do: {:ok, val}

  defp validate_type({:none, 0}, name, full_name, val),
    do:
      {:error,
       [{name, "Expected '#{inspect(full_name)}' to be 'none()' but received '#{inspect(val)}'"}]}

  defp validate_type({:binary, 0}, _name, _full_name, val) when is_binary(val), do: {:ok, val}

  defp validate_type({:binary, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'binary()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:integer, 0}, _name, _full_name, val) when is_number(val), do: {:ok, val}

  defp validate_type({:integer, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:non_neg_integer, 0}, _name, _full_name, val)
       when is_number(val) and val >= 0,
       do: {:ok, val}

  defp validate_type({:non_neg_integer, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'non_neg_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:pos_integer, 0}, _name, _full_name, val) when is_number(val) and val > 0,
    do: {:ok, val}

  defp validate_type({:pos_integer, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'pos_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:neg_integer, 0}, _name, _full_name, val) when is_number(val) and val < 0,
    do: {:ok, val}

  defp validate_type({:neg_integer, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'neg_integer()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:atom, 0}, _name, _full_name, val) when is_atom(val), do: {:ok, val}

  defp validate_type({:atom, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'atom()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:map, 0}, _name, _full_name, val) when is_map(val), do: {:ok, val}

  defp validate_type({:map, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'map()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:pid, 0}, _name, _full_name, val) when is_pid(val), do: {:ok, val}

  defp validate_type({:pid, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'pid()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:port, 0}, _name, _full_name, val) when is_port(val), do: {:ok, val}

  defp validate_type({:port, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'port()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:reference, 0}, _name, _full_name, val) when is_reference(val),
    do: {:ok, val}

  defp validate_type({:reference, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'reference()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:tuple, 0}, _name, _full_name, val) when is_tuple(val), do: {:ok, val}

  defp validate_type({:tuple, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'tuple()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:float, 0}, _name, _full_name, val) when is_float(val), do: {:ok, val}

  defp validate_type({:float, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'float()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:arity, 0}, _name, _full_name, val)
       when is_number(val) and val >= 0 and val <= 255, do: {:ok, val}

  defp validate_type({:arity, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'arity()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:bitstring, 0}, _name, _full_name, val) when is_bitstring(val),
    do: {:ok, val}

  defp validate_type({:bitstring, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'bitstring()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:boolean, 0}, _name, _full_name, val) when is_boolean(val), do: {:ok, val}

  defp validate_type({:boolean, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'boolean()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:byte, 0}, _name, _full_name, val)
       when is_number(val) and val >= 0 and val <= 255, do: {:ok, val}

  defp validate_type({:byte, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'byte()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:char, 0}, _name, _full_name, val)
       when is_number(val) and val >= 0 and val <= 0x10FFFF, do: {:ok, val}

  defp validate_type({:char, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'char()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:charlist, 0}, name, full_name, val),
    do: validate_type({:list, {:char, 0}}, name, full_name, val)

  defp validate_type({:nonempty_charlist, 0}, name, full_name, val),
    do: validate_type({:nonempty_list, {:char, 0}}, name, full_name, val)

  defp validate_type({:fun, 0}, _name, _full_name, val) when is_function(val),
    do: {:ok, val}

  defp validate_type({:fun, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'fun()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:function, 0}, _name, _full_name, val) when is_function(val),
    do: {:ok, val}

  defp validate_type({:function, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'function()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:identifier, 0}, _name, _full_name, val) when is_pid(val),
    do: {:ok, val}

  defp validate_type({:identifier, 0}, _name, _full_name, val) when is_port(val),
    do: {:ok, val}

  defp validate_type({:identifier, 0}, _name, _full_name, val) when is_reference(val),
    do: {:ok, val}

  defp validate_type({:identifier, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'identifier()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:keyword, 0}, name, full_name, val) when is_list(val) do
    if Keyword.keyword?(val) do
      {:ok, val}
    else
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'keyword()' but received '#{inspect(val)}'"}
       ]}
    end
  end

  defp validate_type({:keyword, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'keyword()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:list, 0}, _name, _full_name, val) when is_list(val),
    do: {:ok, val}

  defp validate_type({:list, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:nonempty_list, 0}, name, full_name, []),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'nonempty_list()' but received '[]'"}
       ]}

  defp validate_type({:nonempty_list, 0}, _name, _full_name, val) when is_list(val),
    do: {:ok, val}

  defp validate_type({:nonempty_list, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'nonempty_list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:mfa, 0}, _name, _full_name, {m, a1, a2} = val)
       when is_atom(m) and is_atom(a1) and is_atom(a2),
       do: {:ok, val}

  defp validate_type({:mfa, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'mfa()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:module, 0}, _name, _full_name, val) when is_atom(val),
    do: {:ok, val}

  defp validate_type({:module, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'module()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:node, 0}, _name, _full_name, val) when is_atom(val),
    do: {:ok, val}

  defp validate_type({:node, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name, "Expected '#{inspect(full_name)}' to be 'node()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:number, 0}, _name, _full_name, val) when is_number(val),
    do: {:ok, val}

  defp validate_type({:number, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'number()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:struct, 0}, _name, _full_name, val) when is_struct(val),
    do: {:ok, val}

  defp validate_type({:struct, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'struct()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:timeout, 0}, _name, _full_name, :infinity), do: {:ok, :infinity}

  defp validate_type({:timeout, 0}, _name, _full_name, val) when is_number(val) and val >= 0,
    do: {:ok, val}

  defp validate_type({:timeout, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'timeout()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({{:module, :String}, :t, 0}, _name, _full_name, val) when is_binary(val),
    do: {:ok, val}

  defp validate_type({{:module, :String}, :t, 0}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'String.t()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:list, val_type}, name, full_name, vals) when is_list(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce({:ok, []}, fn {val, idx}, acc ->
      with {:ok, validated} <- acc,
           {:ok, valid_v} <- validate_type(val_type, name, "#{full_name}[#{idx}]", val) do
        {:ok, validated ++ [valid_v]}
      end
    end)
  end

  defp validate_type({:list, _val_type}, name, full_name, val),
    do:
      {:error,
       [{name, "Expected '#{inspect(full_name)}' to be 'list()' but received '#{inspect(val)}'"}]}

  defp validate_type({:nonempty_list, _val_type}, name, full_name, []),
    do:
      {:error,
       [{name, "Expected '#{inspect(full_name)}' to be 'nonempty_list()' but received '[]'"}]}

  defp validate_type({:nonempty_list, val_type}, name, full_name, vals) when is_list(vals) do
    vals
    |> Enum.with_index()
    |> Enum.reduce({:ok, []}, fn {val, idx}, acc ->
      with {:ok, validated} <- acc,
           {:ok, valid_v} <- validate_type(val_type, name, "#{full_name}[#{idx}]", val) do
        {:ok, validated ++ [valid_v]}
      end
    end)
  end

  defp validate_type({:nonempty_list, _val_type}, name, full_name, val),
    do:
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be 'nonempty_list()' but received '#{inspect(val)}'"}
       ]}

  defp validate_type({:one_of, types} = type, name, full_name, val) do
    valid_type =
      Enum.find_value(types, fn type ->
        validated = validate_type(type, name, full_name, val)
        if match?({:ok, _}, validated), do: validated, else: nil
      end)

    if match?({:ok, _}, valid_type) do
      valid_type
    else
      {:error,
       [
         {name,
          "Expected '#{inspect(full_name)}' to be one of (#{pretty_type_name(type)}) but got '#{inspect(val)}'"}
       ]}
    end
  end

  defp validate_type(nil, _name, _full_name, val) when is_nil(val), do: {:ok, nil}

  defp validate_type(nil, name, full_name, val),
    do:
      {:error, [{name, "Expected '#{inspect(full_name)}' to be `nil` but got '#{inspect(val)}'"}]}

  defp validate_type(_type, _name, _full_name, val), do: {:ok, val}

  defp expand_aliases(asts, env) when is_list(asts) do
    Enum.map(asts, &expand_aliases(&1, env))
  end

  defp expand_aliases({:%{}, meta, [{key, value}]}, env) do
    {:%{}, meta, [{expand_aliases(key, env), expand_aliases(value, env)}]}
  end

  defp expand_aliases({:__aliases__, meta, ast_aliases}, env) do
    new_aliases =
      case ast_aliases do
        [name] ->
          with {:ok, expanded} <- Macro.Env.fetch_alias(env, name) do
            [expanded]
          else
            :error ->
              [name]
          end

        [name | rest] ->
          expanded =
            with {:ok, expanded} <- Macro.Env.fetch_alias(env, name) do
              expanded
            else
              :error ->
                name
            end

          [Module.concat([expanded | rest])]
      end

    {:__aliases__, meta, new_aliases}
  end

  defp expand_aliases({name, meta, args}, env) do
    {expand_aliases(name, env), meta, expand_aliases(args, env)}
  end

  defp expand_aliases(name, _env) when is_atom(name), do: name

  def normalize_ast_type({:%{}, _, [{key, value}]}) do
    {:map, normalize_ast_type(key), normalize_ast_type(value)}
  end

  def normalize_ast_type({{:., _, [caller, called]}, _, args}) do
    {normalize_ast_type(caller), normalize_ast_type(called), Enum.count(args)}
  end

  def normalize_ast_type({:__aliases__, _, [name]}) do
    {:module, name}
  end

  def normalize_ast_type({:|, _, args}) do
    {:one_of, Enum.map(args, &normalize_ast_type/1)}
  end

  def normalize_ast_type({:list, _, [type]}) do
    {:list, normalize_ast_type(type)}
  end

  def normalize_ast_type({:nonempty_list, _, [type]}) do
    {:nonempty_list, normalize_ast_type(type)}
  end

  def normalize_ast_type({name, _, args}) do
    {name, Enum.count(args)}
  end

  def normalize_ast_type([type]) do
    {:list, normalize_ast_type(type)}
  end

  def normalize_ast_type(name) when is_atom(name), do: name

  def type_to_opts_type(types, env) when is_list(types),
    do: Enum.map(types, fn type -> type_to_opts_type(type, env) end)

  def type_to_opts_type(type, env) do
    case type do
      {:|, meta, args} ->
        {:|, meta, Enum.map(args, fn arg -> type_to_opts_type(arg, env) end)}

      {{:., meta, [{:__aliases__, _, _} = alias, type_name]}, _, []} = orig
      when is_atom(type_name) ->
        case expand_aliases(alias, env) do
          {_, _, [:String]} ->
            orig

          {_, _, [expanded]} ->
            {{:., meta,
              [
                {:__aliases__, [], [expanded]},
                :"#{type_name}_opts"
              ]}, [], []}

          _ ->
            orig
        end

      {:%{}, meta, [{key_type, value_type}]} ->
        {:%{}, meta, [{type_to_opts_type(key_type, env), type_to_opts_type(value_type, env)}]}

      other ->
        other
    end
  end

  defp pretty_type_name({:list, val_type}), do: "[#{pretty_type_name(val_type)}]"

  defp pretty_type_name({:nonempty_list, val_type}),
    do: "nonempty([#{pretty_type_name(val_type)}])"

  defp pretty_type_name({:map, key_type, val_type}),
    do: "%{#{pretty_type_name(key_type)} => #{pretty_type_name(val_type)}}"

  defp pretty_type_name({:one_of, types}),
    do: Enum.map(types, &pretty_type_name/1) |> Enum.join(" | ")

  defp pretty_type_name({:module, name}), do: "#{name}"

  defp pretty_type_name({caller, called, num_args}),
    do: "#{pretty_type_name(caller)}.#{pretty_type_name(called)}/#{num_args}"

  defp pretty_type_name({name, 0}) when is_atom(name), do: "#{name}()"
  defp pretty_type_name(name) when is_atom(name), do: "#{inspect(name)}"
end
