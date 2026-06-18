defmodule TemporalEngine.Data.OptsValidationTest do
  use TemporalEngine.Data.TypeSpec
  use ExUnit.Case

  alias TemporalEngine.Data.OptsValidationTest

  deftype :example do
    @default %{}
    @type metadata :: required :: %{String.t() => binary()}

    @type data :: required :: binary()
  end

  deftype :optional do
    @type maybe_nil :: integer()

    @default 1
    @type default_one :: integer()

    @default 2
    @type always_number :: required :: integer()
  end

  deftype :recursive do
    @type name :: required :: String.t()

    @type optionals :: OptsValidationTest.optional()

    @default []
    @type payloads :: [OptsValidationTest.example()]
  end

  test "allows for correct opts" do
    assert {:ok, _validated} = validate_example_opts(data: <<123>>)
  end

  test "returns opts with defaults filled out" do
    {:ok, validated} = validate_example_opts(data: <<123>>)
    assert %{data: <<123>>, metadata: %{}} == Enum.into(validated, %{})
  end

  test "fails when missing required opts" do
    assert {:error, errors} = validate_example_opts([])
    assert Keyword.has_key?(errors, :data)
  end

  test "fails when given invalid opts" do
    assert {:error, errors} = validate_example_opts(metadata: 123)
    assert Keyword.has_key?(errors, :metadata)
  end

  test "succeeds when valid map given" do
    assert {:ok, validated} = validate_example_opts(data: <<>>, metadata: %{"abc" => "def"})
    assert %{metadata: %{"abc" => "def"}} = Enum.into(validated, %{})
  end

  test "fails when invalid key given to map" do
    assert {:error, errors} = validate_example_opts(metadata: %{123 => "abc"})
    assert Keyword.has_key?(errors, :metadata)
  end

  test "fails when invalid values given to map" do
    assert {:error, errors} = validate_example_opts(metadata: %{"abc" => 123})
    assert Keyword.has_key?(errors, :metadata)
  end

  test "succeeds with optionals" do
    assert {:ok, validated} = validate_optional_opts([])
    assert %{maybe_nil: nil, default_one: 1, always_number: 2} == Enum.into(validated, %{})
  end

  test "succeeds making a non-required field nil" do
    assert {:ok, validated} = validate_optional_opts(default_one: nil)
    assert %{default_one: nil} = Enum.into(validated, %{})
  end

  test "rejects making a required field nil" do
    assert {:error, errors} = validate_optional_opts(always_number: nil)
    assert Keyword.has_key?(errors, :always_number)
  end

  test "succeeds with defaults on recursive opts" do
    assert {:ok, validated} = validate_recursive_opts(name: "No payloads")
    assert %{name: "No payloads", payloads: [], optionals: nil} == Enum.into(validated, %{})
  end

  test "fails when failing recursive opts" do
    assert {:error, errors} =
             validate_recursive_opts(name: "No payloads", optionals: [always_number: nil])

    assert Keyword.has_key?(errors, :optionals)
  end

  test "succeeds valid recursive opts" do
    assert {:ok, validated} =
             validate_recursive_opts(
               name: "Payloads",
               payloads: [
                 [data: ~s|"Data1"|, metadata: %{"encoding" => "json/plain"}],
                 [
                   data: :erlang.term_to_binary(:atom),
                   metadata: %{"encoding" => "application/x-erlang-term"}
                 ],
                 [data: <<123>>]
               ]
             )

    assert {:ok, created} = recursive_from_opts(validated)
    assert recursive(name: "Payloads", payloads: [a, b, c]) = created
    assert example(data: ~s|"Data1"|, metadata: %{"encoding" => "json/plain"}) = a

    erl_term = :erlang.term_to_binary(:atom)
    assert example(data: ^erl_term, metadata: %{"encoding" => "application/x-erlang-term"}) = b

    assert example(data: <<123>>, metadata: %{}) = c
  end

  test "converts to module version" do
    {:ok, validated} =
      validate_recursive_opts(
        name: "Payloads",
        payloads: [
          [data: ~s|"Data1"|, metadata: %{"encoding" => "json/plain"}],
          [
            data: :erlang.term_to_binary(:atom),
            metadata: %{"encoding" => "application/x-erlang-term"}
          ],
          [data: <<123>>]
        ]
      )

    {:ok, created} = recursive_from_opts(validated)

    assert %OptsValidationTest.Recursive{
             name: "Payloads",
             optionals: nil,
             payloads: [a, b, c]
           } = OptsValidationTest.Recursive.from_record(created)

    assert %OptsValidationTest.Example{data: ~s|"Data1"|, metadata: %{"encoding" => "json/plain"}} =
             a

    erl_term = :erlang.term_to_binary(:atom)

    assert %OptsValidationTest.Example{
             data: ^erl_term,
             metadata: %{"encoding" => "application/x-erlang-term"}
           } = b

    assert %OptsValidationTest.Example{data: <<123>>} = c
  end
end
