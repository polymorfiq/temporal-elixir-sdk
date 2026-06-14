defprotocol TemporalEngine.Worker do
  alias TemporalEngine.Data.Activation
  alias TemporalEngine.Data.ActivationCompletion
  alias TemporalEngine.Data.ActivityTask
  alias TemporalEngine.Data.ActivityTaskCompletion
  alias TemporalEngine.Data.NexusTask

  @spec poll_workflow_activation(t()) ::
          {:ok, Activation.activation() | nil} | {:error, reason :: term()}
  def poll_workflow_activation(worker)

  @spec poll_activity_task(t()) ::
          {:ok, ActivityTask.activity_task() | nil} | {:error, reason :: term()}
  def poll_activity_task(worker)

  @spec poll_nexus_task(t()) :: {:ok, NexusTask.nexus_task() | nil} | {:error, reason :: term()}
  def poll_nexus_task(worker)

  @spec complete_workflow_activation(t(), ActivationCompletion.completion()) ::
          :ok | {:error, reason :: term()}
  def complete_workflow_activation(worker, completion)

  @spec complete_activity_task(t(), ActivityTaskCompletion.completion()) ::
          :ok | {:error, reason :: term()}
  def complete_activity_task(worker, completion)

  @spec initiate_shutdown(t()) :: :ok | {:error, reason :: term()}
  def initiate_shutdown(worker)

  @spec finalize_shutdown(t()) :: :ok | {:error, reason :: term()}
  def finalize_shutdown(worker)
end
