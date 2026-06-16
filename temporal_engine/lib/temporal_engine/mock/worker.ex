defmodule TemporalEngine.Mock.Worker do
  defstruct [:real_worker, :real_id, :forwards, :state]

  def new(real_worker) do
    {:ok, state} =
      Agent.start_link(fn ->
        %{silence_engine: false, silence_client: false}
      end)

    %__MODULE__{
      real_worker: real_worker,
      real_id: TemporalEngine.Worker.id(real_worker),
      state: state
    }
  end

  def mocked_for_id(id) do
    case :ets.lookup(TemporalEngine.Mock.Storage.set(), {:worker, id}) do
      [{_, mocked}] -> {:ok, mocked}
      _ -> {:error, "No mocks found"}
    end
  end

  def send_commands(worker, run_id, commands) do
    import TemporalEngine.Data.ActivationCompletion

    TemporalEngine.Worker.complete_workflow_activation(
      worker,
      completion(
        run_id: run_id,
        result: success(commands: commands)
      )
    )
  end

  def send_activity_task_completion(worker, completion) do
    TemporalEngine.Worker.complete_activity_task(worker, completion)
  end

  def set_silence_client(worker, silence) do
    Agent.update(worker.state, &Map.put(&1, :silence_client, silence))
  end

  def set_silence_engine(worker, silence) do
    Agent.update(worker.state, &Map.put(&1, :silence_engine, silence))
  end

  def forward_sent_completions(worker) do
    Registry.register(
      TemporalEngine.Mock.Registry,
      {:worker, worker.real_id, :sent_completions},
      :forward
    )
  end

  def forward_sent_commands(worker) do
    Registry.register(
      TemporalEngine.Mock.Registry,
      {:worker, worker.real_id, :sent_commands},
      :forward
    )
  end

  def forward_received_jobs(worker) do
    Registry.register(
      TemporalEngine.Mock.Registry,
      {:worker, worker.real_id, :received_jobs},
      :forward
    )
  end

  def forward_received_activations(worker) do
    Registry.register(
      TemporalEngine.Mock.Registry,
      {:worker, worker.real_id, :received_activations},
      :forward
    )
  end

  def forward_received_activity_tasks(worker) do
    Registry.register(
      TemporalEngine.Mock.Registry,
      {:worker, worker.real_id, :received_activity_tasks},
      :forward
    )
  end
end

defimpl TemporalEngine.Worker, for: TemporalEngine.Mock.Worker do
  alias TemporalEngine.Data.Payload

  def id(worker) do
    "mocked(#{worker.real_id})"
  end

  def poll_workflow_activation(worker) do
    resp =
      with {:ok, activation} <- TemporalEngine.Worker.poll_workflow_activation(worker.real_worker) do
        Registry.lookup(
          TemporalEngine.Mock.Registry,
          {:worker, worker.real_id, :received_activations}
        )
        |> Enum.each(fn {forward_to, _} ->
          send(forward_to, {:activation, activation})
        end)

        Registry.lookup(TemporalEngine.Mock.Registry, {:worker, worker.real_id, :received_jobs})
        |> Enum.each(fn {forward_to, _} ->
          import TemporalEngine.Data.Activation
          import TemporalEngine.Data.Jobs

          activation(activation, :jobs)
          |> Enum.each(fn
            initialize_workflow(arguments: args) = job ->
              send(
                forward_to,
                {:job,
                 initialize_workflow(job, arguments: Enum.map(args, &Payload.value_from_record/1))}
              )

            resolve_activity(result: activity_completed() = result) = job ->
              activity_completed(result: payload) = result

              result =
                if payload do
                  activity_completed(result, result: Payload.value_from_record(payload))
                else
                  result
                end

              send(
                forward_to,
                {:job, resolve_activity(job, result: result)}
              )

            job ->
              send(forward_to, {:job, job})
          end)
        end)

        {:ok, activation}
      end

    cond do
      match?({:error, "core_shutdown"}, resp) ->
        resp

      Agent.get(worker.state, & &1.silence_engine) ->
        {:ok, nil}

      true ->
        resp
    end
  end

  def poll_activity_task(worker) do
    resp =
      TemporalEngine.Worker.poll_activity_task(worker.real_worker)

    with {:ok, activity_task} <- resp do
      Registry.lookup(
        TemporalEngine.Mock.Registry,
        {:worker, worker.real_id, :received_activity_tasks}
      )
      |> Enum.each(fn {forward_to, _} ->
        send(forward_to, {:activity_task, activity_task})
      end)
    end

    cond do
      match?({:error, "core_shutdown"}, resp) ->
        resp

      Agent.get(worker.state, & &1.silence_engine) ->
        {:ok, nil}

      true ->
        resp
    end
  end

  def poll_nexus_task(worker) do
    resp = TemporalEngine.Worker.poll_nexus_task(worker.real_worker)

    cond do
      match?({:error, "core_shutdown"}, resp) ->
        resp

      Agent.get(worker.state, & &1.silence_engine) ->
        {:ok, nil}

      true ->
        resp
    end
  end

  def complete_workflow_activation(worker, completion) do
    import TemporalEngine.Data.ActivationCompletion
    import TemporalEngine.Data.Commands

    case completion do
      completion(result: success(commands: commands)) ->
        Registry.lookup(TemporalEngine.Mock.Registry, {:worker, worker.real_id, :sent_commands})
        |> Enum.each(fn {forward_to, _} ->
          commands
          |> Enum.each(fn
            schedule_activity(arguments: args) = cmd ->
              send(
                forward_to,
                {:command,
                 schedule_activity(cmd, arguments: Enum.map(args, &Payload.value_from_record/1))}
              )

            complete_workflow_execution(result: payload) = cmd when is_tuple(payload) ->
              send(
                forward_to,
                {:command,
                 complete_workflow_execution(cmd, result: Payload.value_from_record(payload))}
              )

            cmd ->
              send(forward_to, {:command, cmd})
          end)
        end)

      _ ->
        :ok
    end

    Registry.lookup(TemporalEngine.Mock.Registry, {:worker, worker.real_id, :sent_completions})
    |> Enum.each(fn {forward_to, _} ->
      send(forward_to, {:completion, completion})
    end)

    if Agent.get(worker.state, & &1.silence_client) do
      :ok
    else
      TemporalEngine.Worker.complete_workflow_activation(worker.real_worker, completion)
    end
  end

  def complete_activity_task(worker, completion) do
    if Agent.get(worker.state, & &1.silence_client) do
      :ok
    else
      TemporalEngine.Worker.complete_activity_task(worker.real_worker, completion)
    end
  end

  def initiate_shutdown(worker) do
    TemporalEngine.Worker.initiate_shutdown(worker.real_worker)
  end

  def finalize_shutdown(worker) do
    TemporalEngine.Worker.finalize_shutdown(worker.real_worker)
  end
end
