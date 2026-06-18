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

  test "succeeds with default on recursive opts" do
    assert {:ok, validated} = validate_recursive_opts(name: "No payloads")
    assert %{name: "No payloads", payloads: []} == Enum.into(validated, %{})
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

    assert %{name: "Payloads", payloads: [a, b, c]} = Enum.into(validated, %{})
    assert %{data: ~s|"Data1"|, metadata: %{"encoding" => "json/plain"}} == Enum.into(a, %{})

    assert %{
             data: :erlang.term_to_binary(:atom),
             metadata: %{"encoding" => "application/x-erlang-term"}
           } == Enum.into(b, %{})

    assert %{data: <<123>>, metadata: %{}} == Enum.into(c, %{})
  end
end
