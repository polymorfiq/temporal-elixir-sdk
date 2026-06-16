defprotocol TemporalEngine.WorkflowHandle do
  require Record

  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Duration

  @spec get_result(t(), get_result_opts()) ::
          {:ok, Payload.payload()} | {:error, reason :: term()}
  def get_result(handle, opts)

  Record.defrecord(:get_result_opts, [:follow_runs, timeout: nil])

  @type get_result_opts ::
          record(:get_result_opts, follow_runs: bool(), timeout: Duration.duration() | nil)
end
