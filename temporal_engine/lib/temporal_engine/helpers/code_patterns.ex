defmodule TemporalEngine.Helpers.CodePatterns do
  defmacro patterns(name, do: do_block) do
    patterns =
      build_extraction_pattern(do_block)
      |> Enum.map(fn {name, {pattern, extractions}} ->
        {name, {Macro.escape(pattern), Macro.escape(extractions)}}
      end)

    quote do
      Module.put_attribute(__MODULE__, unquote(name), unquote(patterns))
    end
  end

  def extract_with_patterns(patterns, ast) do
    extractions =
      patterns
      |> Enum.flat_map(fn {name, {pattern, extraction_kw_list}} ->
        quote do
          unquote(pattern) = matched, acc ->
            {matched, [{unquote(name), unquote(extraction_kw_list)} | acc]}
        end
      end)

    extractions =
      extractions ++
        [
          {:->, [],
           [
             [{:other, [], Elixir}, {:a, [], Elixir}],
             {{:other, [], Elixir}, {:a, [], Elixir}}
           ]}
        ]

    #    {:fn, [], [{:->, [], []}]}

    env = Code.env_for_eval(__ENV__)

    {result, _, _} =
      Code.eval_quoted_with_env({:fn, [], extractions}, [], env)

    {_, extracted} = Macro.prewalk(ast, [], result)

    Enum.reverse(extracted)
  end

  def build_extraction_pattern({:__block__, _, block_contents}) do
    block_contents
    |> Enum.flat_map(&build_extraction_pattern/1)
  end

  def build_extraction_pattern({:"::", _, [{pattern_name, _, _}, ast]}) do
    {ast, extracted} =
      ast
      |> Macro.escape(prune_metadata: true)
      |> Macro.prewalk([], fn
        {:{}, _, [:extract!, _, _]} = curr, acc ->
          {{:extract!, _, [extraction]}, _} = Code.eval_quoted(curr)
          var_name = Macro.to_string(extraction) |> String.to_atom()
          {Macro.var(var_name, nil), [var_name | acc]}

        other, acc ->
          {other, acc}
      end)

    {ast, _} =
      Macro.prewalk(ast, [], fn
        {:{}, meta, [a, _, b]}, acc ->
          {{:{}, meta, [a, {:_, [], Elixir}, b]}, acc}

        other, acc ->
          {other, acc}
      end)

    extraction_kw_list = Enum.map(extracted, fn extract -> {extract, Macro.var(extract, nil)} end)
    [{pattern_name, {ast, extraction_kw_list}}]
  end
end
