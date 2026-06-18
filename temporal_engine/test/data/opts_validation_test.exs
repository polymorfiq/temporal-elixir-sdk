defmodule TemporalEngine.Data.OptsValidationTest do
  use TemporalEngine.Data.TypeSpec
  use ExUnit.Case

  alias TemporalEngine.Data.Payload

  deftype :example do
    @default %{}
    @type metadata :: required :: %{String.t() => binary()}

    @type data :: required :: binary()

    @default []
    @type external_payloads :: required :: [Payload.external_payload_details()]
  end

  test "allows for correct opts" do
    assert {:ok, _validated} = validate_example_opts(data: <<123>>)
  end

  test "returns opts with defaults filled out" do
    {:ok, validated} = validate_example_opts(data: <<123>>) |> IO.inspect(label: "WHAT?")
    assert %{data: <<123>>, metadata: %{}, external_payloads: []} = Enum.into(validated, %{})
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
    assert {:ok, _} = validate_example_opts(data: <<>>, metadata: %{"abc" => "def"})
  end

  test "fails when invalid key given to map" do
    assert {:error, errors} = validate_example_opts(metadata: %{123 => "abc"})
    assert Keyword.has_key?(errors, :metadata)
  end

  test "fails when invalid values given to map" do
    assert {:error, errors} = validate_example_opts(metadata: %{"abc" => 123})
    assert Keyword.has_key?(errors, :metadata)
  end
end
