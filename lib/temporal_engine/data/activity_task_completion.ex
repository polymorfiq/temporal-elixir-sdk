defmodule TemporalEngine.Data.ActivityTaskCompletion do
  require Record

  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  @type task_completion ::
          task_completed() | task_failed() | task_cancelled() | task_will_complete_async()

  Record.defrecord(:task_completed, [:payload, :task_token])

  @type task_completed ::
          record(:task_completed, payload: Payload.payload() | nil, task_token: binary())

  Record.defrecord(:task_failed, [:failure, :task_token])

  @type task_failed ::
          record(:task_failed, failure: Failure.failure() | nil, task_token: binary())

  Record.defrecord(:task_cancelled, [:failure, :task_token])

  @type task_cancelled ::
          record(:task_cancelled, failure: Failure.failure() | nil, task_token: binary())

  Record.defrecord(:task_will_complete_async, [:task_token])
  @type task_will_complete_async :: record(:task_will_complete_async, task_token: binary())
end
