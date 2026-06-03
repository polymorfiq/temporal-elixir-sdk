use crate::common::{SdkDuration, SdkTimestamp};
use crate::core_worker::SdkWorkerDeploymentVersion;
use rustler::NifStruct;
use std::collections::HashMap;
use temporalio_sdk_common::protos::coresdk::activity_result::activity_resolution::Status as ActivityResolutionStatus;
use temporalio_sdk_common::protos::coresdk::child_workflow::child_workflow_result::Status as ChildWorkflowStatus;
use temporalio_sdk_common::protos::coresdk::nexus::nexus_operation_result::Status as NexusOperationResultStatus;
use temporalio_sdk_common::protos::coresdk::workflow_activation;
use temporalio_sdk_common::protos::coresdk::workflow_activation::workflow_activation_job::Variant as ActivationVariant;
use temporalio_sdk_common::protos::temporal::api as temporal_api;
use temporalio_sdk_common::protos::temporal::api::failure::v1::failure::FailureInfo;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ActivationFireTimer"]
pub struct SdkActivationFireTimer {
    pub seq: u32,
}

impl From<workflow_activation::FireTimer> for SdkActivationFireTimer {
    fn from(external: workflow_activation::FireTimer) -> Self {
        Self { seq: external.seq }
    }
}

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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
