ExUnit.start()

defmodule ChannelHelpers do
  defmacro __using__(_opts) do
    quote do
      defmacro assert_client_sends_commands(_ctx, cmd_patterns) do
        Enum.map(cmd_patterns, fn pattern ->
          quote do
            assert_receive {:to_engine, :command, unquote(pattern)}, 5000
          end
        end)
      end

      defmacro assert_engine_sends_jobs(_ctx, job_patterns) do
        Enum.map(job_patterns, fn pattern ->
          quote do
            assert_receive {:to_client, :job, unquote(pattern)}, 5000
          end
        end)
      end

      defmacro assert_engine_sends_activity_tasks(_ctx, task_patterns) do
        Enum.map(task_patterns, fn pattern ->
          quote do
            assert_receive {:to_client, :activity_task, unquote(pattern)}, 5000
          end
        end)
      end
    end
  end
end
