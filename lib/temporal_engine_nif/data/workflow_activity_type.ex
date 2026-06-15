defmodule TemporalEngineNif.Data.WorkflowActivityType do
  defstruct [:name]

  import TemporalEngine.Data.Failure

  @type t :: %__MODULE__{name: String.t()}

  @spec to_record(t() | nil) :: Failure.activity_type() | nil
  def to_record(nil), do: nil

  def to_record(%__MODULE__{name: name}) do
    activity_type(name: name)
  end

  @spec from_record(Failure.activity_type() | nil) :: t() | nil
  def from_record(nil), do: nil

  def from_record(activity_type(name: name)) do
    %__MODULE__{name: name}
  end
end
