use crate::common::{SdkDuration, SdkTimestamp};
use crate::core_worker::SdkWorkerDeploymentVersion;
use rustler::NifStruct;
use std::collections::HashMap;
use temporalio_sdk_common::protos::coresdk::activity_result::activity_resolution::Status as ActivityResolutionStatus;
use temporalio_sdk_common::protos::coresdk::child_workflow::child_workflow_result::Status as ChildWorkflowStatus;
use temporalio_sdk_common::protos::coresdk::nexus::nexus_operation_result::Status as NexusOperationResultStatus;
use temporalio_sdk_common::protos::coresdk::workflow_activation;
use temporalio_sdk_common::protos::coresdk::workflow_activation::workflow_activation_job::Variant as ActivationVariant;
use temporalio_sdk_common::protos::coresdk::workflow_commands::WorkflowCommand;
use temporalio_sdk_common::protos::temporal::api as temporal_api;
use temporalio_sdk_common::protos::temporal::api::failure::v1::failure::FailureInfo;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use temporalio_sdk_common::protos::coresdk::workflow_completion;
use temporalio_sdk_common::protos::coresdk::workflow_completion::workflow_activation_completion::Status as WorkflowActivationCompletionStatus;
use temporalio_sdk_common::protos::temporal::api::sdk::v1::UserMetadata;
use temporalio_sdk_common::protos::coresdk::workflow_commands::workflow_command::Variant as WorkflowCommandVariant;
use temporalio_sdk_common::protos::coresdk::workflow_commands;

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivation"]
pub struct SdkWorkflowActivation {
    pub run_id: String,
    pub timestamp: Option<SdkTimestamp>,
    pub is_replaying: bool,
    pub history_length: u32,
    pub jobs: Vec<SdkWorkflowActivationJob>,
    pub available_internal_flags: Vec<u32>,
    pub history_size_bytes: u64,
    pub continue_as_new_suggested: bool,
    pub deployment_version_for_current_task: Option<SdkWorkerDeploymentVersion>,
    pub last_sdk_version: String,
    pub suggest_continue_as_new_reasons: Vec<i32>,
    pub target_worker_deployment_version_changed: bool,
}

impl From<workflow_activation::WorkflowActivation> for SdkWorkflowActivation {
    fn from(external: workflow_activation::WorkflowActivation) -> Self {
        Self {
            run_id: external.run_id,
            timestamp: external.timestamp.try_into_or_none(),
            is_replaying: external.is_replaying,
            history_length: external.history_length,
            jobs: external.jobs.iter().map(|val| val.clone().into()).collect(),
            available_internal_flags: external.available_internal_flags,
            history_size_bytes: external.history_size_bytes,
            continue_as_new_suggested: external.continue_as_new_suggested,
            deployment_version_for_current_task: external.deployment_version_for_current_task.try_into_or_none(),
            last_sdk_version: external.last_sdk_version,
            suggest_continue_as_new_reasons: external.suggest_continue_as_new_reasons,
            target_worker_deployment_version_changed: external.target_worker_deployment_version_changed,
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationJob"]
pub struct SdkWorkflowActivationJob {
    variant: Option<SdkWorkflowActivationJobVariant>,
}

impl From<workflow_activation::WorkflowActivationJob> for SdkWorkflowActivationJob {
    fn from(external: workflow_activation::WorkflowActivationJob) -> Self {
        Self {
            variant: external.variant.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationJobVariant"]
pub struct SdkWorkflowActivationJobVariant {
    initialize_workflow: Option<SdkActivationInitializeWorkflow>,
    fire_timer: Option<SdkActivationFireTimer>,
    update_random_seed: Option<SdkActivationUpdateRandomSeed>,
    query_workflow: Option<SdkActivationQueryWorkflow>,
    cancel_workflow: Option<SdkActivationCancelWorkflow>,
    signal_workflow: Option<SdkActivationSignalWorkflow>,
    resolve_activity: Option<SdkActivationResolveActivity>,
    notify_has_patch: Option<SdkActivationNotifyHasPatch>,
    resolve_child_workflow_execution_start: Option<SdkActivationResolveChildWorkflowExecutionStart>,
    resolve_child_workflow_execution: Option<SdkActivationResolveChildWorkflowExecution>,
    resolve_signal_external_workflow: Option<SdkActivationResolveSignalExternalWorkflow>,
    resolve_request_cancel_external_workflow:
        Option<SdkActivationResolveRequestCancelExternalWorkflow>,
    do_update: Option<SdkActivationDoUpdate>,
    resolve_nexus_operation_start: Option<SdkActivationResolveNexusOperationStart>,
    resolve_nexus_operation: Option<SdkActivationResolveNexusOperation>,
    remove_from_cache: Option<SdkActivationRemoveFromCache>,
}

impl From<ActivationVariant> for SdkWorkflowActivationJobVariant {
    fn from(external: ActivationVariant) -> Self {
        match external {
            ActivationVariant::InitializeWorkflow(activation) => Self {
                initialize_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::FireTimer(activation) => Self {
                fire_timer: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::UpdateRandomSeed(activation) => Self {
                update_random_seed: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::QueryWorkflow(activation) => Self {
                query_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::CancelWorkflow(activation) => Self {
                cancel_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::SignalWorkflow(activation) => Self {
                signal_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveActivity(activation) => Self {
                resolve_activity: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::NotifyHasPatch(activation) => Self {
                notify_has_patch: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveChildWorkflowExecutionStart(activation) => Self {
                resolve_child_workflow_execution_start: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveChildWorkflowExecution(activation) => Self {
                resolve_child_workflow_execution: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveSignalExternalWorkflow(activation) => Self {
                resolve_signal_external_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveRequestCancelExternalWorkflow(activation) => Self {
                resolve_request_cancel_external_workflow: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::DoUpdate(activation) => Self {
                do_update: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveNexusOperationStart(activation) => Self {
                resolve_nexus_operation_start: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::ResolveNexusOperation(activation) => Self {
                resolve_nexus_operation: Some(activation.into()),
                ..Self::default()
            },

            ActivationVariant::RemoveFromCache(activation) => Self {
                remove_from_cache: Some(activation.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationInitializeWorkflow"]
pub struct SdkActivationInitializeWorkflow {
    pub workflow_type: String,
    pub workflow_id: String,
    pub arguments: Vec<SdkActivationPayload>,
    pub randomness_seed: u64,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub identity: String,
    pub parent_workflow_info: Option<SdkWorkflowNamespacedExecution>,
    pub workflow_execution_timeout: Option<SdkDuration>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub continued_from_execution_run_id: String,
    pub continued_initiator: i32,
    pub continued_failure: Option<SdkWorkflowFailure>,
    pub last_completion_result: Option<SdkActivationPayloads>,
    pub first_execution_run_id: String,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub attempt: i32,
    pub cron_schedule: String,
    pub workflow_execution_expiration_time: Option<SdkTimestamp>,
    pub cron_schedule_to_schedule_interval: Option<SdkDuration>,
    pub memo: Option<SdkWorkflowMemo>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub start_time: Option<SdkTimestamp>,
    pub root_workflow: Option<SdkWorkflowExecution>,
    pub priority: Option<SdkWorkflowPriority>,
}

impl From<workflow_activation::InitializeWorkflow> for SdkActivationInitializeWorkflow {
    fn from(external: workflow_activation::InitializeWorkflow) -> Self {
        Self {
            workflow_type: external.workflow_type,
            workflow_id: external.workflow_id,
            arguments: external.arguments.iter().map(|val| val.into()).collect(),
            randomness_seed: external.randomness_seed,
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            identity: external.identity,
            parent_workflow_info: external.parent_workflow_info.try_into_or_none(),
            workflow_execution_timeout: external.workflow_execution_timeout.try_into_or_none(),
            workflow_run_timeout: external.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: external.workflow_task_timeout.try_into_or_none(),
            continued_from_execution_run_id: external.continued_from_execution_run_id,
            continued_initiator: external.continued_initiator,
            continued_failure: external.continued_failure.try_into_or_none(),
            last_completion_result: external.last_completion_result.try_into_or_none(),
            first_execution_run_id: external.first_execution_run_id,
            retry_policy: external.retry_policy.try_into_or_none(),
            attempt: external.attempt,
            cron_schedule: external.cron_schedule,
            workflow_execution_expiration_time: external
                .workflow_execution_expiration_time
                .try_into_or_none(),
            cron_schedule_to_schedule_interval: external
                .cron_schedule_to_schedule_interval
                .try_into_or_none(),
            memo: external.memo.try_into_or_none(),
            search_attributes: external.search_attributes.try_into_or_none(),
            start_time: external.start_time.try_into_or_none(),
            root_workflow: external.root_workflow.try_into_or_none(),
            priority: external.priority.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationFireTimer"]
pub struct SdkActivationFireTimer {
    pub seq: u32,
}

impl From<workflow_activation::FireTimer> for SdkActivationFireTimer {
    fn from(external: workflow_activation::FireTimer) -> Self {
        Self { seq: external.seq }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationUpdateRandomSeed"]
pub struct SdkActivationUpdateRandomSeed {
    pub randomness_seed: u64,
}

impl From<workflow_activation::UpdateRandomSeed> for SdkActivationUpdateRandomSeed {
    fn from(external: workflow_activation::UpdateRandomSeed) -> Self {
        Self {
            randomness_seed: external.randomness_seed,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationQueryWorkflow"]
pub struct SdkActivationQueryWorkflow {
    pub query_id: String,
    pub query_type: String,
    pub arguments: Vec<SdkActivationPayload>,
    pub headers: HashMap<String, SdkActivationPayload>,
}

impl From<workflow_activation::QueryWorkflow> for SdkActivationQueryWorkflow {
    fn from(external: workflow_activation::QueryWorkflow) -> Self {
        Self {
            query_id: external.query_id,
            query_type: external.query_type,
            arguments: external.arguments.iter().map(|val| val.into()).collect(),
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationCancelWorkflow"]
pub struct SdkActivationCancelWorkflow {
    pub reason: String,
}

impl From<workflow_activation::CancelWorkflow> for SdkActivationCancelWorkflow {
    fn from(external: workflow_activation::CancelWorkflow) -> Self {
        Self {
            reason: external.reason,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationSignalWorkflow"]
pub struct SdkActivationSignalWorkflow {
    pub signal_name: String,
    pub input: Vec<SdkActivationPayload>,
    pub identity: String,
    pub headers: HashMap<String, SdkActivationPayload>,
}

impl From<workflow_activation::SignalWorkflow> for SdkActivationSignalWorkflow {
    fn from(external: workflow_activation::SignalWorkflow) -> Self {
        Self {
            signal_name: external.signal_name,
            input: external.input.iter().map(|val| val.into()).collect(),
            identity: external.identity,
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveActivity"]
pub struct SdkActivationResolveActivity {
    pub seq: u32,
    pub result: Option<SdkActivityResolution>,
    pub is_local: bool,
}

impl From<workflow_activation::ResolveActivity> for SdkActivationResolveActivity {
    fn from(external: workflow_activation::ResolveActivity) -> Self {
        Self {
            seq: external.seq,
            result: external.result.try_into_or_none(),
            is_local: external.is_local,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationNotifyHasPatch"]
pub struct SdkActivationNotifyHasPatch {
    pub patch_id: String,
}

impl From<workflow_activation::NotifyHasPatch> for SdkActivationNotifyHasPatch {
    fn from(external: workflow_activation::NotifyHasPatch) -> Self {
        Self {
            patch_id: external.patch_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveChildWorkflowExecutionStart"]
pub struct SdkActivationResolveChildWorkflowExecutionStart {
    pub seq: u32,
    pub status: Option<SdkWorkflowChildExecutionStartStatus>,
}

impl From<workflow_activation::ResolveChildWorkflowExecutionStart>
    for SdkActivationResolveChildWorkflowExecutionStart
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecutionStart) -> Self {
        Self {
            seq: external.seq,
            status: external.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveChildWorkflowExecution"]
pub struct SdkActivationResolveChildWorkflowExecution {
    pub seq: u32,
    pub result: Option<SdkWorkflowChildResult>,
}

impl From<workflow_activation::ResolveChildWorkflowExecution>
    for SdkActivationResolveChildWorkflowExecution
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            result: external.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveSignalExternalWorkflow"]
pub struct SdkActivationResolveSignalExternalWorkflow {
    pub seq: u32,
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<workflow_activation::ResolveSignalExternalWorkflow>
    for SdkActivationResolveSignalExternalWorkflow
{
    fn from(external: workflow_activation::ResolveSignalExternalWorkflow) -> Self {
        Self {
            seq: external.seq,
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveRequestCancelExternalWorkflow"]
pub struct SdkActivationResolveRequestCancelExternalWorkflow {
    pub seq: u32,
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<workflow_activation::ResolveRequestCancelExternalWorkflow>
    for SdkActivationResolveRequestCancelExternalWorkflow
{
    fn from(external: workflow_activation::ResolveRequestCancelExternalWorkflow) -> Self {
        Self {
            seq: external.seq,
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationDoUpdate"]
pub struct SdkActivationDoUpdate {
    pub id: String,
    pub protocol_instance_id: String,
    pub name: String,
    pub input: Vec<SdkActivationPayload>,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub meta: Option<SdkUpdateMeta>,
    pub run_validator: bool,
}

impl From<workflow_activation::DoUpdate> for SdkActivationDoUpdate {
    fn from(external: workflow_activation::DoUpdate) -> Self {
        Self {
            id: external.id,
            protocol_instance_id: external.protocol_instance_id,
            name: external.name,
            input: external.input.iter().map(|val| val.into()).collect(),
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            meta: external.meta.try_into_or_none(),
            run_validator: external.run_validator,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveNexusOperationStart"]
pub struct SdkActivationResolveNexusOperationStart {
    pub seq: u32,
    pub status: Option<SdkWorkflowResolveNexusOperationStartStatus>,
}

impl From<workflow_activation::ResolveNexusOperationStart>
    for SdkActivationResolveNexusOperationStart
{
    fn from(external: workflow_activation::ResolveNexusOperationStart) -> Self {
        Self {
            seq: external.seq,
            status: external.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationResolveNexusOperation"]
pub struct SdkActivationResolveNexusOperation {
    pub seq: u32,
    pub result: Option<SdkWorkflowNexusOperationResult>,
}

impl From<workflow_activation::ResolveNexusOperation> for SdkActivationResolveNexusOperation {
    fn from(external: workflow_activation::ResolveNexusOperation) -> Self {
        Self {
            seq: external.seq,
            result: external.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationRemoveFromCache"]
pub struct SdkActivationRemoveFromCache {
    pub message: String,
    pub reason: i32,
}

impl From<workflow_activation::RemoveFromCache> for SdkActivationRemoveFromCache {
    fn from(external: workflow_activation::RemoveFromCache) -> Self {
        Self {
            message: external.message,
            reason: external.reason,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowNexusOperationResult"]
pub struct SdkWorkflowNexusOperationResult {
    pub status: Option<SdkWorkflowNexusOperationStatus>,
}

impl From<temporalio_sdk_common::protos::coresdk::nexus::NexusOperationResult>
    for SdkWorkflowNexusOperationResult
{
    fn from(external: temporalio_sdk_common::protos::coresdk::nexus::NexusOperationResult) -> Self {
        Self {
            status: external.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowNexusOperationStatus"]
pub struct SdkWorkflowNexusOperationStatus {
    pub completed: Option<SdkActivationPayload>,
    pub failed: Option<SdkWorkflowFailure>,
    pub cancelled: Option<SdkWorkflowFailure>,
    pub timed_out: Option<SdkWorkflowFailure>,
}

impl From<NexusOperationResultStatus> for SdkWorkflowNexusOperationStatus {
    fn from(external: NexusOperationResultStatus) -> Self {
        match external {
            NexusOperationResultStatus::Completed(payload) => Self {
                completed: Some(payload.into()),
                ..Self::default()
            },

            NexusOperationResultStatus::Failed(failure) => Self {
                failed: Some(failure.into()),
                ..Self::default()
            },

            NexusOperationResultStatus::Cancelled(failure) => Self {
                cancelled: Some(failure.into()),
                ..Self::default()
            },

            NexusOperationResultStatus::TimedOut(failure) => Self {
                timed_out: Some(failure.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowResolveNexusOperationStartStatus"]
pub struct SdkWorkflowResolveNexusOperationStartStatus {
    pub operation_token: Option<String>,
    pub started_sync: Option<bool>,
    pub failed: Option<SdkWorkflowFailure>,
}

impl From<workflow_activation::resolve_nexus_operation_start::Status>
    for SdkWorkflowResolveNexusOperationStartStatus
{
    fn from(external: workflow_activation::resolve_nexus_operation_start::Status) -> Self {
        match external {
            workflow_activation::resolve_nexus_operation_start::Status::OperationToken(token) => {
                Self {
                    operation_token: Some(token),
                    ..Self::default()
                }
            }

            workflow_activation::resolve_nexus_operation_start::Status::StartedSync(started) => {
                Self {
                    started_sync: Some(started),
                    ..Self::default()
                }
            }

            workflow_activation::resolve_nexus_operation_start::Status::Failed(failure) => Self {
                failed: Some(failure.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.UpdateMeta"]
pub struct SdkUpdateMeta {
    pub update_id: String,
    pub identity: String,
}

impl From<temporal_api::update::v1::Meta> for SdkUpdateMeta {
    fn from(external: temporal_api::update::v1::Meta) -> Self {
        Self {
            update_id: external.update_id,
            identity: external.identity,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildResult"]
pub struct SdkWorkflowChildResult {
    pub status: Option<SdkWorkflowChildExecutionStatus>,
}

impl From<temporalio_sdk_common::protos::coresdk::child_workflow::ChildWorkflowResult>
    for SdkWorkflowChildResult
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::child_workflow::ChildWorkflowResult,
    ) -> Self {
        Self {
            status: external.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionStatus"]
pub struct SdkWorkflowChildExecutionStatus {
    pub completed: Option<SdkWorkflowChildExecutionCompletedStatus>,
    pub failed: Option<SdkWorkflowChildExecutionFailedStatus>,
    pub cancelled: Option<SdkWorkflowChildExecutionCancelledStatus>,
}

impl From<ChildWorkflowStatus> for SdkWorkflowChildExecutionStatus {
    fn from(external: ChildWorkflowStatus) -> Self {
        match external {
            ChildWorkflowStatus::Completed(status) => Self {
                completed: Some(status.into()),
                ..Self::default()
            },

            ChildWorkflowStatus::Failed(status) => Self {
                failed: Some(status.into()),
                ..Self::default()
            },

            ChildWorkflowStatus::Cancelled(status) => Self {
                cancelled: Some(status.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionCompletedStatus"]
pub struct SdkWorkflowChildExecutionCompletedStatus {
    pub result: Option<SdkActivationPayload>,
}

impl From<temporalio_sdk_common::protos::coresdk::child_workflow::Success>
    for SdkWorkflowChildExecutionCompletedStatus
{
    fn from(external: temporalio_sdk_common::protos::coresdk::child_workflow::Success) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionFailedStatus"]
pub struct SdkWorkflowChildExecutionFailedStatus {
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::child_workflow::Failure>
    for SdkWorkflowChildExecutionFailedStatus
{
    fn from(external: temporalio_sdk_common::protos::coresdk::child_workflow::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionCancelledStatus"]
pub struct SdkWorkflowChildExecutionCancelledStatus {
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::child_workflow::Cancellation>
    for SdkWorkflowChildExecutionCancelledStatus
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::child_workflow::Cancellation,
    ) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionStartStatus"]
pub struct SdkWorkflowChildExecutionStartStatus {
    pub succeeded: Option<SdkWorkflowChildExecutionStartSucceededStatus>,
    pub failed: Option<SdkWorkflowChildExecutionStartFailedStatus>,
    pub cancelled: Option<SdkWorkflowChildExecutionStartCancelledStatus>,
}

impl From<workflow_activation::resolve_child_workflow_execution_start::Status>
    for SdkWorkflowChildExecutionStartStatus
{
    fn from(external: workflow_activation::resolve_child_workflow_execution_start::Status) -> Self {
        match external {
            workflow_activation::resolve_child_workflow_execution_start::Status::Succeeded(
                status,
            ) => Self {
                succeeded: Some(status.into()),
                ..Self::default()
            },

            workflow_activation::resolve_child_workflow_execution_start::Status::Failed(status) => {
                Self {
                    failed: Some(status.into()),
                    ..Self::default()
                }
            }

            workflow_activation::resolve_child_workflow_execution_start::Status::Cancelled(
                status,
            ) => Self {
                cancelled: Some(status.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionStartSucceededStatus"]
pub struct SdkWorkflowChildExecutionStartSucceededStatus {
    pub run_id: String,
}

impl From<workflow_activation::ResolveChildWorkflowExecutionStartSuccess>
    for SdkWorkflowChildExecutionStartSucceededStatus
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecutionStartSuccess) -> Self {
        Self {
            run_id: external.run_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionStartFailedStatus"]
pub struct SdkWorkflowChildExecutionStartFailedStatus {
    pub workflow_id: String,
    pub workflow_type: String,
    pub cause: i32,
}

impl From<workflow_activation::ResolveChildWorkflowExecutionStartFailure>
    for SdkWorkflowChildExecutionStartFailedStatus
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecutionStartFailure) -> Self {
        Self {
            workflow_id: external.workflow_id,
            workflow_type: external.workflow_type,
            cause: external.cause,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionStartCancelledStatus"]
pub struct SdkWorkflowChildExecutionStartCancelledStatus {
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<workflow_activation::ResolveChildWorkflowExecutionStartCancelled>
    for SdkWorkflowChildExecutionStartCancelledStatus
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecutionStartCancelled) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolution"]
pub struct SdkActivityResolution {
    pub status: Option<SdkActivityResolutionStatus>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::ActivityResolution>
    for SdkActivityResolution
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::activity_result::ActivityResolution,
    ) -> Self {
        Self {
            status: external.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolutionStatus"]
pub struct SdkActivityResolutionStatus {
    pub completed: Option<SdkActivityResolutionCompletedStatus>,
    pub failed: Option<SdkActivityResolutionFailedStatus>,
    pub cancelled: Option<SdkActivityResolutionCancelledStatus>,
    pub backoff: Option<SdkActivityResolutionBackoffStatus>,
}

impl From<ActivityResolutionStatus> for SdkActivityResolutionStatus {
    fn from(external: ActivityResolutionStatus) -> Self {
        match external {
            ActivityResolutionStatus::Completed(status) => Self {
                completed: Some(status.into()),
                ..Self::default()
            },
            ActivityResolutionStatus::Failed(status) => Self {
                failed: Some(status.into()),
                ..Self::default()
            },
            ActivityResolutionStatus::Cancelled(status) => Self {
                cancelled: Some(status.into()),
                ..Self::default()
            },
            ActivityResolutionStatus::Backoff(status) => Self {
                backoff: Some(status.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolutionCompletedStatus"]
pub struct SdkActivityResolutionCompletedStatus {
    pub result: Option<SdkActivationPayload>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Success>
    for SdkActivityResolutionCompletedStatus
{
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Success) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolutionFailedStatus"]
pub struct SdkActivityResolutionFailedStatus {
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Failure>
    for SdkActivityResolutionFailedStatus
{
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolutionCancelledStatus"]
pub struct SdkActivityResolutionCancelledStatus {
    pub failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Cancellation>
    for SdkActivityResolutionCancelledStatus
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::activity_result::Cancellation,
    ) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityResolutionBackoffStatus"]
pub struct SdkActivityResolutionBackoffStatus {
    pub attempt: u32,
    pub backoff_duration: Option<SdkDuration>,
    pub original_schedule_time: Option<SdkTimestamp>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::DoBackoff>
    for SdkActivityResolutionBackoffStatus
{
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::DoBackoff) -> Self {
        Self {
            attempt: external.attempt,
            backoff_duration: external.backoff_duration.try_into_or_none(),
            original_schedule_time: external.original_schedule_time.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowMemo"]
pub struct SdkWorkflowMemo {
    pub fields: HashMap<String, SdkActivationPayload>,
}

impl From<temporal_api::common::v1::Memo> for SdkWorkflowMemo {
    fn from(external: temporal_api::common::v1::Memo) -> Self {
        Self {
            fields: external
                .fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Memo> for SdkWorkflowMemo {
    fn into(self) -> temporal_api::common::v1::Memo {
        temporal_api::common::v1::Memo {
            fields: self
                .fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect()
            }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowPriority"]
pub struct SdkWorkflowPriority {
    pub priority_key: i32,
    pub fairness_key: String,
    pub fairness_weight: f32,
}

impl From<temporal_api::common::v1::Priority> for SdkWorkflowPriority {
    fn from(external: temporal_api::common::v1::Priority) -> Self {
        Self {
            priority_key: external.priority_key,
            fairness_key: external.fairness_key,
            fairness_weight: external.fairness_weight,
        }
    }
}

impl Into<temporal_api::common::v1::Priority> for SdkWorkflowPriority {
    fn into(self) -> temporal_api::common::v1::Priority {
        temporal_api::common::v1::Priority {
            priority_key: self.priority_key,
            fairness_key: self.fairness_key,
            fairness_weight: self.fairness_weight,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowSearchAttributes"]
pub struct SdkWorkflowSearchAttributes {
    pub indexed_fields: HashMap<String, SdkActivationPayload>,
}

impl From<temporal_api::common::v1::SearchAttributes> for SdkWorkflowSearchAttributes {
    fn from(external: temporal_api::common::v1::SearchAttributes) -> Self {
        Self {
            indexed_fields: external
                .indexed_fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

impl Into<temporal_api::common::v1::SearchAttributes> for SdkWorkflowSearchAttributes {
    fn into(self) -> temporal_api::common::v1::SearchAttributes {
        temporal_api::common::v1::SearchAttributes {
            indexed_fields: self
                .indexed_fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowRetryPolicy"]
pub struct SdkWorkflowRetryPolicy {
    pub initial_interval: Option<SdkDuration>,
    pub backoff_coefficient: f64,
    pub maximum_interval: Option<SdkDuration>,
    pub maximum_attempts: i32,
    pub non_retryable_error_types: Vec<String>,
}

impl From<temporal_api::common::v1::RetryPolicy> for SdkWorkflowRetryPolicy {
    fn from(external: temporal_api::common::v1::RetryPolicy) -> Self {
        Self {
            initial_interval: external.initial_interval.try_into_or_none(),
            backoff_coefficient: external.backoff_coefficient,
            maximum_interval: external.maximum_interval.try_into_or_none(),
            maximum_attempts: external.maximum_attempts,
            non_retryable_error_types: external.non_retryable_error_types,
        }
    }
}

impl Into<temporal_api::common::v1::RetryPolicy> for SdkWorkflowRetryPolicy {
    fn into(self) -> temporal_api::common::v1::RetryPolicy {
        temporal_api::common::v1::RetryPolicy {
            initial_interval: self.initial_interval.try_into_or_none(),
            backoff_coefficient: self.backoff_coefficient,
            maximum_interval: self.maximum_interval.try_into_or_none(),
            maximum_attempts: self.maximum_attempts,
            non_retryable_error_types: self.non_retryable_error_types,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowNamespacedExecution"]
pub struct SdkWorkflowNamespacedExecution {
    pub namespace: String,
    pub workflow_id: String,
    pub run_id: String,
}

impl From<temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution>
    for SdkWorkflowNamespacedExecution
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution,
    ) -> Self {
        Self {
            namespace: external.namespace,
            workflow_id: external.workflow_id,
            run_id: external.run_id,
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution> for SdkWorkflowNamespacedExecution {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution {
        temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution {
            namespace: self.namespace,
            workflow_id: self.workflow_id,
            run_id: self.run_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationPayload"]
pub struct SdkActivationPayload {
    pub metadata: HashMap<String, Vec<u8>>,
    pub data: Vec<u8>,
    pub external_payloads: Vec<SdkActivationExternalPayloadDetails>,
}

impl From<temporal_api::common::v1::Payload> for SdkActivationPayload {
    fn from(external: temporal_api::common::v1::Payload) -> Self {
        Self {
            metadata: external.metadata,
            data: external.data,
            external_payloads: external
                .external_payloads
                .iter()
                .map(|val| (*val).into())
                .collect(),
        }
    }
}

impl From<&temporal_api::common::v1::Payload> for SdkActivationPayload {
    fn from(external: &temporal_api::common::v1::Payload) -> Self {
        Self {
            metadata: external.metadata.clone(),
            data: external.data.clone(),
            external_payloads: external
                .external_payloads
                .iter()
                .map(|val| (*val).into())
                .collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Payload> for SdkActivationPayload {
    fn into(self) -> temporal_api::common::v1::Payload {
        temporal_api::common::v1::Payload {
            metadata: self.metadata.clone(),
            data: self.data.clone(),
            external_payloads: self
                .external_payloads
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Payload> for &SdkActivationPayload {
    fn into(self) -> temporal_api::common::v1::Payload {
        temporal_api::common::v1::Payload {
            metadata: self.metadata.clone(),
            data: self.data.clone(),
            external_payloads: self
                .external_payloads
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationPayloads"]
pub struct SdkActivationPayloads {
    pub payloads: Vec<SdkActivationPayload>,
}

impl From<temporal_api::common::v1::Payloads> for SdkActivationPayloads {
    fn from(external: temporal_api::common::v1::Payloads) -> Self {
        Self {
            payloads: external.payloads.iter().map(|val| val.into()).collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Payloads> for SdkActivationPayloads {
    fn into(self) -> temporal_api::common::v1::Payloads {
        temporal_api::common::v1::Payloads {
            payloads: self.payloads.iter().map(|val| val.clone().into()).collect(),
        }
    }
}


impl Into<temporal_api::common::v1::Payloads> for &SdkActivationPayloads {
    fn into(self) -> temporal_api::common::v1::Payloads {
        temporal_api::common::v1::Payloads {
            payloads: self.payloads.iter().map(|val| val.clone().into()).collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivationExternalPayloadDetails"]
pub struct SdkActivationExternalPayloadDetails {
    pub size_bytes: i64,
}

impl From<temporal_api::common::v1::payload::ExternalPayloadDetails>
    for SdkActivationExternalPayloadDetails
{
    fn from(external: temporal_api::common::v1::payload::ExternalPayloadDetails) -> Self {
        Self {
            size_bytes: external.size_bytes,
        }
    }
}

impl Into<temporal_api::common::v1::payload::ExternalPayloadDetails> for SdkActivationExternalPayloadDetails {
    fn into(self) -> temporal_api::common::v1::payload::ExternalPayloadDetails {
        temporal_api::common::v1::payload::ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

impl Into<temporal_api::common::v1::payload::ExternalPayloadDetails> for &SdkActivationExternalPayloadDetails {
    fn into(self) -> temporal_api::common::v1::payload::ExternalPayloadDetails {
        temporal_api::common::v1::payload::ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowFailure"]
pub struct SdkWorkflowFailure {
    pub message: String,
    pub source: String,
    pub stack_trace: String,
    pub encoded_attributes: Option<SdkActivationPayload>,
    pub cause: Option<Box<SdkWorkflowFailure>>,
    pub failure_info: Option<SdkWorkflowFailureInfo>,
}

impl From<temporal_api::failure::v1::Failure> for SdkWorkflowFailure {
    fn from(external: temporal_api::failure::v1::Failure) -> Self {
        Self {
            message: external.message,
            source: external.source,
            stack_trace: external.stack_trace,
            encoded_attributes: external.encoded_attributes.try_into_or_none(),
            cause: match external.cause {
                Some(boxed) => Some(Box::new((*boxed).into())),
                None => None,
            },
            failure_info: external.failure_info.try_into_or_none(),
        }
    }
}

impl Into<temporal_api::failure::v1::Failure> for SdkWorkflowFailure {
    fn into(self) -> temporal_api::failure::v1::Failure {
        temporal_api::failure::v1::Failure {
            message: self.message,
            source: self.source,
            stack_trace: self.stack_trace,
            encoded_attributes: self.encoded_attributes.try_into_or_none(),
            cause: match self.cause {
                Some(boxed) => Some(Box::new((*boxed).into())),
                None => None,
            },
            failure_info: self.failure_info.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowFailureInfo"]
pub struct SdkWorkflowFailureInfo {
    pub application: Option<SdkWorkflowApplicationFailureInfo>,
    pub timeout: Option<SdkWorkflowTimeoutFailureInfo>,
    pub canceled: Option<SdkWorkflowCanceledFailureInfo>,
    pub terminated: Option<SdkWorkflowTerminatedFailureInfo>,
    pub server: Option<SdkWorkflowServerFailureInfo>,
    pub reset_workflow: Option<SdkWorkflowResetFailureInfo>,
    pub activity: Option<SdkWorkflowActivityFailureInfo>,
    pub child_execution: Option<SdkWorkflowChildExecutionFailureInfo>,
    pub nexus_operation: Option<SdkWorkflowNexusOperationFailureInfo>,
    pub nexus_handler: Option<SdkWorkflowNexusHandlerFailureInfo>,
}

impl From<FailureInfo> for SdkWorkflowFailureInfo {
    fn from(external: FailureInfo) -> Self {
        match external {
            FailureInfo::ApplicationFailureInfo(info) => Self {
                application: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::TimeoutFailureInfo(info) => Self {
                timeout: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::CanceledFailureInfo(info) => Self {
                canceled: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::TerminatedFailureInfo(info) => Self {
                terminated: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::ServerFailureInfo(info) => Self {
                server: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::ResetWorkflowFailureInfo(info) => Self {
                reset_workflow: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::ActivityFailureInfo(info) => Self {
                activity: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::ChildWorkflowExecutionFailureInfo(info) => Self {
                child_execution: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::NexusOperationExecutionFailureInfo(info) => Self {
                nexus_operation: Some(info.into()),
                ..Self::default()
            },
            FailureInfo::NexusHandlerFailureInfo(info) => Self {
                nexus_handler: Some(info.into()),
                ..Self::default()
            },
        }
    }
}

impl Into<FailureInfo> for SdkWorkflowFailureInfo {
    fn into(self) -> FailureInfo {
        match self {
            Self{application: Some(failure), ..} => FailureInfo::ApplicationFailureInfo(failure.into()),
            Self{timeout: Some(failure), ..} => FailureInfo::TimeoutFailureInfo(failure.into()),
            Self{canceled: Some(failure), ..} => FailureInfo::CanceledFailureInfo(failure.into()),
            Self{terminated: Some(failure), ..} => FailureInfo::TerminatedFailureInfo(failure.into()),
            Self{server: Some(failure), ..} => FailureInfo::ServerFailureInfo(failure.into()),
            Self{reset_workflow: Some(failure), ..} => FailureInfo::ResetWorkflowFailureInfo(failure.into()),
            Self{activity: Some(failure), ..} => FailureInfo::ActivityFailureInfo(failure.into()),
            Self{child_execution: Some(failure), ..} => FailureInfo::ChildWorkflowExecutionFailureInfo(failure.into()),
            Self{nexus_operation: Some(failure), ..} => FailureInfo::NexusOperationExecutionFailureInfo(failure.into()),
            Self{nexus_handler: Some(failure), ..} => FailureInfo::NexusHandlerFailureInfo(failure.into()),
            _ => panic!("WorkflowFailureInfo must have a value...")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowApplicationFailureInfo"]
pub struct SdkWorkflowApplicationFailureInfo {
    pub failure_type: String,
    pub non_retryable: bool,
    pub details: Option<SdkActivationPayloads>,
    pub next_retry_delay: Option<SdkDuration>,
    pub category: i32,
}

impl From<temporal_api::failure::v1::ApplicationFailureInfo> for SdkWorkflowApplicationFailureInfo {
    fn from(external: temporal_api::failure::v1::ApplicationFailureInfo) -> Self {
        Self {
            failure_type: external.r#type,
            non_retryable: external.non_retryable,
            details: external.details.try_into_or_none(),
            next_retry_delay: external.next_retry_delay.try_into_or_none(),
            category: external.category,
        }
    }
}

impl Into<temporal_api::failure::v1::ApplicationFailureInfo> for SdkWorkflowApplicationFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ApplicationFailureInfo {
        temporal_api::failure::v1::ApplicationFailureInfo {
            r#type: self.failure_type,
            non_retryable: self.non_retryable,
            details: self.details.try_into_or_none(),
            next_retry_delay: self.next_retry_delay.try_into_or_none(),
            category: self.category,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowTimeoutFailureInfo"]
pub struct SdkWorkflowTimeoutFailureInfo {
    pub timeout_type: i32,
    pub last_heartbeat_details: Option<SdkActivationPayloads>,
}

impl From<temporal_api::failure::v1::TimeoutFailureInfo> for SdkWorkflowTimeoutFailureInfo {
    fn from(external: temporal_api::failure::v1::TimeoutFailureInfo) -> Self {
        Self {
            timeout_type: external.timeout_type,
            last_heartbeat_details: external.last_heartbeat_details.try_into_or_none(),
        }
    }
}

impl Into<temporal_api::failure::v1::TimeoutFailureInfo> for SdkWorkflowTimeoutFailureInfo {
    fn into(self) -> temporal_api::failure::v1::TimeoutFailureInfo {
        temporal_api::failure::v1::TimeoutFailureInfo {
            timeout_type: self.timeout_type,
            last_heartbeat_details: self.last_heartbeat_details.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCanceledFailureInfo"]
pub struct SdkWorkflowCanceledFailureInfo {
    pub details: Option<SdkActivationPayloads>,
    pub identity: String,
}

impl From<temporal_api::failure::v1::CanceledFailureInfo> for SdkWorkflowCanceledFailureInfo {
    fn from(external: temporal_api::failure::v1::CanceledFailureInfo) -> Self {
        Self {
            details: external.details.try_into_or_none(),
            identity: external.identity,
        }
    }
}

impl Into<temporal_api::failure::v1::CanceledFailureInfo> for SdkWorkflowCanceledFailureInfo {
    fn into(self) -> temporal_api::failure::v1::CanceledFailureInfo {
        temporal_api::failure::v1::CanceledFailureInfo {
            details: self.details.try_into_or_none(),
            identity: self.identity,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowTerminatedFailureInfo"]
pub struct SdkWorkflowTerminatedFailureInfo {
    pub identity: String,
}

impl From<temporal_api::failure::v1::TerminatedFailureInfo> for SdkWorkflowTerminatedFailureInfo {
    fn from(external: temporal_api::failure::v1::TerminatedFailureInfo) -> Self {
        Self {
            identity: external.identity,
        }
    }
}

impl Into<temporal_api::failure::v1::TerminatedFailureInfo> for SdkWorkflowTerminatedFailureInfo {
    fn into(self) -> temporal_api::failure::v1::TerminatedFailureInfo {
        temporal_api::failure::v1::TerminatedFailureInfo {
            identity: self.identity,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowServerFailureInfo"]
pub struct SdkWorkflowServerFailureInfo {
    pub non_retryable: bool,
}

impl From<temporal_api::failure::v1::ServerFailureInfo> for SdkWorkflowServerFailureInfo {
    fn from(external: temporal_api::failure::v1::ServerFailureInfo) -> Self {
        Self {
            non_retryable: external.non_retryable,
        }
    }
}

impl Into<temporal_api::failure::v1::ServerFailureInfo> for SdkWorkflowServerFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ServerFailureInfo {
        temporal_api::failure::v1::ServerFailureInfo {
            non_retryable: self.non_retryable,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowResetFailureInfo"]
pub struct SdkWorkflowResetFailureInfo {
    pub last_heartbeat_details: Option<SdkActivationPayloads>,
}

impl From<temporal_api::failure::v1::ResetWorkflowFailureInfo> for SdkWorkflowResetFailureInfo {
    fn from(external: temporal_api::failure::v1::ResetWorkflowFailureInfo) -> Self {
        Self {
            last_heartbeat_details: external.last_heartbeat_details.try_into_or_none(),
        }
    }
}

impl Into<temporal_api::failure::v1::ResetWorkflowFailureInfo> for SdkWorkflowResetFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ResetWorkflowFailureInfo {
        temporal_api::failure::v1::ResetWorkflowFailureInfo {
            last_heartbeat_details: self.last_heartbeat_details.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivityFailureInfo"]
pub struct SdkWorkflowActivityFailureInfo {
    pub scheduled_event_id: i64,
    pub started_event_id: i64,
    pub identity: String,
    pub activity_type: Option<SdkWorkflowActivityType>,
    pub activity_id: String,
    pub retry_state: i32,
}

impl From<temporal_api::failure::v1::ActivityFailureInfo> for SdkWorkflowActivityFailureInfo {
    fn from(external: temporal_api::failure::v1::ActivityFailureInfo) -> Self {
        Self {
            scheduled_event_id: external.scheduled_event_id,
            started_event_id: external.started_event_id,
            identity: external.identity,
            activity_type: external.activity_type.try_into_or_none(),
            activity_id: external.activity_id,
            retry_state: external.retry_state,
        }
    }
}

impl Into<temporal_api::failure::v1::ActivityFailureInfo> for SdkWorkflowActivityFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ActivityFailureInfo {
        temporal_api::failure::v1::ActivityFailureInfo {
            scheduled_event_id: self.scheduled_event_id,
            started_event_id: self.started_event_id,
            identity: self.identity,
            activity_type: self.activity_type.try_into_or_none(),
            activity_id: self.activity_id,
            retry_state: self.retry_state,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivityType"]
pub struct SdkWorkflowActivityType {
    pub name: String,
}

impl From<temporal_api::common::v1::ActivityType> for SdkWorkflowActivityType {
    fn from(external: temporal_api::common::v1::ActivityType) -> Self {
        Self {
            name: external.name,
        }
    }
}

impl Into<temporal_api::common::v1::ActivityType> for SdkWorkflowActivityType {
    fn into(self) -> temporal_api::common::v1::ActivityType {
        temporal_api::common::v1::ActivityType {
            name: self.name,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowChildExecutionFailureInfo"]
pub struct SdkWorkflowChildExecutionFailureInfo {
    pub namespace: String,
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub workflow_type: Option<SdkWorkflowType>,
    pub initiated_event_id: i64,
    pub started_event_id: i64,
    pub retry_state: i32,
}

impl From<temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo>
    for SdkWorkflowChildExecutionFailureInfo
{
    fn from(external: temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo) -> Self {
        Self {
            namespace: external.namespace,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            workflow_type: external.workflow_type.try_into_or_none(),
            initiated_event_id: external.initiated_event_id,
            started_event_id: external.started_event_id,
            retry_state: external.retry_state,
        }
    }
}

impl Into<temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo> for SdkWorkflowChildExecutionFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo {
        temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo {
            namespace: self.namespace,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            workflow_type: self.workflow_type.try_into_or_none(),
            initiated_event_id: self.initiated_event_id,
            started_event_id: self.started_event_id,
            retry_state: self.retry_state,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowExecution"]
pub struct SdkWorkflowExecution {
    pub workflow_id: String,
    pub run_id: String,
}

impl From<temporal_api::common::v1::WorkflowExecution> for SdkWorkflowExecution {
    fn from(external: temporal_api::common::v1::WorkflowExecution) -> Self {
        Self {
            workflow_id: external.workflow_id,
            run_id: external.run_id,
        }
    }
}

impl Into<temporal_api::common::v1::WorkflowExecution> for SdkWorkflowExecution {
    fn into(self) -> temporal_api::common::v1::WorkflowExecution {
        temporal_api::common::v1::WorkflowExecution {
            workflow_id: self.workflow_id,
            run_id: self.run_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowType"]
pub struct SdkWorkflowType {
    pub name: String,
}

impl From<temporal_api::common::v1::WorkflowType> for SdkWorkflowType {
    fn from(external: temporal_api::common::v1::WorkflowType) -> Self {
        Self {
            name: external.name,
        }
    }
}

impl Into<temporal_api::common::v1::WorkflowType> for SdkWorkflowType {
    fn into(self) -> temporal_api::common::v1::WorkflowType {
        temporal_api::common::v1::WorkflowType {
            name: self.name,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowNexusOperationFailureInfo"]
pub struct SdkWorkflowNexusOperationFailureInfo {
    pub scheduled_event_id: i64,
    pub endpoint: String,
    pub service: String,
    pub operation: String,
    pub operation_id: String,
    pub operation_token: String,
}

impl From<temporal_api::failure::v1::NexusOperationFailureInfo>
    for SdkWorkflowNexusOperationFailureInfo
{
    fn from(external: temporal_api::failure::v1::NexusOperationFailureInfo) -> Self {
        Self {
            scheduled_event_id: external.scheduled_event_id,
            endpoint: external.endpoint,
            service: external.service,
            operation: external.operation,
            #[allow(deprecated)]
            operation_id: external.operation_id,
            operation_token: external.operation_token,
        }
    }
}

impl Into<temporal_api::failure::v1::NexusOperationFailureInfo> for SdkWorkflowNexusOperationFailureInfo {
    fn into(self) -> temporal_api::failure::v1::NexusOperationFailureInfo {
        temporal_api::failure::v1::NexusOperationFailureInfo {
            scheduled_event_id: self.scheduled_event_id,
            endpoint: self.endpoint,
            service: self.service,
            operation: self.operation,
            #[allow(deprecated)]
            operation_id: self.operation_id,
            operation_token: self.operation_token,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowNexusHandlerFailureInfo"]
pub struct SdkWorkflowNexusHandlerFailureInfo {
    pub failure_type: String,
    pub retry_behavior: i32,
}

impl From<temporal_api::failure::v1::NexusHandlerFailureInfo> for SdkWorkflowNexusHandlerFailureInfo {
    fn from(external: temporal_api::failure::v1::NexusHandlerFailureInfo) -> Self {
        Self {
            failure_type: external.r#type,
            retry_behavior: external.retry_behavior,
        }
    }
}

impl Into<temporal_api::failure::v1::NexusHandlerFailureInfo> for SdkWorkflowNexusHandlerFailureInfo {
    fn into(self) -> temporal_api::failure::v1::NexusHandlerFailureInfo {
        temporal_api::failure::v1::NexusHandlerFailureInfo {
            r#type: self.failure_type,
            retry_behavior: self.retry_behavior,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationCompletion"]
pub struct SdkWorkflowActivationCompletion {
    pub run_id: String,
    pub status: Option<SdkWorkflowActivationCompletionStatus>,
}

impl From<workflow_completion::WorkflowActivationCompletion> for SdkWorkflowActivationCompletion {
    fn from(external: workflow_completion::WorkflowActivationCompletion) -> Self {
        Self {
            run_id: external.run_id,
            status: external.status.try_into_or_none(),
        }
    }
}

impl Into<workflow_completion::WorkflowActivationCompletion> for SdkWorkflowActivationCompletion {
    fn into(self) -> workflow_completion::WorkflowActivationCompletion {
        workflow_completion::WorkflowActivationCompletion {
            run_id: self.run_id,
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationCompletionStatus"]
pub struct SdkWorkflowActivationCompletionStatus {
    pub successful: Option<SdkWorkflowActivationCompletionSuccessStatus>,
    pub failed: Option<SdkWorkflowActivationCompletionFailureStatus>,
}

impl From<WorkflowActivationCompletionStatus> for SdkWorkflowActivationCompletionStatus {
    fn from(external: WorkflowActivationCompletionStatus) -> Self {
        match external {
            WorkflowActivationCompletionStatus::Successful(status) => {
                Self{successful: Some(status.into()), ..Self::default()}
            }

            WorkflowActivationCompletionStatus::Failed(status) => {
                Self{failed: Some(status.into()), ..Self::default()}
            }
        }
    }
}

impl Into<WorkflowActivationCompletionStatus> for SdkWorkflowActivationCompletionStatus {
    fn into(self) -> WorkflowActivationCompletionStatus {
        match self {
            Self{successful: Some(status), ..} => WorkflowActivationCompletionStatus::Successful(status.into()),
            Self{failed: Some(status), ..} => WorkflowActivationCompletionStatus::Failed(status.into()),
            _ => panic!("WorkflowActivationCompletionStatus must have a value...")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationCompletionSuccessStatus"]
pub struct SdkWorkflowActivationCompletionSuccessStatus {
    pub commands: Vec<SdkWorkflowCommand>,
    pub used_internal_flags: Vec<u32>,
    pub versioning_behavior: i32,
}

impl From<workflow_completion::Success> for SdkWorkflowActivationCompletionSuccessStatus {
    fn from(external: workflow_completion::Success) -> Self {
        Self {
            commands: external.commands.iter().map(|val| val.clone().into()).collect(),
            used_internal_flags: external.used_internal_flags,
            versioning_behavior: external.versioning_behavior,
        }
    }
}

impl Into<workflow_completion::Success> for SdkWorkflowActivationCompletionSuccessStatus {
    fn into(self) -> workflow_completion::Success {
        workflow_completion::Success {
            commands: self.commands.iter().map(|val| val.clone().into()).collect(),
            used_internal_flags: self.used_internal_flags,
            versioning_behavior: self.versioning_behavior,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus"]
pub struct SdkWorkflowActivationCompletionFailureStatus {
    pub failure: Option<SdkWorkflowFailure>,
    pub force_cause: i32
}

impl From<workflow_completion::Failure> for SdkWorkflowActivationCompletionFailureStatus {
    fn from(external: workflow_completion::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
            force_cause: external.force_cause,
        }
    }
}

impl Into<workflow_completion::Failure> for SdkWorkflowActivationCompletionFailureStatus {
    fn into(self) -> workflow_completion::Failure {
        workflow_completion::Failure {
            failure: self.failure.try_into_or_none(),
            force_cause: self.force_cause,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommand"]
pub struct SdkWorkflowCommand {
    pub user_metadata: Option<SdkUserMetadata>,
    pub variant: Option<SdkWorkflowCommandVariant>
}

impl From<WorkflowCommand> for SdkWorkflowCommand {
    fn from(external: WorkflowCommand) -> Self {
        Self {
            user_metadata: external.user_metadata.try_into_or_none(),
            variant: external.variant.try_into_or_none()
        }
    }
}

impl Into<WorkflowCommand> for SdkWorkflowCommand {
    fn into(self) -> WorkflowCommand {
        WorkflowCommand {
            user_metadata: self.user_metadata.try_into_or_none(),
            variant: self.variant.try_into_or_none()
        }
    }
}

impl Into<WorkflowCommand> for &SdkWorkflowCommand {
    fn into(self) -> WorkflowCommand {

        WorkflowCommand {
            user_metadata: self.user_metadata.clone().try_into_or_none(),
            variant: self.variant.clone().try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.UserMetadata"]
pub struct SdkUserMetadata {
    pub summary: Option<SdkActivationPayload>,
    pub details: Option<SdkActivationPayload>,
}

impl From<UserMetadata> for SdkUserMetadata {
    fn from(external: UserMetadata) -> Self {
        Self {
            summary: external.summary.try_into_or_none(),
            details: external.details.try_into_or_none()
        }
    }
}

impl Into<UserMetadata> for SdkUserMetadata {
    fn into(self) -> UserMetadata {
        UserMetadata {
            summary: self.summary.try_into_or_none(),
            details: self.details.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandVariant"]
pub struct SdkWorkflowCommandVariant {
    pub start_timer: Option<SdkWorkflowCommandStartTimer>,
    pub schedule_activity: Option<SdkWorkflowCommandScheduleActivity>,
    pub respond_to_query: Option<SdkWorkflowCommandQueryResult>,
    pub request_cancel_activity: Option<SdkWorkflowCommandRequestCancelActivity>,
    pub cancel_timer: Option<SdkWorkflowCommandCancelTimer>,
    pub complete_workflow_execution: Option<SdkWorkflowCommandCompleteWorkflowExecution>,
    pub fail_workflow_execution: Option<SdkWorkflowCommandFailWorkflowExecution>,
    pub continue_as_new_workflow_execution: Option<SdkWorkflowCommandContinueAsNewWorkflowExecution>,
    pub cancel_workflow_execution: Option<SdkWorkflowCommandCancelWorkflowExecution>,
    pub set_patch_marker: Option<SdkWorkflowCommandSetPatchMarker>,
    pub start_child_workflow_execution: Option<SdkWorkflowCommandStartChildWorkflowExecution>,
    pub cancel_child_workflow_execution: Option<SdkWorkflowCommandCancelChildWorkflowExecution>,
    pub request_cancel_external_workflow_execution: Option<SdkWorkflowCommandRequestCancelExternalWorkflowExecution>,
    pub signal_external_workflow_execution: Option<SdkWorkflowCommandSignalExternalWorkflowExecution>,
    pub cancel_signal_workflow: Option<SdkWorkflowCommandCancelSignalWorkflow>,
    pub schedule_local_activity: Option<SdkWorkflowCommandScheduleLocalActivity>,
    pub request_cancel_local_activity: Option<SdkWorkflowCommandRequestCancelLocalActivity>,
    pub upsert_workflow_search_attributes: Option<SdkWorkflowCommandUpsertWorkflowSearchAttributes>,
    pub modify_workflow_properties: Option<SdkWorkflowCommandModifyWorkflowProperties>,
    pub update_response: Option<SdkWorkflowCommandUpdateResponse>,
    pub schedule_nexus_operation: Option<SdkWorkflowCommandScheduleNexusOperation>,
    pub request_cancel_nexus_operation: Option<SdkWorkflowCommandRequestCancelNexusOperation>,
}

impl From<WorkflowCommandVariant> for SdkWorkflowCommandVariant {
    fn from(external: WorkflowCommandVariant) -> Self {
        match external {
            WorkflowCommandVariant::StartTimer(variant) => {
                Self{start_timer: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::ScheduleActivity(variant) => {
                Self{schedule_activity: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::RespondToQuery(variant) => {
                Self{respond_to_query: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::RequestCancelActivity(variant) => {
                Self{request_cancel_activity: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::CancelTimer(variant) => {
                Self{cancel_timer: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::CompleteWorkflowExecution(variant) => {
                Self{complete_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::FailWorkflowExecution(variant) => {
                Self{fail_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::ContinueAsNewWorkflowExecution(variant) => {
                Self{continue_as_new_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::CancelWorkflowExecution(variant) => {
                Self{cancel_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::SetPatchMarker(variant) => {
                Self{set_patch_marker: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::StartChildWorkflowExecution(variant) => {
                Self{start_child_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::CancelChildWorkflowExecution(variant) => {
                Self{cancel_child_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::RequestCancelExternalWorkflowExecution(variant) => {
                Self{request_cancel_external_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::SignalExternalWorkflowExecution(variant) => {
                Self{signal_external_workflow_execution: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::CancelSignalWorkflow(variant) => {
                Self{cancel_signal_workflow: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::ScheduleLocalActivity(variant) => {
                Self{schedule_local_activity: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::RequestCancelLocalActivity(variant) => {
                Self{request_cancel_local_activity: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::UpsertWorkflowSearchAttributes(variant) => {
                Self{upsert_workflow_search_attributes: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::ModifyWorkflowProperties(variant) => {
                Self{modify_workflow_properties: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::UpdateResponse(variant) => {
                Self{update_response: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::ScheduleNexusOperation(variant) => {
                Self{schedule_nexus_operation: Some(variant.into()), ..Self::default()}
            }
            WorkflowCommandVariant::RequestCancelNexusOperation(variant) => {
                Self{request_cancel_nexus_operation: Some(variant.into()), ..Self::default()}
            }
        }
    }
}

impl Into<WorkflowCommandVariant> for SdkWorkflowCommandVariant {
    fn into(self) -> WorkflowCommandVariant {
        match self {
            Self{start_timer: Some(cmd), ..} => WorkflowCommandVariant::StartTimer(cmd.into()),
            Self{schedule_activity: Some(cmd), ..} => WorkflowCommandVariant::ScheduleActivity(cmd.into()),
            Self{respond_to_query: Some(cmd), ..} => WorkflowCommandVariant::RespondToQuery(cmd.into()),
            Self{request_cancel_activity: Some(cmd), ..} => WorkflowCommandVariant::RequestCancelActivity(cmd.into()),
            Self{cancel_timer: Some(cmd), ..} => WorkflowCommandVariant::CancelTimer(cmd.into()),
            Self{complete_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::CompleteWorkflowExecution(cmd.into()),
            Self{fail_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::FailWorkflowExecution(cmd.into()),
            Self{continue_as_new_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::ContinueAsNewWorkflowExecution(cmd.into()),
            Self{cancel_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::CancelWorkflowExecution(cmd.into()),
            Self{set_patch_marker: Some(cmd), ..} => WorkflowCommandVariant::SetPatchMarker(cmd.into()),
            Self{start_child_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::StartChildWorkflowExecution(cmd.into()),
            Self{cancel_child_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::CancelChildWorkflowExecution(cmd.into()),
            Self{request_cancel_external_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::RequestCancelExternalWorkflowExecution(cmd.into()),
            Self{signal_external_workflow_execution: Some(cmd), ..} => WorkflowCommandVariant::SignalExternalWorkflowExecution(cmd.into()),
            Self{cancel_signal_workflow: Some(cmd), ..} => WorkflowCommandVariant::CancelSignalWorkflow(cmd.into()),
            Self{schedule_local_activity: Some(cmd), ..} => WorkflowCommandVariant::ScheduleLocalActivity(cmd.into()),
            Self{request_cancel_local_activity: Some(cmd), ..} => WorkflowCommandVariant::RequestCancelLocalActivity(cmd.into()),
            Self{upsert_workflow_search_attributes: Some(cmd), ..} => WorkflowCommandVariant::UpsertWorkflowSearchAttributes(cmd.into()),
            Self{modify_workflow_properties: Some(cmd), ..} => WorkflowCommandVariant::ModifyWorkflowProperties(cmd.into()),
            Self{update_response: Some(cmd), ..} => WorkflowCommandVariant::UpdateResponse(cmd.into()),
            Self{schedule_nexus_operation: Some(cmd), ..} => WorkflowCommandVariant::ScheduleNexusOperation(cmd.into()),
            Self{request_cancel_nexus_operation: Some(cmd), ..} => WorkflowCommandVariant::RequestCancelNexusOperation(cmd.into()),
            _ => panic!("WorkflowCommandVariant must have a value...")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandStartTimer"]
pub struct SdkWorkflowCommandStartTimer {
    pub seq: u32,
    pub start_to_fire_timeout: Option<SdkDuration>
}

impl From<workflow_commands::StartTimer> for SdkWorkflowCommandStartTimer {
    fn from(external: workflow_commands::StartTimer) -> Self {
        Self {
            seq: external.seq,
            start_to_fire_timeout: external.start_to_fire_timeout.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::StartTimer> for SdkWorkflowCommandStartTimer {
    fn into(self) -> workflow_commands::StartTimer {
        workflow_commands::StartTimer {
            seq: self.seq,
            start_to_fire_timeout: self.start_to_fire_timeout.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandScheduleActivity"]
pub struct SdkWorkflowCommandScheduleActivity {
    pub seq: u32,
    pub activity_id: String,
    pub activity_type: String,
    pub task_queue: String,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub arguments: Vec<SdkActivationPayload>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub heartbeat_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub cancellation_type: i32,
    pub do_not_eagerly_execute: bool,
    pub versioning_intent: i32,
    pub priority: Option<SdkWorkflowPriority>
}

impl From<workflow_commands::ScheduleActivity> for SdkWorkflowCommandScheduleActivity {
    fn from(external: workflow_commands::ScheduleActivity) -> Self {
        Self {
            seq: external.seq,
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            task_queue: external.task_queue,
            headers: external.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            arguments: external.arguments.iter().map(|val| val.clone().into()).collect(),
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: external.heartbeat_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            cancellation_type: external.cancellation_type,
            do_not_eagerly_execute: external.do_not_eagerly_execute,
            versioning_intent: external.versioning_intent,
            priority: external.priority.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::ScheduleActivity> for SdkWorkflowCommandScheduleActivity {
    fn into(self) -> workflow_commands::ScheduleActivity {
        workflow_commands::ScheduleActivity {
            seq: self.seq,
            activity_id: self.activity_id,
            activity_type: self.activity_type,
            task_queue: self.task_queue,
            headers: self.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            arguments: self.arguments.iter().map(|val| val.clone().into()).collect(),
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: self.heartbeat_timeout.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            cancellation_type: self.cancellation_type,
            do_not_eagerly_execute: self.do_not_eagerly_execute,
            versioning_intent: self.versioning_intent,
            priority: self.priority.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandQueryResult"]
pub struct SdkWorkflowCommandQueryResult {
    pub query_id: String,
    pub variant: Option<SdkWorkflowCommandQueryResultVariant>
}

impl From<workflow_commands::QueryResult> for SdkWorkflowCommandQueryResult {
    fn from(external: workflow_commands::QueryResult) -> Self {
        Self {
            query_id: external.query_id,
            variant: external.variant.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::QueryResult> for SdkWorkflowCommandQueryResult {
    fn into(self) -> workflow_commands::QueryResult {
        workflow_commands::QueryResult {
            query_id: self.query_id,
            variant: self.variant.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandRequestCancelActivity"]
pub struct SdkWorkflowCommandRequestCancelActivity {
    pub seq: u32,
}

impl From<workflow_commands::RequestCancelActivity> for SdkWorkflowCommandRequestCancelActivity {
    fn from(external: workflow_commands::RequestCancelActivity) -> Self {
        Self {
            seq: external.seq,
        }
    }
}

impl Into<workflow_commands::RequestCancelActivity> for SdkWorkflowCommandRequestCancelActivity {
    fn into(self) -> workflow_commands::RequestCancelActivity {
        workflow_commands::RequestCancelActivity {
            seq: self.seq,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandCancelTimer"]
pub struct SdkWorkflowCommandCancelTimer {
    pub seq: u32,
}

impl From<workflow_commands::CancelTimer> for SdkWorkflowCommandCancelTimer {
    fn from(external: workflow_commands::CancelTimer) -> Self {
        Self {
            seq: external.seq,
        }
    }
}

impl Into<workflow_commands::CancelTimer> for SdkWorkflowCommandCancelTimer {
    fn into(self) -> workflow_commands::CancelTimer {
        workflow_commands::CancelTimer {
            seq: self.seq,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandCompleteWorkflowExecution"]
pub struct SdkWorkflowCommandCompleteWorkflowExecution {
    pub result: Option<SdkActivationPayload>
}

impl From<workflow_commands::CompleteWorkflowExecution> for SdkWorkflowCommandCompleteWorkflowExecution {
    fn from(external: workflow_commands::CompleteWorkflowExecution) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::CompleteWorkflowExecution> for SdkWorkflowCommandCompleteWorkflowExecution {
    fn into(self) -> workflow_commands::CompleteWorkflowExecution {
        workflow_commands::CompleteWorkflowExecution {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandFailWorkflowExecution"]
pub struct SdkWorkflowCommandFailWorkflowExecution {
    pub failure: Option<SdkWorkflowFailure>
}

impl From<workflow_commands::FailWorkflowExecution> for SdkWorkflowCommandFailWorkflowExecution {
    fn from(external: workflow_commands::FailWorkflowExecution) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::FailWorkflowExecution> for SdkWorkflowCommandFailWorkflowExecution {
    fn into(self) -> workflow_commands::FailWorkflowExecution {
        workflow_commands::FailWorkflowExecution {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandContinueAsNewWorkflowExecution"]
pub struct SdkWorkflowCommandContinueAsNewWorkflowExecution {
    pub workflow_type: String,
    pub task_queue: String,
    pub arguments: Vec<SdkActivationPayload>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub memo: HashMap<String, SdkActivationPayload>,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub versioning_intent: i32,
    pub initial_versioning_behavior: i32
}

impl From<workflow_commands::ContinueAsNewWorkflowExecution> for SdkWorkflowCommandContinueAsNewWorkflowExecution {
    fn from(external: workflow_commands::ContinueAsNewWorkflowExecution) -> Self {
        Self {
            workflow_type: external.workflow_type,
            task_queue: external.task_queue,
            arguments: external.arguments.iter().map(|val| val.clone().into()).collect(),
            workflow_run_timeout: external.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: external.workflow_task_timeout.try_into_or_none(),
            memo: external.memo.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            headers: external.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            search_attributes: external.search_attributes.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            versioning_intent: external.versioning_intent,
            initial_versioning_behavior: external.initial_versioning_behavior
        }
    }
}

impl Into<workflow_commands::ContinueAsNewWorkflowExecution> for SdkWorkflowCommandContinueAsNewWorkflowExecution {
    fn into(self) -> workflow_commands::ContinueAsNewWorkflowExecution {
        workflow_commands::ContinueAsNewWorkflowExecution {
            workflow_type: self.workflow_type,
            task_queue: self.task_queue,
            arguments: self.arguments.iter().map(|val| val.clone().into()).collect(),
            workflow_run_timeout: self.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: self.workflow_task_timeout.try_into_or_none(),
            memo: self.memo.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            headers: self.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            search_attributes: self.search_attributes.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            versioning_intent: self.versioning_intent,
            initial_versioning_behavior: self.initial_versioning_behavior
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandCancelWorkflowExecution"]
pub struct SdkWorkflowCommandCancelWorkflowExecution {
}

impl From<workflow_commands::CancelWorkflowExecution> for SdkWorkflowCommandCancelWorkflowExecution {
    fn from(_external: workflow_commands::CancelWorkflowExecution) -> Self {
        Self {}
    }
}

impl Into<workflow_commands::CancelWorkflowExecution> for SdkWorkflowCommandCancelWorkflowExecution {
    fn into(self) -> workflow_commands::CancelWorkflowExecution {
        workflow_commands::CancelWorkflowExecution {}
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandSetPatchMarker"]
pub struct SdkWorkflowCommandSetPatchMarker {
    pub patch_id: String,
    pub deprecated: bool
}

impl From<workflow_commands::SetPatchMarker> for SdkWorkflowCommandSetPatchMarker {
    fn from(external: workflow_commands::SetPatchMarker) -> Self {
        Self {
            patch_id: external.patch_id,
            deprecated: external.deprecated
        }
    }
}

impl Into<workflow_commands::SetPatchMarker> for SdkWorkflowCommandSetPatchMarker {
    fn into(self) -> workflow_commands::SetPatchMarker {
        workflow_commands::SetPatchMarker {
            patch_id: self.patch_id,
            deprecated: self.deprecated
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandStartChildWorkflowExecution"]
pub struct SdkWorkflowCommandStartChildWorkflowExecution {
    pub seq: u32,
    pub namespace: String,
    pub workflow_id: String,
    pub workflow_type: String,
    pub task_queue: String,
    pub input: Vec<SdkActivationPayload>,
    pub workflow_execution_timeout: Option<SdkDuration>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub parent_close_policy: i32,
    pub workflow_id_reuse_policy: i32,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub cron_schedule: String,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub memo: HashMap<String, SdkActivationPayload>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub cancellation_type: i32,
    pub versioning_intent: i32,
    pub priority: Option<SdkWorkflowPriority>
}

impl From<workflow_commands::StartChildWorkflowExecution> for SdkWorkflowCommandStartChildWorkflowExecution {
    fn from(external: workflow_commands::StartChildWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            namespace: external.namespace,
            workflow_id: external.workflow_id,
            workflow_type: external.workflow_type,
            task_queue: external.task_queue,
            input: external.input.iter().map(|val| val.into()).collect(),
            workflow_execution_timeout: external.workflow_execution_timeout.try_into_or_none(),
            workflow_run_timeout: external.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: external.workflow_task_timeout.try_into_or_none(),
            parent_close_policy: external.parent_close_policy,
            workflow_id_reuse_policy: external.workflow_id_reuse_policy,
            retry_policy: external.retry_policy.try_into_or_none(),
            cron_schedule: external.cron_schedule,
            headers: external.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            memo: external.memo.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            search_attributes: external.search_attributes.try_into_or_none(),
            cancellation_type: external.cancellation_type,
            versioning_intent: external.versioning_intent,
            priority: external.priority.try_into_or_none()
        }
    }
}


impl Into<workflow_commands::StartChildWorkflowExecution> for SdkWorkflowCommandStartChildWorkflowExecution {
    fn into(self) -> workflow_commands::StartChildWorkflowExecution {
        workflow_commands::StartChildWorkflowExecution {
            seq: self.seq,
            namespace: self.namespace,
            workflow_id: self.workflow_id,
            workflow_type: self.workflow_type,
            task_queue: self.task_queue,
            input: self.input.iter().map(|val| val.into()).collect(),
            workflow_execution_timeout: self.workflow_execution_timeout.try_into_or_none(),
            workflow_run_timeout: self.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: self.workflow_task_timeout.try_into_or_none(),
            parent_close_policy: self.parent_close_policy,
            workflow_id_reuse_policy: self.workflow_id_reuse_policy,
            retry_policy: self.retry_policy.try_into_or_none(),
            cron_schedule: self.cron_schedule,
            headers: self.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            memo: self.memo.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            search_attributes: self.search_attributes.try_into_or_none(),
            cancellation_type: self.cancellation_type,
            versioning_intent: self.versioning_intent,
            priority: self.priority.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandCancelChildWorkflowExecution"]
pub struct SdkWorkflowCommandCancelChildWorkflowExecution {
    pub child_workflow_seq: u32,
    pub reason: String
}

impl From<workflow_commands::CancelChildWorkflowExecution> for SdkWorkflowCommandCancelChildWorkflowExecution {
    fn from(external: workflow_commands::CancelChildWorkflowExecution) -> Self {
        Self {
            child_workflow_seq: external.child_workflow_seq,
            reason: external.reason
        }
    }
}

impl Into<workflow_commands::CancelChildWorkflowExecution> for SdkWorkflowCommandCancelChildWorkflowExecution {
    fn into(self) -> workflow_commands::CancelChildWorkflowExecution {
        workflow_commands::CancelChildWorkflowExecution {
            child_workflow_seq: self.child_workflow_seq,
            reason: self.reason
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandRequestCancelExternalWorkflowExecution"]
pub struct SdkWorkflowCommandRequestCancelExternalWorkflowExecution {
    pub seq: u32,
    pub workflow_execution: Option<SdkWorkflowNamespacedExecution>,
    pub reason: String
}

impl From<workflow_commands::RequestCancelExternalWorkflowExecution> for SdkWorkflowCommandRequestCancelExternalWorkflowExecution {
    fn from(external: workflow_commands::RequestCancelExternalWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            reason: external.reason
        }
    }
}

impl Into<workflow_commands::RequestCancelExternalWorkflowExecution> for SdkWorkflowCommandRequestCancelExternalWorkflowExecution {
    fn into(self) -> workflow_commands::RequestCancelExternalWorkflowExecution {
        workflow_commands::RequestCancelExternalWorkflowExecution {
            seq: self.seq,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            reason: self.reason
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandSignalExternalWorkflowExecution"]
pub struct SdkWorkflowCommandSignalExternalWorkflowExecution {
    pub seq: u32,
    pub signal_name: String,
    pub args: Vec<SdkActivationPayload>,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub target: Option<SdkWorkflowCommandSignalExternalExecutionTarget>
}

impl From<workflow_commands::SignalExternalWorkflowExecution> for SdkWorkflowCommandSignalExternalWorkflowExecution {
    fn from(external: workflow_commands::SignalExternalWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            signal_name: external.signal_name,
            args: external.args.iter().map(|val| val.clone().into()).collect(),
            headers: external.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            target: external.target.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::SignalExternalWorkflowExecution> for SdkWorkflowCommandSignalExternalWorkflowExecution {
    fn into(self) -> workflow_commands::SignalExternalWorkflowExecution {
        workflow_commands::SignalExternalWorkflowExecution {
            seq: self.seq,
            signal_name: self.signal_name,
            args: self.args.iter().map(|val| val.clone().into()).collect(),
            headers: self.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            target: self.target.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandCancelSignalWorkflow"]
pub struct SdkWorkflowCommandCancelSignalWorkflow {
    pub seq: u32,
}

impl From<workflow_commands::CancelSignalWorkflow> for SdkWorkflowCommandCancelSignalWorkflow {
    fn from(external: workflow_commands::CancelSignalWorkflow) -> Self {
        Self {
            seq: external.seq
        }
    }
}

impl Into<workflow_commands::CancelSignalWorkflow> for SdkWorkflowCommandCancelSignalWorkflow {
    fn into(self) -> workflow_commands::CancelSignalWorkflow {
        workflow_commands::CancelSignalWorkflow {
            seq: self.seq
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandScheduleLocalActivity"]
pub struct SdkWorkflowCommandScheduleLocalActivity {
    pub seq: u32,
    pub activity_id: String,
    pub activity_type: String,
    pub attempt: u32,
    pub original_schedule_time: Option<SdkTimestamp>,
    pub headers: HashMap<String, SdkActivationPayload>,
    pub arguments: Vec<SdkActivationPayload>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub local_retry_threshold: Option<SdkDuration>,
    pub cancellation_type: i32,
}

impl From<workflow_commands::ScheduleLocalActivity> for SdkWorkflowCommandScheduleLocalActivity {
    fn from(external: workflow_commands::ScheduleLocalActivity) -> Self {
        Self {
            seq: external.seq,
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            attempt: external.attempt,
            original_schedule_time: external.original_schedule_time.try_into_or_none(),
            headers: external.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            arguments: external.arguments.iter().map(|val| val.into()).collect(),
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            local_retry_threshold: external.local_retry_threshold.try_into_or_none(),
            cancellation_type: external.cancellation_type,
        }
    }
}

impl Into<workflow_commands::ScheduleLocalActivity> for SdkWorkflowCommandScheduleLocalActivity {
    fn into(self) -> workflow_commands::ScheduleLocalActivity {
        workflow_commands::ScheduleLocalActivity {
            seq: self.seq,
            activity_id: self.activity_id,
            activity_type: self.activity_type,
            attempt: self.attempt,
            original_schedule_time: self.original_schedule_time.try_into_or_none(),
            headers: self.headers.iter().map(|(k, v)| (k.clone(), v.clone().into())).collect(),
            arguments: self.arguments.iter().map(|val| val.into()).collect(),
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            local_retry_threshold: self.local_retry_threshold.try_into_or_none(),
            cancellation_type: self.cancellation_type,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandRequestCancelLocalActivity"]
pub struct SdkWorkflowCommandRequestCancelLocalActivity {
    pub seq: u32,
}

impl From<workflow_commands::RequestCancelLocalActivity> for SdkWorkflowCommandRequestCancelLocalActivity {
    fn from(external: workflow_commands::RequestCancelLocalActivity) -> Self {
        Self {
            seq: external.seq
        }
    }
}

impl Into<workflow_commands::RequestCancelLocalActivity> for SdkWorkflowCommandRequestCancelLocalActivity {
    fn into(self) -> workflow_commands::RequestCancelLocalActivity {
        workflow_commands::RequestCancelLocalActivity {
            seq: self.seq,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandUpsertWorkflowSearchAttributes"]
pub struct SdkWorkflowCommandUpsertWorkflowSearchAttributes {
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
}

impl From<workflow_commands::UpsertWorkflowSearchAttributes> for SdkWorkflowCommandUpsertWorkflowSearchAttributes {
    fn from(external: workflow_commands::UpsertWorkflowSearchAttributes) -> Self {
        Self {
            search_attributes: external.search_attributes.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::UpsertWorkflowSearchAttributes> for SdkWorkflowCommandUpsertWorkflowSearchAttributes {
    fn into(self) -> workflow_commands::UpsertWorkflowSearchAttributes {
        workflow_commands::UpsertWorkflowSearchAttributes {
            search_attributes: self.search_attributes.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandModifyWorkflowProperties"]
pub struct SdkWorkflowCommandModifyWorkflowProperties {
    pub upserted_memo: Option<SdkWorkflowMemo>,
}

impl From<workflow_commands::ModifyWorkflowProperties> for SdkWorkflowCommandModifyWorkflowProperties {
    fn from(external: workflow_commands::ModifyWorkflowProperties) -> Self {
        Self {
            upserted_memo: external.upserted_memo.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::ModifyWorkflowProperties> for SdkWorkflowCommandModifyWorkflowProperties {
    fn into(self) -> workflow_commands::ModifyWorkflowProperties {
        workflow_commands::ModifyWorkflowProperties {
            upserted_memo: self.upserted_memo.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandUpdateResponse"]
pub struct SdkWorkflowCommandUpdateResponse {
    pub protocol_instance_id: String,
    pub response: Option<SdkWorkflowCommandUpdateResponseStatus>,
}

impl From<workflow_commands::UpdateResponse> for SdkWorkflowCommandUpdateResponse {
    fn from(external: workflow_commands::UpdateResponse) -> Self {
        Self {
            protocol_instance_id: external.protocol_instance_id,
            response: external.response.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::UpdateResponse> for SdkWorkflowCommandUpdateResponse {
    fn into(self) -> workflow_commands::UpdateResponse {
        workflow_commands::UpdateResponse {
            protocol_instance_id: self.protocol_instance_id,
            response: self.response.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandUpdateResponseStatus"]
pub struct SdkWorkflowCommandUpdateResponseStatus {
    pub accepted: Option<bool>,
    pub rejected: Option<SdkWorkflowFailure>,
    pub completed: Option<SdkActivationPayload>
}

impl From<workflow_commands::update_response::Response> for SdkWorkflowCommandUpdateResponseStatus {
    fn from(external: workflow_commands::update_response::Response) -> Self {
        match external {
            workflow_commands::update_response::Response::Accepted(_resp) => {
                Self{accepted: Some(true), ..Self::default()}
            }
            workflow_commands::update_response::Response::Rejected(resp) => {
                Self{rejected: Some(resp.into()), ..Self::default()}
            }
            workflow_commands::update_response::Response::Completed(resp) => {
                Self{completed: Some(resp.into()), ..Self::default()}
            }
        }
    }
}

impl Into<workflow_commands::update_response::Response> for SdkWorkflowCommandUpdateResponseStatus {
    fn into(self) -> workflow_commands::update_response::Response {
        match self {
            Self{accepted: Some(_status), ..} => workflow_commands::update_response::Response::Accepted(()),
            Self{rejected: Some(status), ..} => workflow_commands::update_response::Response::Rejected(status.into()),
            Self{completed: Some(status), ..} => workflow_commands::update_response::Response::Completed(status.into()),
            _ => panic!("WorkflowCommandUpdateResponseStatus must have a value...")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandScheduleNexusOperation"]
pub struct SdkWorkflowCommandScheduleNexusOperation {
    pub seq: u32,
    pub endpoint: String,
    pub service: String,
    pub operation: String,
    pub input: Option<SdkActivationPayload>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub nexus_header: HashMap<String, String>,
    pub cancellation_type: i32,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>
}

impl From<workflow_commands::ScheduleNexusOperation> for SdkWorkflowCommandScheduleNexusOperation {
    fn from(external: workflow_commands::ScheduleNexusOperation) -> Self {
        Self {
            seq: external.seq,
            endpoint: external.endpoint,
            service: external.service,
            operation: external.operation,
            input: external.input.try_into_or_none(),
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            nexus_header: external.nexus_header,
            cancellation_type: external.cancellation_type,
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none()
        }
    }
}

impl Into<workflow_commands::ScheduleNexusOperation> for SdkWorkflowCommandScheduleNexusOperation {
    fn into(self) -> workflow_commands::ScheduleNexusOperation {
        workflow_commands::ScheduleNexusOperation {
            seq: self.seq,
            endpoint: self.endpoint,
            service: self.service,
            operation: self.operation,
            input: self.input.try_into_or_none(),
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            nexus_header: self.nexus_header,
            cancellation_type: self.cancellation_type,
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandRequestCancelNexusOperation"]
pub struct SdkWorkflowCommandRequestCancelNexusOperation {
    pub seq: u32
}

impl From<workflow_commands::RequestCancelNexusOperation> for SdkWorkflowCommandRequestCancelNexusOperation {
    fn from(external: workflow_commands::RequestCancelNexusOperation) -> Self {
        Self {
            seq: external.seq
        }
    }
}

impl Into<workflow_commands::RequestCancelNexusOperation> for SdkWorkflowCommandRequestCancelNexusOperation {
    fn into(self) -> workflow_commands::RequestCancelNexusOperation {
        workflow_commands::RequestCancelNexusOperation {
            seq: self.seq
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandSignalExternalExecutionTarget"]
pub struct SdkWorkflowCommandSignalExternalExecutionTarget {
    pub workflow_execution: Option<SdkWorkflowNamespacedExecution>,
    pub child_workflow_id: Option<String>
}

impl From<workflow_commands::signal_external_workflow_execution::Target> for SdkWorkflowCommandSignalExternalExecutionTarget {
    fn from(external: workflow_commands::signal_external_workflow_execution::Target) -> Self {
        match external {
            workflow_commands::signal_external_workflow_execution::Target::WorkflowExecution(target) => {
                Self{workflow_execution: Some(target.into()), ..Self::default()}
            }
            workflow_commands::signal_external_workflow_execution::Target::ChildWorkflowId(target) => {
                Self{child_workflow_id: Some(target.into()), ..Self::default()}
            }
        }
    }
}

impl Into<workflow_commands::signal_external_workflow_execution::Target> for SdkWorkflowCommandSignalExternalExecutionTarget {
    fn into(self) -> workflow_commands::signal_external_workflow_execution::Target {
        match self {
            Self{workflow_execution: Some(target), ..} => workflow_commands::signal_external_workflow_execution::Target::WorkflowExecution(target.into()),
            Self{child_workflow_id: Some(target), ..} => workflow_commands::signal_external_workflow_execution::Target::ChildWorkflowId(target.into()),
            _ => panic!("WorkflowCommandSignalExternalExecutionTarget must have a value...")
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandQueryResultVariant"]
pub struct SdkWorkflowCommandQueryResultVariant {
    pub succeeded: Option<SdkWorkflowCommandQuerySuccess>,
    pub failed: Option<SdkWorkflowFailure>,
}

impl From<workflow_commands::query_result::Variant> for SdkWorkflowCommandQueryResultVariant {
    fn from(external: workflow_commands::query_result::Variant) -> Self {
        match external {
            workflow_commands::query_result::Variant::Succeeded(variant) => {
                Self{succeeded: Some(variant.into()), ..Self::default()}
            }
            workflow_commands::query_result::Variant::Failed(variant) => {
                Self{failed: Some(variant.into()), ..Self::default()}
            }
        }
    }
}


impl Into<workflow_commands::query_result::Variant> for SdkWorkflowCommandQueryResultVariant {
    fn into(self) -> workflow_commands::query_result::Variant {
        match self {
            Self{succeeded: Some(variant), ..} => workflow_commands::query_result::Variant::Succeeded(variant.into()),
            Self{failed: Some(variant), ..} => workflow_commands::query_result::Variant::Failed(variant.into()),
            _ => panic!("WorkflowCommandSignalExternalExecutionTarget must have a value...")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowCommandQuerySuccess"]
pub struct SdkWorkflowCommandQuerySuccess {
    pub response: Option<SdkActivationPayload>
}

impl From<workflow_commands::QuerySuccess> for SdkWorkflowCommandQuerySuccess {
    fn from(external: workflow_commands::QuerySuccess) -> Self {
        Self {
            response: external.response.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::QuerySuccess> for SdkWorkflowCommandQuerySuccess {
    fn into(self) -> workflow_commands::QuerySuccess {
        workflow_commands::QuerySuccess {
            response: self.response.try_into_or_none()
        }
    }
}
