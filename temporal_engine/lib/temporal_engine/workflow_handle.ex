defprotocol TemporalEngine.WorkflowHandle do
  require Record

  require TemporalEngine.Opts.HandleOpts

  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Opts.HandleOpts

  @spec get_result(t(), HandleOpts.get_workflow_result_opts_opts()) ::
          {:ok, Payload.payload()} | {:error, reason :: term()}
  def get_result(handle, opts)
end
