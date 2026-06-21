defmodule Temporal.Workflow do
  defmacro __using__(opts) do
    activities = Keyword.get(opts, :activities)

    imports =
      quote do
        import Temporal.Workflow.ActivityActions
      end

    activities_section =
      if activities do
        activities = Enum.map(activities, &{__CALLER__.module, &1})

        quote do
          def _temporal_activities, do: unquote(activities)
        end
      end

    quote do
      (unquote_splicing([
         imports,
         activities_section
       ]))
    end
  end
end
