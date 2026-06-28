use crate::common::{
    SdkCallback, SdkDuration, SdkHeader, SdkLink, SdkPayloads, SdkPriority, SdkRetryPolicy,
    SdkTimestamp,
};
use crate::core_worker::SdkWorkerDeploymentVersion;
use crate::data::common::{SdkPayload, SdkWorkflowArguments};
use rustler::{NifRecord, NifStruct, NifTaggedEnum, NifUnitEnum, NifUntaggedEnum, Resource};
use std::collections::HashMap;
use std::sync::RwLock;
use temporalio_sdk_client::errors::WorkflowGetResultError;
use temporalio_sdk_client::{Client, WorkflowHandle, WorkflowStartOptions, WorkflowStartSignal};
use temporalio_sdk_common::protos::coresdk::activity_result::activity_resolution::Status as ActivityResolutionStatus;
use temporalio_sdk_common::protos::coresdk::child_workflow::child_workflow_result::Status as ChildWorkflowStatus;
use temporalio_sdk_common::protos::coresdk::nexus::nexus_operation_result::Status as NexusOperationResultStatus;
use temporalio_sdk_common::protos::coresdk::workflow_activation;
use temporalio_sdk_common::protos::coresdk::workflow_activation::workflow_activation_job::Variant as ActivationVariant;
use temporalio_sdk_common::protos::coresdk::workflow_commands;
use temporalio_sdk_common::protos::coresdk::workflow_commands::workflow_command::Variant as WorkflowCommandVariant;
use temporalio_sdk_common::protos::coresdk::workflow_commands::WorkflowCommand;
use temporalio_sdk_common::protos::coresdk::workflow_completion;
use temporalio_sdk_common::protos::coresdk::workflow_completion::workflow_activation_completion::Status as WorkflowActivationCompletionStatus;
use temporalio_sdk_common::protos::temporal::api as temporal_api;
use temporalio_sdk_common::protos::temporal::api::common::v1::Payloads;
use temporalio_sdk_common::protos::temporal::api::enums::v1::{
    WorkflowIdConflictPolicy, WorkflowIdReusePolicy,
};
use temporalio_sdk_common::protos::temporal::api::failure::v1::failure::FailureInfo;
use temporalio_sdk_common::protos::temporal::api::query::v1::{QueryRejected, WorkflowQuery};
use temporalio_sdk_common::protos::temporal::api::sdk::v1::UserMetadata;
use temporalio_sdk_common::protos::temporal::api::update::v1::outcome::Value;
use temporalio_sdk_common::protos::temporal::api::update::v1::{
    Input, Outcome, UpdateRef, WaitPolicy,
};
use temporalio_sdk_common::protos::temporal::api::workflowservice::v1::{
    QueryWorkflowResponse, SignalWorkflowExecutionRequest, SignalWorkflowExecutionResponse,
    UpdateWorkflowExecutionResponse,
};
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use temporalio_sdk_common::{HasWorkflowDefinition, WorkflowDefinition};

pub struct ElixirWorkflowHandle<W> {
    #[allow(unused)]
    pub handle: RwLock<WorkflowHandle<Client, W>>,
}

#[rustler::resource_impl]
impl Resource for ElixirWorkflowHandle<SdkWorkflowDefinition> {}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activation"]
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
    pub suggest_continue_as_new_reasons: Vec<SdkContinueAsNewReason>,
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
            deployment_version_for_current_task: external
                .deployment_version_for_current_task
                .try_into_or_none(),
            last_sdk_version: external.last_sdk_version,
            suggest_continue_as_new_reasons: external
                .suggest_continue_as_new_reasons
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            target_worker_deployment_version_changed: external
                .target_worker_deployment_version_changed,
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkContinueAsNewReason {
    Unspecified = 0,
    HistorySizeTooLarge = 1,
    TooManyHistoryEvents = 2,
    TooManyUpdates = 3,
}

impl Into<i32> for SdkContinueAsNewReason {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::HistorySizeTooLarge => 1,
            Self::TooManyHistoryEvents => 2,
            Self::TooManyUpdates => 3,
        }
    }
}

impl From<i32> for SdkContinueAsNewReason {
    fn from(intent: i32) -> SdkContinueAsNewReason {
        match intent {
            0 => Self::Unspecified,
            1 => Self::HistorySizeTooLarge,
            2 => Self::TooManyHistoryEvents,
            3 => Self::TooManyUpdates,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "job"]
pub struct SdkWorkflowActivationJob {
    pub variant: Option<SdkWorkflowActivationJobVariant>,
}

impl From<workflow_activation::WorkflowActivationJob> for SdkWorkflowActivationJob {
    fn from(external: workflow_activation::WorkflowActivationJob) -> Self {
        Self {
            variant: external.variant.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowActivationJobVariant {
    InitializeWorkflow(SdkActivationInitializeWorkflow),
    FireTimer(SdkActivationFireTimer),
    UpdateRandomSeed(SdkActivationUpdateRandomSeed),
    QueryWorkflow(SdkActivationQueryWorkflow),
    CancelWorkflow(SdkActivationCancelWorkflow),
    SignalWorkflow(SdkActivationSignalWorkflow),
    ResolveActivity(SdkActivationResolveActivity),
    NotifyHasPatch(SdkActivationNotifyHasPatch),
    ResolveChildWorkflowExecutionStart(SdkActivationResolveChildWorkflowExecutionStart),
    ResolveChildWorkflowExecution(SdkActivationResolveChildWorkflowExecution),
    ResolveSignalExternalWorkflow(SdkActivationResolveSignalExternalWorkflow),
    ResolveRequestCancelExternalWorkflow(SdkActivationResolveRequestCancelExternalWorkflow),
    DoUpdate(SdkActivationDoUpdate),
    ResolveNexusOperationStart(SdkActivationResolveNexusOperationStart),
    ResolveNexusOperation(SdkActivationResolveNexusOperation),
    RemoveFromCache(SdkActivationRemoveFromCache),
}

impl From<ActivationVariant> for SdkWorkflowActivationJobVariant {
    fn from(external: ActivationVariant) -> Self {
        match external {
            ActivationVariant::InitializeWorkflow(variant) => {
                Self::InitializeWorkflow(variant.into())
            }
            ActivationVariant::FireTimer(variant) => Self::FireTimer(variant.into()),
            ActivationVariant::UpdateRandomSeed(variant) => Self::UpdateRandomSeed(variant.into()),
            ActivationVariant::QueryWorkflow(variant) => Self::QueryWorkflow(variant.into()),
            ActivationVariant::CancelWorkflow(variant) => Self::CancelWorkflow(variant.into()),
            ActivationVariant::SignalWorkflow(variant) => Self::SignalWorkflow(variant.into()),
            ActivationVariant::ResolveActivity(variant) => Self::ResolveActivity(variant.into()),
            ActivationVariant::NotifyHasPatch(variant) => Self::NotifyHasPatch(variant.into()),
            ActivationVariant::ResolveChildWorkflowExecutionStart(variant) => {
                Self::ResolveChildWorkflowExecutionStart(variant.into())
            }
            ActivationVariant::ResolveChildWorkflowExecution(variant) => {
                Self::ResolveChildWorkflowExecution(variant.into())
            }
            ActivationVariant::ResolveSignalExternalWorkflow(variant) => {
                Self::ResolveSignalExternalWorkflow(variant.into())
            }
            ActivationVariant::ResolveRequestCancelExternalWorkflow(variant) => {
                Self::ResolveRequestCancelExternalWorkflow(variant.into())
            }
            ActivationVariant::DoUpdate(variant) => Self::DoUpdate(variant.into()),
            ActivationVariant::ResolveNexusOperationStart(variant) => {
                Self::ResolveNexusOperationStart(variant.into())
            }
            ActivationVariant::ResolveNexusOperation(variant) => {
                Self::ResolveNexusOperation(variant.into())
            }
            ActivationVariant::RemoveFromCache(variant) => Self::RemoveFromCache(variant.into()),
        }
    }
}

impl Into<ActivationVariant> for SdkWorkflowActivationJobVariant {
    fn into(self) -> ActivationVariant {
        match self {
            Self::InitializeWorkflow(variant) => {
                ActivationVariant::InitializeWorkflow(variant.into())
            }
            Self::FireTimer(variant) => ActivationVariant::FireTimer(variant.into()),
            Self::UpdateRandomSeed(variant) => ActivationVariant::UpdateRandomSeed(variant.into()),
            Self::QueryWorkflow(variant) => ActivationVariant::QueryWorkflow(variant.into()),
            Self::CancelWorkflow(variant) => ActivationVariant::CancelWorkflow(variant.into()),
            Self::SignalWorkflow(variant) => ActivationVariant::SignalWorkflow(variant.into()),
            Self::ResolveActivity(variant) => ActivationVariant::ResolveActivity(variant.into()),
            Self::NotifyHasPatch(variant) => ActivationVariant::NotifyHasPatch(variant.into()),
            Self::ResolveChildWorkflowExecutionStart(variant) => {
                ActivationVariant::ResolveChildWorkflowExecutionStart(variant.into())
            }
            Self::ResolveChildWorkflowExecution(variant) => {
                ActivationVariant::ResolveChildWorkflowExecution(variant.into())
            }
            Self::ResolveSignalExternalWorkflow(variant) => {
                ActivationVariant::ResolveSignalExternalWorkflow(variant.into())
            }
            Self::ResolveRequestCancelExternalWorkflow(variant) => {
                ActivationVariant::ResolveRequestCancelExternalWorkflow(variant.into())
            }
            Self::DoUpdate(variant) => ActivationVariant::DoUpdate(variant.into()),
            Self::ResolveNexusOperationStart(variant) => {
                ActivationVariant::ResolveNexusOperationStart(variant.into())
            }
            Self::ResolveNexusOperation(variant) => {
                ActivationVariant::ResolveNexusOperation(variant.into())
            }
            Self::RemoveFromCache(variant) => ActivationVariant::RemoveFromCache(variant.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "initialize_workflow"]
pub struct SdkActivationInitializeWorkflow {
    pub workflow_type: String,
    pub workflow_id: String,
    pub arguments: Vec<SdkPayload>,
    pub randomness_seed: u64,
    pub headers: HashMap<String, SdkPayload>,
    pub identity: String,
    pub parent_workflow_info: Option<SdkWorkflowNamespacedExecution>,
    pub workflow_execution_timeout: Option<SdkDuration>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub continued_from_execution_run_id: String,
    pub continued_initiator: SdkContinuedAsNewInitiator,
    pub continued_failure: Option<SdkWorkflowFailure>,
    pub last_completion_result: Option<SdkPayloads>,
    pub first_execution_run_id: String,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub attempt: i32,
    pub cron_schedule: String,
    pub workflow_execution_expiration_time: Option<SdkTimestamp>,
    pub cron_schedule_to_schedule_interval: Option<SdkDuration>,
    pub memo: Option<SdkWorkflowMemo>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub start_time: Option<SdkTimestamp>,
    pub root_workflow: Option<SdkWorkflowExecution>,
    pub priority: Option<SdkPriority>,
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
            continued_initiator: external.continued_initiator.into(),
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

impl Into<workflow_activation::InitializeWorkflow> for SdkActivationInitializeWorkflow {
    fn into(self) -> workflow_activation::InitializeWorkflow {
        workflow_activation::InitializeWorkflow {
            workflow_type: self.workflow_type,
            workflow_id: self.workflow_id,
            arguments: self.arguments.iter().map(|val| val.into()).collect(),
            randomness_seed: self.randomness_seed,
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            identity: self.identity,
            parent_workflow_info: self.parent_workflow_info.try_into_or_none(),
            workflow_execution_timeout: self.workflow_execution_timeout.try_into_or_none(),
            workflow_run_timeout: self.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: self.workflow_task_timeout.try_into_or_none(),
            continued_from_execution_run_id: self.continued_from_execution_run_id,
            continued_initiator: self.continued_initiator.into(),
            continued_failure: self.continued_failure.try_into_or_none(),
            last_completion_result: self.last_completion_result.try_into_or_none(),
            first_execution_run_id: self.first_execution_run_id,
            retry_policy: self.retry_policy.try_into_or_none(),
            attempt: self.attempt,
            cron_schedule: self.cron_schedule,
            workflow_execution_expiration_time: self
                .workflow_execution_expiration_time
                .try_into_or_none(),
            cron_schedule_to_schedule_interval: self
                .cron_schedule_to_schedule_interval
                .try_into_or_none(),
            memo: self.memo.try_into_or_none(),
            search_attributes: self.search_attributes.try_into_or_none(),
            start_time: self.start_time.try_into_or_none(),
            root_workflow: self.root_workflow.try_into_or_none(),
            priority: self.priority.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkContinuedAsNewInitiator {
    Unspecified = 0,
    Workflow = 1,
    Retry = 2,
    CronSchedule = 3,
}

impl Into<i32> for SdkContinuedAsNewInitiator {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Workflow => 1,
            Self::Retry => 2,
            Self::CronSchedule => 3,
        }
    }
}

impl From<i32> for SdkContinuedAsNewInitiator {
    fn from(intent: i32) -> SdkContinuedAsNewInitiator {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Workflow,
            2 => Self::Retry,
            3 => Self::CronSchedule,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "fire_timer"]
pub struct SdkActivationFireTimer {
    pub seq: u32,
}

impl From<workflow_activation::FireTimer> for SdkActivationFireTimer {
    fn from(external: workflow_activation::FireTimer) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_activation::FireTimer> for SdkActivationFireTimer {
    fn into(self) -> workflow_activation::FireTimer {
        workflow_activation::FireTimer { seq: self.seq }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_random_seed"]
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

impl Into<workflow_activation::UpdateRandomSeed> for SdkActivationUpdateRandomSeed {
    fn into(self) -> workflow_activation::UpdateRandomSeed {
        workflow_activation::UpdateRandomSeed {
            randomness_seed: self.randomness_seed,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "query_workflow"]
pub struct SdkActivationQueryWorkflow {
    pub query_id: String,
    pub query_type: String,
    pub arguments: Vec<SdkPayload>,
    pub headers: HashMap<String, SdkPayload>,
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

impl Into<workflow_activation::QueryWorkflow> for SdkActivationQueryWorkflow {
    fn into(self) -> workflow_activation::QueryWorkflow {
        workflow_activation::QueryWorkflow {
            query_id: self.query_id,
            query_type: self.query_type,
            arguments: self.arguments.iter().map(|val| val.into()).collect(),
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_workflow"]
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

impl Into<workflow_activation::CancelWorkflow> for SdkActivationCancelWorkflow {
    fn into(self) -> workflow_activation::CancelWorkflow {
        workflow_activation::CancelWorkflow {
            reason: self.reason,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "signal_workflow"]
pub struct SdkActivationSignalWorkflow {
    pub signal_name: String,
    pub input: Vec<SdkPayload>,
    pub identity: String,
    pub headers: HashMap<String, SdkPayload>,
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

impl Into<workflow_activation::SignalWorkflow> for SdkActivationSignalWorkflow {
    fn into(self) -> workflow_activation::SignalWorkflow {
        workflow_activation::SignalWorkflow {
            signal_name: self.signal_name,
            input: self.input.iter().map(|val| val.into()).collect(),
            identity: self.identity,
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_activity"]
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

impl Into<workflow_activation::ResolveActivity> for SdkActivationResolveActivity {
    fn into(self) -> workflow_activation::ResolveActivity {
        workflow_activation::ResolveActivity {
            seq: self.seq,
            result: self.result.try_into_or_none(),
            is_local: self.is_local,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "notify_has_patch"]
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

impl Into<workflow_activation::NotifyHasPatch> for SdkActivationNotifyHasPatch {
    fn into(self) -> workflow_activation::NotifyHasPatch {
        workflow_activation::NotifyHasPatch {
            patch_id: self.patch_id,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_child_workflow_execution_start"]
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

impl Into<workflow_activation::ResolveChildWorkflowExecutionStart>
    for SdkActivationResolveChildWorkflowExecutionStart
{
    fn into(self) -> workflow_activation::ResolveChildWorkflowExecutionStart {
        workflow_activation::ResolveChildWorkflowExecutionStart {
            seq: self.seq,
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_child_workflow_execution"]
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

impl Into<workflow_activation::ResolveChildWorkflowExecution>
    for SdkActivationResolveChildWorkflowExecution
{
    fn into(self) -> workflow_activation::ResolveChildWorkflowExecution {
        workflow_activation::ResolveChildWorkflowExecution {
            seq: self.seq,
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_signal_external_workflow"]
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

impl Into<workflow_activation::ResolveSignalExternalWorkflow>
    for SdkActivationResolveSignalExternalWorkflow
{
    fn into(self) -> workflow_activation::ResolveSignalExternalWorkflow {
        workflow_activation::ResolveSignalExternalWorkflow {
            seq: self.seq,
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_request_cancel_external_workflow"]
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

impl Into<workflow_activation::ResolveRequestCancelExternalWorkflow>
    for SdkActivationResolveRequestCancelExternalWorkflow
{
    fn into(self) -> workflow_activation::ResolveRequestCancelExternalWorkflow {
        workflow_activation::ResolveRequestCancelExternalWorkflow {
            seq: self.seq,
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "do_update"]
pub struct SdkActivationDoUpdate {
    pub id: String,
    pub protocol_instance_id: String,
    pub name: String,
    pub input: Vec<SdkPayload>,
    pub headers: HashMap<String, SdkPayload>,
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

impl Into<workflow_activation::DoUpdate> for SdkActivationDoUpdate {
    fn into(self) -> workflow_activation::DoUpdate {
        workflow_activation::DoUpdate {
            id: self.id,
            protocol_instance_id: self.protocol_instance_id,
            name: self.name,
            input: self.input.iter().map(|val| val.into()).collect(),
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            meta: self.meta.try_into_or_none(),
            run_validator: self.run_validator,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_nexus_operation_start"]
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

impl Into<workflow_activation::ResolveNexusOperationStart>
    for SdkActivationResolveNexusOperationStart
{
    fn into(self) -> workflow_activation::ResolveNexusOperationStart {
        workflow_activation::ResolveNexusOperationStart {
            seq: self.seq,
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "resolve_nexus_operation"]
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

impl Into<workflow_activation::ResolveNexusOperation> for SdkActivationResolveNexusOperation {
    fn into(self) -> workflow_activation::ResolveNexusOperation {
        workflow_activation::ResolveNexusOperation {
            seq: self.seq,
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "remove_from_cache"]
pub struct SdkActivationRemoveFromCache {
    pub reason: SdkCacheEvictionReason,
    pub message: String,
}

impl From<workflow_activation::RemoveFromCache> for SdkActivationRemoveFromCache {
    fn from(external: workflow_activation::RemoveFromCache) -> Self {
        Self {
            message: external.message,
            reason: external.reason.into(),
        }
    }
}

impl Into<workflow_activation::RemoveFromCache> for SdkActivationRemoveFromCache {
    fn into(self) -> workflow_activation::RemoveFromCache {
        workflow_activation::RemoveFromCache {
            message: self.message,
            reason: self.reason.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkCacheEvictionReason {
    Unspecified = 0,
    CacheFull = 1,
    CacheMiss = 2,
    Nondeterminism = 3,
    LangFail = 4,
    LangRequested = 5,
    TaskNotFound = 6,
    UnhandledCommand = 7,
    Fatal = 8,
    PaginationOrHistoryFetch = 9,
    WorkflowExecutionEnding = 10,
}

impl Into<i32> for SdkCacheEvictionReason {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::CacheFull => 1,
            Self::CacheMiss => 2,
            Self::Nondeterminism => 3,
            Self::LangFail => 4,
            Self::LangRequested => 5,
            Self::TaskNotFound => 6,
            Self::UnhandledCommand => 7,
            Self::Fatal => 8,
            Self::PaginationOrHistoryFetch => 9,
            Self::WorkflowExecutionEnding => 10,
        }
    }
}

impl From<i32> for SdkCacheEvictionReason {
    fn from(intent: i32) -> SdkCacheEvictionReason {
        match intent {
            0 => Self::Unspecified,
            1 => Self::CacheFull,
            2 => Self::CacheMiss,
            3 => Self::Nondeterminism,
            4 => Self::LangFail,
            5 => Self::LangRequested,
            6 => Self::TaskNotFound,
            7 => Self::UnhandledCommand,
            8 => Self::Fatal,
            9 => Self::PaginationOrHistoryFetch,
            10 => Self::WorkflowExecutionEnding,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "nexus_operation_result"]
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

impl Into<temporalio_sdk_common::protos::coresdk::nexus::NexusOperationResult>
    for SdkWorkflowNexusOperationResult
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::nexus::NexusOperationResult {
        temporalio_sdk_common::protos::coresdk::nexus::NexusOperationResult {
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowNexusOperationStatus {
    Completed(SdkPayload),
    Failed(SdkWorkflowFailure),
    Cancelled(SdkWorkflowFailure),
    TimedOut(SdkWorkflowFailure),
}

impl From<NexusOperationResultStatus> for SdkWorkflowNexusOperationStatus {
    fn from(external: NexusOperationResultStatus) -> Self {
        match external {
            NexusOperationResultStatus::Completed(variant) => Self::Completed(variant.into()),
            NexusOperationResultStatus::Failed(variant) => Self::Failed(variant.into()),
            NexusOperationResultStatus::Cancelled(variant) => Self::Cancelled(variant.into()),
            NexusOperationResultStatus::TimedOut(variant) => Self::TimedOut(variant.into()),
        }
    }
}

impl Into<NexusOperationResultStatus> for SdkWorkflowNexusOperationStatus {
    fn into(self) -> NexusOperationResultStatus {
        match self {
            Self::Completed(variant) => NexusOperationResultStatus::Completed(variant.into()),
            Self::Failed(variant) => NexusOperationResultStatus::Failed(variant.into()),
            Self::Cancelled(variant) => NexusOperationResultStatus::Cancelled(variant.into()),
            Self::TimedOut(variant) => NexusOperationResultStatus::TimedOut(variant.into()),
        }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowResolveNexusOperationStartStatus {
    OperationToken(String),
    StartedSync(bool),
    Failed(SdkWorkflowFailure),
}

impl From<workflow_activation::resolve_nexus_operation_start::Status>
    for SdkWorkflowResolveNexusOperationStartStatus
{
    fn from(external: workflow_activation::resolve_nexus_operation_start::Status) -> Self {
        match external {
            workflow_activation::resolve_nexus_operation_start::Status::OperationToken(token) => {
                Self::OperationToken(token)
            }
            workflow_activation::resolve_nexus_operation_start::Status::StartedSync(started) => {
                Self::StartedSync(started)
            }
            workflow_activation::resolve_nexus_operation_start::Status::Failed(failure) => {
                Self::Failed(failure.into())
            }
        }
    }
}

impl Into<workflow_activation::resolve_nexus_operation_start::Status>
    for SdkWorkflowResolveNexusOperationStartStatus
{
    fn into(self) -> workflow_activation::resolve_nexus_operation_start::Status {
        match self {
            Self::OperationToken(token) => {
                workflow_activation::resolve_nexus_operation_start::Status::OperationToken(token)
            }
            Self::StartedSync(started) => {
                workflow_activation::resolve_nexus_operation_start::Status::StartedSync(started)
            }
            Self::Failed(failure) => {
                workflow_activation::resolve_nexus_operation_start::Status::Failed(failure.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_meta"]
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

impl Into<temporal_api::update::v1::Meta> for SdkUpdateMeta {
    fn into(self) -> temporal_api::update::v1::Meta {
        temporal_api::update::v1::Meta {
            update_id: self.update_id,
            identity: self.identity,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "child_workflow_result"]
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

impl Into<temporalio_sdk_common::protos::coresdk::child_workflow::ChildWorkflowResult>
    for SdkWorkflowChildResult
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::child_workflow::ChildWorkflowResult {
        temporalio_sdk_common::protos::coresdk::child_workflow::ChildWorkflowResult {
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowChildExecutionStatus {
    Completed(SdkWorkflowChildExecutionCompletedStatus),
    Failed(SdkWorkflowChildExecutionFailedStatus),
    Cancelled(SdkWorkflowChildExecutionCancelledStatus),
}

impl From<ChildWorkflowStatus> for SdkWorkflowChildExecutionStatus {
    fn from(external: ChildWorkflowStatus) -> Self {
        match external {
            ChildWorkflowStatus::Completed(status) => Self::Completed(status.into()),
            ChildWorkflowStatus::Failed(status) => Self::Failed(status.into()),
            ChildWorkflowStatus::Cancelled(status) => Self::Cancelled(status.into()),
        }
    }
}

impl Into<ChildWorkflowStatus> for SdkWorkflowChildExecutionStatus {
    fn into(self) -> ChildWorkflowStatus {
        match self {
            Self::Completed(status) => ChildWorkflowStatus::Completed(status.into()),
            Self::Failed(status) => ChildWorkflowStatus::Failed(status.into()),
            Self::Cancelled(status) => ChildWorkflowStatus::Cancelled(status.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "child_workflow_completed"]
pub struct SdkWorkflowChildExecutionCompletedStatus {
    pub result: Option<SdkPayload>,
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

impl Into<temporalio_sdk_common::protos::coresdk::child_workflow::Success>
    for SdkWorkflowChildExecutionCompletedStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::child_workflow::Success {
        temporalio_sdk_common::protos::coresdk::child_workflow::Success {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "child_workflow_failed"]
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

impl Into<temporalio_sdk_common::protos::coresdk::child_workflow::Failure>
    for SdkWorkflowChildExecutionFailedStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::child_workflow::Failure {
        temporalio_sdk_common::protos::coresdk::child_workflow::Failure {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "child_workflow_cancelled"]
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

impl Into<temporalio_sdk_common::protos::coresdk::child_workflow::Cancellation>
    for SdkWorkflowChildExecutionCancelledStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::child_workflow::Cancellation {
        temporalio_sdk_common::protos::coresdk::child_workflow::Cancellation {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowChildExecutionStartStatus {
    ChildWorkflowStartSucceeded(SdkWorkflowChildExecutionStartSucceededStatus),
    ChildWorkflowStartFailed(SdkWorkflowChildExecutionStartFailedStatus),
    ChildWorkflowStartCancelled(SdkWorkflowChildExecutionStartCancelledStatus),
}

impl From<workflow_activation::resolve_child_workflow_execution_start::Status>
    for SdkWorkflowChildExecutionStartStatus
{
    fn from(external: workflow_activation::resolve_child_workflow_execution_start::Status) -> Self {
        match external {
            workflow_activation::resolve_child_workflow_execution_start::Status::Succeeded(
                status,
            ) => Self::ChildWorkflowStartSucceeded(status.into()),
            workflow_activation::resolve_child_workflow_execution_start::Status::Failed(status) => {
                Self::ChildWorkflowStartFailed(status.into())
            }
            workflow_activation::resolve_child_workflow_execution_start::Status::Cancelled(
                status,
            ) => Self::ChildWorkflowStartCancelled(status.into()),
        }
    }
}

impl Into<workflow_activation::resolve_child_workflow_execution_start::Status>
    for SdkWorkflowChildExecutionStartStatus
{
    fn into(self) -> workflow_activation::resolve_child_workflow_execution_start::Status {
        match self {
            Self::ChildWorkflowStartSucceeded(status) => {
                workflow_activation::resolve_child_workflow_execution_start::Status::Succeeded(
                    status.into(),
                )
            }
            Self::ChildWorkflowStartFailed(status) => {
                workflow_activation::resolve_child_workflow_execution_start::Status::Failed(
                    status.into(),
                )
            }
            Self::ChildWorkflowStartCancelled(status) => {
                workflow_activation::resolve_child_workflow_execution_start::Status::Cancelled(
                    status.into(),
                )
            }
        }
    }
}

#[derive(Debug, NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkflowChildExecutionStartSucceededStatus"]
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

impl Into<workflow_activation::ResolveChildWorkflowExecutionStartSuccess>
    for SdkWorkflowChildExecutionStartSucceededStatus
{
    fn into(self) -> workflow_activation::ResolveChildWorkflowExecutionStartSuccess {
        workflow_activation::ResolveChildWorkflowExecutionStartSuccess {
            run_id: self.run_id,
        }
    }
}

#[derive(Debug, NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkflowChildExecutionStartFailedStatus"]
pub struct SdkWorkflowChildExecutionStartFailedStatus {
    pub workflow_id: String,
    pub workflow_type: String,
    pub cause: SdkStartChildWorkflowExecutionFailedCause,
}

impl From<workflow_activation::ResolveChildWorkflowExecutionStartFailure>
    for SdkWorkflowChildExecutionStartFailedStatus
{
    fn from(external: workflow_activation::ResolveChildWorkflowExecutionStartFailure) -> Self {
        Self {
            workflow_id: external.workflow_id,
            workflow_type: external.workflow_type,
            cause: external.cause.into(),
        }
    }
}

impl Into<workflow_activation::ResolveChildWorkflowExecutionStartFailure>
    for SdkWorkflowChildExecutionStartFailedStatus
{
    fn into(self) -> workflow_activation::ResolveChildWorkflowExecutionStartFailure {
        workflow_activation::ResolveChildWorkflowExecutionStartFailure {
            workflow_id: self.workflow_id,
            workflow_type: self.workflow_type,
            cause: self.cause.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkStartChildWorkflowExecutionFailedCause {
    Unspecified = 0,
    WorkflowAlreadyExists = 1,
}

impl Into<i32> for SdkStartChildWorkflowExecutionFailedCause {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::WorkflowAlreadyExists => 1,
        }
    }
}

impl From<i32> for SdkStartChildWorkflowExecutionFailedCause {
    fn from(intent: i32) -> SdkStartChildWorkflowExecutionFailedCause {
        match intent {
            0 => Self::Unspecified,
            1 => Self::WorkflowAlreadyExists,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkflowChildExecutionStartCancelledStatus"]
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

impl Into<workflow_activation::ResolveChildWorkflowExecutionStartCancelled>
    for SdkWorkflowChildExecutionStartCancelledStatus
{
    fn into(self) -> workflow_activation::ResolveChildWorkflowExecutionStartCancelled {
        workflow_activation::ResolveChildWorkflowExecutionStartCancelled {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_resolution"]
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

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::ActivityResolution>
    for SdkActivityResolution
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::ActivityResolution {
        temporalio_sdk_common::protos::coresdk::activity_result::ActivityResolution {
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkActivityResolutionStatus {
    Completed(SdkActivityResolutionCompletedStatus),
    Failed(SdkActivityResolutionFailedStatus),
    Cancelled(SdkActivityResolutionCancelledStatus),
    Backoff(SdkActivityResolutionBackoffStatus),
}

impl From<ActivityResolutionStatus> for SdkActivityResolutionStatus {
    fn from(external: ActivityResolutionStatus) -> Self {
        match external {
            ActivityResolutionStatus::Completed(status) => Self::Completed(status.into()),
            ActivityResolutionStatus::Failed(status) => Self::Failed(status.into()),
            ActivityResolutionStatus::Cancelled(status) => Self::Cancelled(status.into()),
            ActivityResolutionStatus::Backoff(status) => Self::Backoff(status.into()),
        }
    }
}

impl Into<ActivityResolutionStatus> for SdkActivityResolutionStatus {
    fn into(self) -> ActivityResolutionStatus {
        match self {
            Self::Completed(status) => ActivityResolutionStatus::Completed(status.into()),
            Self::Failed(status) => ActivityResolutionStatus::Failed(status.into()),
            Self::Cancelled(status) => ActivityResolutionStatus::Cancelled(status.into()),
            Self::Backoff(status) => ActivityResolutionStatus::Backoff(status.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_completed"]
pub struct SdkActivityResolutionCompletedStatus {
    pub result: Option<SdkPayload>,
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

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Success>
    for SdkActivityResolutionCompletedStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Success {
        temporalio_sdk_common::protos::coresdk::activity_result::Success {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_failed"]
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

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Failure>
    for SdkActivityResolutionFailedStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Failure {
        temporalio_sdk_common::protos::coresdk::activity_result::Failure {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_cancelled"]
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

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Cancellation>
    for SdkActivityResolutionCancelledStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
        temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_backoff"]
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

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::DoBackoff>
    for SdkActivityResolutionBackoffStatus
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::DoBackoff {
        temporalio_sdk_common::protos::coresdk::activity_result::DoBackoff {
            attempt: self.attempt,
            backoff_duration: self.backoff_duration.try_into_or_none(),
            original_schedule_time: self.original_schedule_time.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "memo"]
pub struct SdkWorkflowMemo {
    pub fields: HashMap<String, SdkPayload>,
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
                .collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "search_attribs"]
pub struct SdkWorkflowSearchAttributes {
    pub indexed_fields: HashMap<String, SdkPayload>,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "namespaced_workflow_execution"]
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

impl Into<temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution>
    for SdkWorkflowNamespacedExecution
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution {
        temporalio_sdk_common::protos::coresdk::common::NamespacedWorkflowExecution {
            namespace: self.namespace,
            workflow_id: self.workflow_id,
            run_id: self.run_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.ExternalPayloadDetails"]
pub struct SdkExternalPayloadDetails {
    pub size_bytes: i64,
}

impl From<temporal_api::common::v1::payload::ExternalPayloadDetails> for SdkExternalPayloadDetails {
    fn from(external: temporal_api::common::v1::payload::ExternalPayloadDetails) -> Self {
        Self {
            size_bytes: external.size_bytes,
        }
    }
}

impl Into<temporal_api::common::v1::payload::ExternalPayloadDetails> for SdkExternalPayloadDetails {
    fn into(self) -> temporal_api::common::v1::payload::ExternalPayloadDetails {
        temporal_api::common::v1::payload::ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

impl Into<temporal_api::common::v1::payload::ExternalPayloadDetails>
    for &SdkExternalPayloadDetails
{
    fn into(self) -> temporal_api::common::v1::payload::ExternalPayloadDetails {
        temporal_api::common::v1::payload::ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "failure"]
pub struct SdkWorkflowFailure {
    pub message: String,
    pub source: String,
    pub stack_trace: String,
    pub encoded_attributes: Option<SdkPayload>,
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

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowFailureInfo {
    Application(SdkWorkflowApplicationFailureInfo),
    Timeout(SdkWorkflowTimeoutFailureInfo),
    Cancelled(SdkWorkflowCanceledFailureInfo),
    Terminated(SdkWorkflowTerminatedFailureInfo),
    Server(SdkWorkflowServerFailureInfo),
    ResetWorkflow(SdkWorkflowResetFailureInfo),
    Activity(SdkWorkflowActivityFailureInfo),
    ChildExecution(SdkWorkflowChildExecutionFailureInfo),
    NexusOperation(SdkWorkflowNexusOperationFailureInfo),
    NexusHandler(SdkWorkflowNexusHandlerFailureInfo),
}

impl From<FailureInfo> for SdkWorkflowFailureInfo {
    fn from(external: FailureInfo) -> Self {
        match external {
            FailureInfo::ApplicationFailureInfo(info) => Self::Application(info.into()),
            FailureInfo::TimeoutFailureInfo(info) => Self::Timeout(info.into()),
            FailureInfo::CanceledFailureInfo(info) => Self::Cancelled(info.into()),
            FailureInfo::TerminatedFailureInfo(info) => Self::Terminated(info.into()),
            FailureInfo::ServerFailureInfo(info) => Self::Server(info.into()),
            FailureInfo::ResetWorkflowFailureInfo(info) => Self::ResetWorkflow(info.into()),
            FailureInfo::ActivityFailureInfo(info) => Self::Activity(info.into()),
            FailureInfo::ChildWorkflowExecutionFailureInfo(info) => {
                Self::ChildExecution(info.into())
            }
            FailureInfo::NexusOperationExecutionFailureInfo(info) => {
                Self::NexusOperation(info.into())
            }
            FailureInfo::NexusHandlerFailureInfo(info) => Self::NexusHandler(info.into()),
        }
    }
}

impl Into<FailureInfo> for SdkWorkflowFailureInfo {
    fn into(self) -> FailureInfo {
        match self {
            Self::Application(info) => FailureInfo::ApplicationFailureInfo(info.into()),
            Self::Timeout(info) => FailureInfo::TimeoutFailureInfo(info.into()),
            Self::Cancelled(info) => FailureInfo::CanceledFailureInfo(info.into()),
            Self::Terminated(info) => FailureInfo::TerminatedFailureInfo(info.into()),
            Self::Server(info) => FailureInfo::ServerFailureInfo(info.into()),
            Self::ResetWorkflow(info) => FailureInfo::ResetWorkflowFailureInfo(info.into()),
            Self::Activity(info) => FailureInfo::ActivityFailureInfo(info.into()),
            Self::ChildExecution(info) => {
                FailureInfo::ChildWorkflowExecutionFailureInfo(info.into())
            }
            Self::NexusOperation(info) => {
                FailureInfo::NexusOperationExecutionFailureInfo(info.into())
            }
            Self::NexusHandler(info) => FailureInfo::NexusHandlerFailureInfo(info.into()),
        }
    }
}

#[derive(NifTaggedEnum, Clone)]
pub enum SdkWorkflowGetResultError {
    Failed(SdkWorkflowFailure),
    Cancelled(Vec<SdkPayload>),
    Terminated(Vec<SdkPayload>),
    TimedOut,
    ContinuedAsNew,
    NotFound,
    PayloadConversion(String),
    Rpc(String),
    Other(String),
}

impl From<WorkflowGetResultError> for SdkWorkflowGetResultError {
    fn from(external: WorkflowGetResultError) -> Self {
        match external {
            WorkflowGetResultError::Failed(failure) => Self::Failed((*failure).into()),
            WorkflowGetResultError::Cancelled { details } => {
                Self::Cancelled(details.iter().map(|val| val.clone().into()).collect())
            }
            WorkflowGetResultError::Terminated { details } => {
                Self::Terminated(details.iter().map(|val| val.clone().into()).collect())
            }
            WorkflowGetResultError::TimedOut => Self::TimedOut,
            WorkflowGetResultError::ContinuedAsNew => Self::ContinuedAsNew,
            WorkflowGetResultError::NotFound(_) => Self::NotFound,
            WorkflowGetResultError::PayloadConversion(error) => {
                Self::PayloadConversion(error.to_string())
            }
            WorkflowGetResultError::Rpc(error) => Self::Rpc(error.to_string()),
            WorkflowGetResultError::Other(error) => Self::Other(error.to_string()),
            _ => Self::Other(String::from("Unknown error occurred")),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "application"]
pub struct SdkWorkflowApplicationFailureInfo {
    pub failure_type: String,
    pub non_retryable: bool,
    pub details: Vec<SdkPayload>,
    pub next_retry_delay: Option<SdkDuration>,
    pub category: SdkApplicationErrorCategory,
}

impl From<temporal_api::failure::v1::ApplicationFailureInfo> for SdkWorkflowApplicationFailureInfo {
    fn from(external: temporal_api::failure::v1::ApplicationFailureInfo) -> Self {
        Self {
            failure_type: external.r#type,
            non_retryable: external.non_retryable,
            details: match external.details {
                Some(payloads) => payloads.payloads.iter().map(|val| val.into()).collect(),
                None => Vec::new(),
            },
            next_retry_delay: external.next_retry_delay.try_into_or_none(),
            category: external.category.into(),
        }
    }
}

impl Into<temporal_api::failure::v1::ApplicationFailureInfo> for SdkWorkflowApplicationFailureInfo {
    fn into(self) -> temporal_api::failure::v1::ApplicationFailureInfo {
        temporal_api::failure::v1::ApplicationFailureInfo {
            r#type: self.failure_type,
            non_retryable: self.non_retryable,
            details: Some(Payloads {
                payloads: self.details.into_iter().map(|val| val.into()).collect(),
            }),
            next_retry_delay: self.next_retry_delay.try_into_or_none(),
            category: self.category.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkApplicationErrorCategory {
    Unspecified = 0,
    Benign = 1,
}

impl Into<i32> for SdkApplicationErrorCategory {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Benign => 1,
        }
    }
}

impl From<i32> for SdkApplicationErrorCategory {
    fn from(intent: i32) -> SdkApplicationErrorCategory {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Benign,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "timeout_reached"]
pub struct SdkWorkflowTimeoutFailureInfo {
    pub timeout_type: SdkTimeoutType,
    pub last_heartbeat_details: Option<SdkPayloads>,
}

impl From<temporal_api::failure::v1::TimeoutFailureInfo> for SdkWorkflowTimeoutFailureInfo {
    fn from(external: temporal_api::failure::v1::TimeoutFailureInfo) -> Self {
        Self {
            timeout_type: external.timeout_type.into(),
            last_heartbeat_details: external.last_heartbeat_details.try_into_or_none(),
        }
    }
}

impl Into<temporal_api::failure::v1::TimeoutFailureInfo> for SdkWorkflowTimeoutFailureInfo {
    fn into(self) -> temporal_api::failure::v1::TimeoutFailureInfo {
        temporal_api::failure::v1::TimeoutFailureInfo {
            timeout_type: self.timeout_type.into(),
            last_heartbeat_details: self.last_heartbeat_details.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkTimeoutType {
    Unspecified = 0,
    StartToClose = 1,
    ScheduleToStart = 2,
    ScheduleToClose = 3,
    Heartbeat = 4,
}

impl Into<i32> for SdkTimeoutType {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::StartToClose => 1,
            Self::ScheduleToStart => 2,
            Self::ScheduleToClose => 3,
            Self::Heartbeat => 4,
        }
    }
}

impl From<i32> for SdkTimeoutType {
    fn from(intent: i32) -> SdkTimeoutType {
        match intent {
            0 => Self::Unspecified,
            1 => Self::StartToClose,
            2 => Self::ScheduleToStart,
            3 => Self::ScheduleToClose,
            4 => Self::Heartbeat,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancelled"]
pub struct SdkWorkflowCanceledFailureInfo {
    pub details: Option<SdkPayloads>,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "terminated"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "server"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "reset_workflow"]
pub struct SdkWorkflowResetFailureInfo {
    pub last_heartbeat_details: Option<SdkPayloads>,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity"]
pub struct SdkWorkflowActivityFailureInfo {
    pub scheduled_event_id: i64,
    pub started_event_id: i64,
    pub identity: String,
    pub activity_type: Option<SdkWorkflowActivityType>,
    pub activity_id: String,
    pub retry_state: SdkRetryState,
}

impl From<temporal_api::failure::v1::ActivityFailureInfo> for SdkWorkflowActivityFailureInfo {
    fn from(external: temporal_api::failure::v1::ActivityFailureInfo) -> Self {
        Self {
            scheduled_event_id: external.scheduled_event_id,
            started_event_id: external.started_event_id,
            identity: external.identity,
            activity_type: external.activity_type.try_into_or_none(),
            activity_id: external.activity_id,
            retry_state: external.retry_state.into(),
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
            retry_state: self.retry_state.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkRetryState {
    Unspecified = 0,
    InProgress = 1,
    NonRetryableFailure = 2,
    Timeout = 3,
    MaximumAttemptsReached = 4,
    RetryPolicyNotSet = 5,
    InternalServerError = 6,
    CancelRequested = 7,
}

impl Into<i32> for SdkRetryState {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::InProgress => 1,
            Self::NonRetryableFailure => 2,
            Self::Timeout => 3,
            Self::MaximumAttemptsReached => 4,
            Self::RetryPolicyNotSet => 5,
            Self::InternalServerError => 6,
            Self::CancelRequested => 7,
        }
    }
}

impl From<i32> for SdkRetryState {
    fn from(intent: i32) -> SdkRetryState {
        match intent {
            0 => Self::Unspecified,
            1 => Self::InProgress,
            2 => Self::NonRetryableFailure,
            3 => Self::Timeout,
            4 => Self::MaximumAttemptsReached,
            5 => Self::RetryPolicyNotSet,
            6 => Self::InternalServerError,
            7 => Self::CancelRequested,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_type"]
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
        temporal_api::common::v1::ActivityType { name: self.name }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "child_execution"]
pub struct SdkWorkflowChildExecutionFailureInfo {
    pub namespace: String,
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub workflow_type: Option<SdkWorkflowType>,
    pub initiated_event_id: i64,
    pub started_event_id: i64,
    pub retry_state: SdkRetryState,
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
            retry_state: external.retry_state.into(),
        }
    }
}

impl Into<temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo>
    for SdkWorkflowChildExecutionFailureInfo
{
    fn into(self) -> temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo {
        temporal_api::failure::v1::ChildWorkflowExecutionFailureInfo {
            namespace: self.namespace,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            workflow_type: self.workflow_type.try_into_or_none(),
            initiated_event_id: self.initiated_event_id,
            started_event_id: self.started_event_id,
            retry_state: self.retry_state.into(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_execution"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_type"]
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
        temporal_api::common::v1::WorkflowType { name: self.name }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "nexus_operation"]
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

impl Into<temporal_api::failure::v1::NexusOperationFailureInfo>
    for SdkWorkflowNexusOperationFailureInfo
{
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "nexus_handler"]
pub struct SdkWorkflowNexusHandlerFailureInfo {
    pub failure_type: String,
    pub retry_behavior: SdkNexusHandlerErrorRetryBehavior,
}

impl From<temporal_api::failure::v1::NexusHandlerFailureInfo>
    for SdkWorkflowNexusHandlerFailureInfo
{
    fn from(external: temporal_api::failure::v1::NexusHandlerFailureInfo) -> Self {
        Self {
            failure_type: external.r#type,
            retry_behavior: external.retry_behavior.into(),
        }
    }
}

impl Into<temporal_api::failure::v1::NexusHandlerFailureInfo>
    for SdkWorkflowNexusHandlerFailureInfo
{
    fn into(self) -> temporal_api::failure::v1::NexusHandlerFailureInfo {
        temporal_api::failure::v1::NexusHandlerFailureInfo {
            r#type: self.failure_type,
            retry_behavior: self.retry_behavior.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkNexusHandlerErrorRetryBehavior {
    Unspecified = 0,
    Retryable = 1,
    NonRetryable = 2,
}

impl Into<i32> for SdkNexusHandlerErrorRetryBehavior {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Retryable => 1,
            Self::NonRetryable => 2,
        }
    }
}

impl From<i32> for SdkNexusHandlerErrorRetryBehavior {
    fn from(intent: i32) -> SdkNexusHandlerErrorRetryBehavior {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Retryable,
            2 => Self::NonRetryable,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "completion"]
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

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowActivationCompletionStatus {
    Successful(SdkWorkflowActivationCompletionSuccessStatus),
    Failed(SdkWorkflowActivationCompletionFailureStatus),
}

impl From<WorkflowActivationCompletionStatus> for SdkWorkflowActivationCompletionStatus {
    fn from(external: WorkflowActivationCompletionStatus) -> Self {
        match external {
            WorkflowActivationCompletionStatus::Successful(status) => {
                Self::Successful(status.into())
            }
            WorkflowActivationCompletionStatus::Failed(status) => Self::Failed(status.into()),
        }
    }
}

impl Into<WorkflowActivationCompletionStatus> for SdkWorkflowActivationCompletionStatus {
    fn into(self) -> WorkflowActivationCompletionStatus {
        match self {
            Self::Successful(status) => {
                WorkflowActivationCompletionStatus::Successful(status.into())
            }
            Self::Failed(status) => WorkflowActivationCompletionStatus::Failed(status.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "success"]
pub struct SdkWorkflowActivationCompletionSuccessStatus {
    pub commands: Vec<SdkWorkflowCommand>,
    pub used_internal_flags: Vec<u32>,
    pub versioning_behavior: SdkVersioningBehavior,
}

impl From<workflow_completion::Success> for SdkWorkflowActivationCompletionSuccessStatus {
    fn from(external: workflow_completion::Success) -> Self {
        Self {
            commands: external
                .commands
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            used_internal_flags: external.used_internal_flags,
            versioning_behavior: external.versioning_behavior.into(),
        }
    }
}

impl Into<workflow_completion::Success> for SdkWorkflowActivationCompletionSuccessStatus {
    fn into(self) -> workflow_completion::Success {
        workflow_completion::Success {
            commands: self.commands.iter().map(|val| val.clone().into()).collect(),
            used_internal_flags: self.used_internal_flags,
            versioning_behavior: self.versioning_behavior.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkVersioningBehavior {
    Unspecified = 0,
    Pinned = 1,
    AutoUpgrade = 2,
}

impl Into<i32> for SdkVersioningBehavior {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Pinned => 1,
            Self::AutoUpgrade => 2,
        }
    }
}

impl From<i32> for SdkVersioningBehavior {
    fn from(intent: i32) -> SdkVersioningBehavior {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Pinned,
            2 => Self::AutoUpgrade,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "failure"]
pub struct SdkWorkflowActivationCompletionFailureStatus {
    pub failure: Option<SdkWorkflowFailure>,
    pub force_cause: SdkWorkflowTaskFailedCause,
}

impl From<workflow_completion::Failure> for SdkWorkflowActivationCompletionFailureStatus {
    fn from(external: workflow_completion::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
            force_cause: external.force_cause.into(),
        }
    }
}

impl Into<workflow_completion::Failure> for SdkWorkflowActivationCompletionFailureStatus {
    fn into(self) -> workflow_completion::Failure {
        workflow_completion::Failure {
            failure: self.failure.try_into_or_none(),
            force_cause: self.force_cause.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkWorkflowTaskFailedCause {
    Unspecified = 0,
    UnhandledCommand = 1,
    BadScheduleActivityAttributes = 2,
    BadRequestCancelActivityAttributes = 3,
    BadStartTimerAttributes = 4,
    BadCancelTimerAttributes = 5,
    BadRecordMarkerAttributes = 6,
    BadCompleteWorkflowExecutionAttributes = 7,
    BadFailWorkflowExecutionAttributes = 8,
    BadCancelWorkflowExecutionAttributes = 9,
    BadRequestCancelExternalWorkflowExecutionAttributes = 10,
    BadContinueAsNewAttributes = 11,
    StartTimerDuplicateId = 12,
    ResetStickyTaskQueue = 13,
    WorkflowWorkerUnhandledFailure = 14,
    BadSignalWorkflowExecutionAttributes = 15,
    BadStartChildExecutionAttributes = 16,
    ForceCloseCommand = 17,
    FailoverCloseCommand = 18,
    BadSignalInputSize = 19,
    ResetWorkflow = 20,
    BadBinary = 21,
    ScheduleActivityDuplicateId = 22,
    BadSearchAttributes = 23,
    NonDeterministicError = 24,
    BadModifyWorkflowPropertiesAttributes = 25,
    PendingChildWorkflowsLimitExceeded = 26,
    PendingActivitiesLimitExceeded = 27,
    PendingSignalsLimitExceeded = 28,
    PendingRequestCancelLimitExceeded = 29,
    BadUpdateWorkflowExecutionMessage = 30,
    UnhandledUpdate = 31,
    BadScheduleNexusOperationAttributes = 32,
    PendingNexusOperationsLimitExceeded = 33,
    BadRequestCancelNexusOperationAttributes = 34,
    FeatureDisabled = 35,
    GrpcMessageTooLarge = 36,
    PayloadsTooLarge = 37,
}

impl Into<i32> for SdkWorkflowTaskFailedCause {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::UnhandledCommand => 1,
            Self::BadScheduleActivityAttributes => 2,
            Self::BadRequestCancelActivityAttributes => 3,
            Self::BadStartTimerAttributes => 4,
            Self::BadCancelTimerAttributes => 5,
            Self::BadRecordMarkerAttributes => 6,
            Self::BadCompleteWorkflowExecutionAttributes => 7,
            Self::BadFailWorkflowExecutionAttributes => 8,
            Self::BadCancelWorkflowExecutionAttributes => 9,
            Self::BadRequestCancelExternalWorkflowExecutionAttributes => 10,
            Self::BadContinueAsNewAttributes => 11,
            Self::StartTimerDuplicateId => 12,
            Self::ResetStickyTaskQueue => 13,
            Self::WorkflowWorkerUnhandledFailure => 14,
            Self::BadSignalWorkflowExecutionAttributes => 15,
            Self::BadStartChildExecutionAttributes => 16,
            Self::ForceCloseCommand => 17,
            Self::FailoverCloseCommand => 18,
            Self::BadSignalInputSize => 19,
            Self::ResetWorkflow => 20,
            Self::BadBinary => 21,
            Self::ScheduleActivityDuplicateId => 22,
            Self::BadSearchAttributes => 23,
            Self::NonDeterministicError => 24,
            Self::BadModifyWorkflowPropertiesAttributes => 25,
            Self::PendingChildWorkflowsLimitExceeded => 26,
            Self::PendingActivitiesLimitExceeded => 27,
            Self::PendingSignalsLimitExceeded => 28,
            Self::PendingRequestCancelLimitExceeded => 29,
            Self::BadUpdateWorkflowExecutionMessage => 30,
            Self::UnhandledUpdate => 31,
            Self::BadScheduleNexusOperationAttributes => 32,
            Self::PendingNexusOperationsLimitExceeded => 33,
            Self::BadRequestCancelNexusOperationAttributes => 34,
            Self::FeatureDisabled => 35,
            Self::GrpcMessageTooLarge => 36,
            Self::PayloadsTooLarge => 37,
        }
    }
}

impl From<i32> for SdkWorkflowTaskFailedCause {
    fn from(intent: i32) -> SdkWorkflowTaskFailedCause {
        match intent {
            0 => Self::Unspecified,
            1 => Self::UnhandledCommand,
            2 => Self::BadScheduleActivityAttributes,
            3 => Self::BadRequestCancelActivityAttributes,
            4 => Self::BadStartTimerAttributes,
            5 => Self::BadCancelTimerAttributes,
            6 => Self::BadRecordMarkerAttributes,
            7 => Self::BadCompleteWorkflowExecutionAttributes,
            8 => Self::BadFailWorkflowExecutionAttributes,
            9 => Self::BadCancelWorkflowExecutionAttributes,
            10 => Self::BadRequestCancelExternalWorkflowExecutionAttributes,
            11 => Self::BadContinueAsNewAttributes,
            12 => Self::StartTimerDuplicateId,
            13 => Self::ResetStickyTaskQueue,
            14 => Self::WorkflowWorkerUnhandledFailure,
            15 => Self::BadSignalWorkflowExecutionAttributes,
            16 => Self::BadStartChildExecutionAttributes,
            17 => Self::ForceCloseCommand,
            18 => Self::FailoverCloseCommand,
            19 => Self::BadSignalInputSize,
            20 => Self::ResetWorkflow,
            21 => Self::BadBinary,
            22 => Self::ScheduleActivityDuplicateId,
            23 => Self::BadSearchAttributes,
            24 => Self::NonDeterministicError,
            25 => Self::BadModifyWorkflowPropertiesAttributes,
            26 => Self::PendingChildWorkflowsLimitExceeded,
            27 => Self::PendingActivitiesLimitExceeded,
            28 => Self::PendingSignalsLimitExceeded,
            29 => Self::PendingRequestCancelLimitExceeded,
            30 => Self::BadUpdateWorkflowExecutionMessage,
            31 => Self::UnhandledUpdate,
            32 => Self::BadScheduleNexusOperationAttributes,
            33 => Self::PendingNexusOperationsLimitExceeded,
            34 => Self::BadRequestCancelNexusOperationAttributes,
            35 => Self::FeatureDisabled,
            36 => Self::GrpcMessageTooLarge,
            37 => Self::PayloadsTooLarge,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "command"]
pub struct SdkWorkflowCommand {
    pub user_metadata: Option<SdkUserMetadata>,
    pub variant: Option<SdkWorkflowCommandVariant>,
}

impl From<WorkflowCommand> for SdkWorkflowCommand {
    fn from(external: WorkflowCommand) -> Self {
        Self {
            user_metadata: external.user_metadata.try_into_or_none(),
            variant: external.variant.try_into_or_none(),
        }
    }
}

impl Into<WorkflowCommand> for SdkWorkflowCommand {
    fn into(self) -> WorkflowCommand {
        WorkflowCommand {
            user_metadata: self.user_metadata.try_into_or_none(),
            variant: self.variant.try_into_or_none(),
        }
    }
}

impl Into<WorkflowCommand> for &SdkWorkflowCommand {
    fn into(self) -> WorkflowCommand {
        WorkflowCommand {
            user_metadata: self.user_metadata.clone().try_into_or_none(),
            variant: self.variant.clone().try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "user_metadata"]
pub struct SdkUserMetadata {
    pub summary: Option<SdkPayload>,
    pub details: Option<SdkPayload>,
}

impl From<UserMetadata> for SdkUserMetadata {
    fn from(external: UserMetadata) -> Self {
        Self {
            summary: external.summary.try_into_or_none(),
            details: external.details.try_into_or_none(),
        }
    }
}

impl Into<UserMetadata> for SdkUserMetadata {
    fn into(self) -> UserMetadata {
        UserMetadata {
            summary: self.summary.try_into_or_none(),
            details: self.details.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowCommandVariant {
    StartTimer(SdkWorkflowCommandStartTimer),
    ScheduleActivity(SdkWorkflowCommandScheduleActivity),
    RespondToQuery(SdkWorkflowCommandRespondToQuery),
    RequestCancelActivity(SdkWorkflowCommandRequestCancelActivity),
    CancelTimer(SdkWorkflowCommandCancelTimer),
    CompleteWorkflowExecution(SdkWorkflowCommandCompleteWorkflowExecution),
    FailWorkflowExecution(SdkWorkflowCommandFailWorkflowExecution),
    ContinueAsNewWorkflowExecution(SdkWorkflowCommandContinueAsNewWorkflowExecution),
    CancelWorkflowExecution(SdkWorkflowCommandCancelWorkflowExecution),
    SetPatchMarker(SdkWorkflowCommandSetPatchMarker),
    StartChildWorkflowExecution(SdkWorkflowCommandStartChildWorkflowExecution),
    CancelChildWorkflowExecution(SdkWorkflowCommandCancelChildWorkflowExecution),
    RequestCancelExternalWorkflowExecution(
        SdkWorkflowCommandRequestCancelExternalWorkflowExecution,
    ),
    SignalExternalWorkflowExecution(SdkWorkflowCommandSignalExternalWorkflowExecution),
    CancelSignalWorkflow(SdkWorkflowCommandCancelSignalWorkflow),
    ScheduleLocalActivity(SdkWorkflowCommandScheduleLocalActivity),
    RequestCancelLocalActivity(SdkWorkflowCommandRequestCancelLocalActivity),
    UpsertWorkflowSearchAttributes(SdkWorkflowCommandUpsertWorkflowSearchAttributes),
    ModifyWorkflowProperties(SdkWorkflowCommandModifyWorkflowProperties),
    UpdateResponse(SdkWorkflowCommandUpdateResponse),
    ScheduleNexusOperation(SdkWorkflowCommandScheduleNexusOperation),
    RequestCancelNexusOperation(SdkWorkflowCommandRequestCancelNexusOperation),
}

impl From<WorkflowCommandVariant> for SdkWorkflowCommandVariant {
    fn from(external: WorkflowCommandVariant) -> Self {
        match external {
            WorkflowCommandVariant::StartTimer(cmd) => Self::StartTimer(cmd.into()),
            WorkflowCommandVariant::ScheduleActivity(cmd) => Self::ScheduleActivity(cmd.into()),
            WorkflowCommandVariant::RespondToQuery(cmd) => Self::RespondToQuery(cmd.into()),
            WorkflowCommandVariant::RequestCancelActivity(cmd) => {
                Self::RequestCancelActivity(cmd.into())
            }
            WorkflowCommandVariant::CancelTimer(cmd) => Self::CancelTimer(cmd.into()),
            WorkflowCommandVariant::CompleteWorkflowExecution(cmd) => {
                Self::CompleteWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::FailWorkflowExecution(cmd) => {
                Self::FailWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::ContinueAsNewWorkflowExecution(cmd) => {
                Self::ContinueAsNewWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::CancelWorkflowExecution(cmd) => {
                Self::CancelWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::SetPatchMarker(cmd) => Self::SetPatchMarker(cmd.into()),
            WorkflowCommandVariant::StartChildWorkflowExecution(cmd) => {
                Self::StartChildWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::CancelChildWorkflowExecution(cmd) => {
                Self::CancelChildWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::RequestCancelExternalWorkflowExecution(cmd) => {
                Self::RequestCancelExternalWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::SignalExternalWorkflowExecution(cmd) => {
                Self::SignalExternalWorkflowExecution(cmd.into())
            }
            WorkflowCommandVariant::CancelSignalWorkflow(cmd) => {
                Self::CancelSignalWorkflow(cmd.into())
            }
            WorkflowCommandVariant::ScheduleLocalActivity(cmd) => {
                Self::ScheduleLocalActivity(cmd.into())
            }
            WorkflowCommandVariant::RequestCancelLocalActivity(cmd) => {
                Self::RequestCancelLocalActivity(cmd.into())
            }
            WorkflowCommandVariant::UpsertWorkflowSearchAttributes(cmd) => {
                Self::UpsertWorkflowSearchAttributes(cmd.into())
            }
            WorkflowCommandVariant::ModifyWorkflowProperties(cmd) => {
                Self::ModifyWorkflowProperties(cmd.into())
            }
            WorkflowCommandVariant::UpdateResponse(cmd) => Self::UpdateResponse(cmd.into()),
            WorkflowCommandVariant::ScheduleNexusOperation(cmd) => {
                Self::ScheduleNexusOperation(cmd.into())
            }
            WorkflowCommandVariant::RequestCancelNexusOperation(cmd) => {
                Self::RequestCancelNexusOperation(cmd.into())
            }
        }
    }
}

impl Into<WorkflowCommandVariant> for SdkWorkflowCommandVariant {
    fn into(self) -> WorkflowCommandVariant {
        match self {
            Self::StartTimer(cmd) => WorkflowCommandVariant::StartTimer(cmd.into()),
            Self::ScheduleActivity(cmd) => WorkflowCommandVariant::ScheduleActivity(cmd.into()),
            Self::RespondToQuery(cmd) => WorkflowCommandVariant::RespondToQuery(cmd.into()),
            Self::RequestCancelActivity(cmd) => {
                WorkflowCommandVariant::RequestCancelActivity(cmd.into())
            }
            Self::CancelTimer(cmd) => WorkflowCommandVariant::CancelTimer(cmd.into()),
            Self::CompleteWorkflowExecution(cmd) => {
                WorkflowCommandVariant::CompleteWorkflowExecution(cmd.into())
            }
            Self::FailWorkflowExecution(cmd) => {
                WorkflowCommandVariant::FailWorkflowExecution(cmd.into())
            }
            Self::ContinueAsNewWorkflowExecution(cmd) => {
                WorkflowCommandVariant::ContinueAsNewWorkflowExecution(cmd.into())
            }
            Self::CancelWorkflowExecution(cmd) => {
                WorkflowCommandVariant::CancelWorkflowExecution(cmd.into())
            }
            Self::SetPatchMarker(cmd) => WorkflowCommandVariant::SetPatchMarker(cmd.into()),
            Self::StartChildWorkflowExecution(cmd) => {
                WorkflowCommandVariant::StartChildWorkflowExecution(cmd.into())
            }
            Self::CancelChildWorkflowExecution(cmd) => {
                WorkflowCommandVariant::CancelChildWorkflowExecution(cmd.into())
            }
            Self::RequestCancelExternalWorkflowExecution(cmd) => {
                WorkflowCommandVariant::RequestCancelExternalWorkflowExecution(cmd.into())
            }
            Self::SignalExternalWorkflowExecution(cmd) => {
                WorkflowCommandVariant::SignalExternalWorkflowExecution(cmd.into())
            }
            Self::CancelSignalWorkflow(cmd) => {
                WorkflowCommandVariant::CancelSignalWorkflow(cmd.into())
            }
            Self::ScheduleLocalActivity(cmd) => {
                WorkflowCommandVariant::ScheduleLocalActivity(cmd.into())
            }
            Self::RequestCancelLocalActivity(cmd) => {
                WorkflowCommandVariant::RequestCancelLocalActivity(cmd.into())
            }
            Self::UpsertWorkflowSearchAttributes(cmd) => {
                WorkflowCommandVariant::UpsertWorkflowSearchAttributes(cmd.into())
            }
            Self::ModifyWorkflowProperties(cmd) => {
                WorkflowCommandVariant::ModifyWorkflowProperties(cmd.into())
            }
            Self::UpdateResponse(cmd) => WorkflowCommandVariant::UpdateResponse(cmd.into()),
            Self::ScheduleNexusOperation(cmd) => {
                WorkflowCommandVariant::ScheduleNexusOperation(cmd.into())
            }
            Self::RequestCancelNexusOperation(cmd) => {
                WorkflowCommandVariant::RequestCancelNexusOperation(cmd.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "start_timer"]
pub struct SdkWorkflowCommandStartTimer {
    pub seq: u32,
    pub start_to_fire_timeout: Option<SdkDuration>,
}

impl From<workflow_commands::StartTimer> for SdkWorkflowCommandStartTimer {
    fn from(external: workflow_commands::StartTimer) -> Self {
        Self {
            seq: external.seq,
            start_to_fire_timeout: external.start_to_fire_timeout.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::StartTimer> for SdkWorkflowCommandStartTimer {
    fn into(self) -> workflow_commands::StartTimer {
        workflow_commands::StartTimer {
            seq: self.seq,
            start_to_fire_timeout: self.start_to_fire_timeout.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "schedule_activity"]
pub struct SdkWorkflowCommandScheduleActivity {
    pub seq: u32,
    pub activity_id: String,
    pub activity_type: String,
    pub task_queue: String,
    pub headers: HashMap<String, SdkPayload>,
    pub arguments: Vec<SdkPayload>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub heartbeat_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub cancellation_type: SdkActivityCancellationType,
    pub do_not_eagerly_execute: bool,
    pub versioning_intent: SdkVersioningIntent,
    pub priority: Option<SdkPriority>,
}

impl From<workflow_commands::ScheduleActivity> for SdkWorkflowCommandScheduleActivity {
    fn from(external: workflow_commands::ScheduleActivity) -> Self {
        Self {
            seq: external.seq,
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            task_queue: external.task_queue,
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            arguments: external
                .arguments
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: external.heartbeat_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            cancellation_type: external.cancellation_type.into(),
            do_not_eagerly_execute: external.do_not_eagerly_execute,
            versioning_intent: external.versioning_intent.into(),
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
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            arguments: self
                .arguments
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: self.heartbeat_timeout.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            cancellation_type: self.cancellation_type.into(),
            do_not_eagerly_execute: self.do_not_eagerly_execute,
            versioning_intent: self.versioning_intent.into(),
            priority: self.priority.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "respond_to_query"]
pub struct SdkWorkflowCommandRespondToQuery {
    pub query_id: String,
    pub variant: Option<SdkWorkflowCommandQueryResultVariant>,
}

impl From<workflow_commands::QueryResult> for SdkWorkflowCommandRespondToQuery {
    fn from(external: workflow_commands::QueryResult) -> Self {
        Self {
            query_id: external.query_id,
            variant: external.variant.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::QueryResult> for SdkWorkflowCommandRespondToQuery {
    fn into(self) -> workflow_commands::QueryResult {
        workflow_commands::QueryResult {
            query_id: self.query_id,
            variant: self.variant.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "request_cancel_activity"]
pub struct SdkWorkflowCommandRequestCancelActivity {
    pub seq: u32,
}

impl From<workflow_commands::RequestCancelActivity> for SdkWorkflowCommandRequestCancelActivity {
    fn from(external: workflow_commands::RequestCancelActivity) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_commands::RequestCancelActivity> for SdkWorkflowCommandRequestCancelActivity {
    fn into(self) -> workflow_commands::RequestCancelActivity {
        workflow_commands::RequestCancelActivity { seq: self.seq }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_timer"]
pub struct SdkWorkflowCommandCancelTimer {
    pub seq: u32,
}

impl From<workflow_commands::CancelTimer> for SdkWorkflowCommandCancelTimer {
    fn from(external: workflow_commands::CancelTimer) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_commands::CancelTimer> for SdkWorkflowCommandCancelTimer {
    fn into(self) -> workflow_commands::CancelTimer {
        workflow_commands::CancelTimer { seq: self.seq }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "complete_workflow_execution"]
pub struct SdkWorkflowCommandCompleteWorkflowExecution {
    pub result: Option<SdkPayload>,
}

impl From<workflow_commands::CompleteWorkflowExecution>
    for SdkWorkflowCommandCompleteWorkflowExecution
{
    fn from(external: workflow_commands::CompleteWorkflowExecution) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::CompleteWorkflowExecution>
    for SdkWorkflowCommandCompleteWorkflowExecution
{
    fn into(self) -> workflow_commands::CompleteWorkflowExecution {
        workflow_commands::CompleteWorkflowExecution {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "fail_workflow_execution"]
pub struct SdkWorkflowCommandFailWorkflowExecution {
    pub failure: Option<SdkWorkflowFailure>,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "continue_as_new_workflow_execution"]
pub struct SdkWorkflowCommandContinueAsNewWorkflowExecution {
    pub workflow_type: String,
    pub task_queue: String,
    pub arguments: Vec<SdkPayload>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub memo: HashMap<String, SdkPayload>,
    pub headers: HashMap<String, SdkPayload>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub versioning_intent: SdkVersioningIntent,
    pub initial_versioning_behavior: SdkContinueAsNewVersioningBehavior,
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkContinueAsNewVersioningBehavior {
    Unspecified = 0,
    AutoUpgrade = 1,
    UseRampVersion = 2,
}

impl Into<i32> for SdkContinueAsNewVersioningBehavior {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::AutoUpgrade => 1,
            Self::UseRampVersion => 2,
        }
    }
}

impl From<i32> for SdkContinueAsNewVersioningBehavior {
    fn from(intent: i32) -> SdkContinueAsNewVersioningBehavior {
        match intent {
            0 => Self::Unspecified,
            1 => Self::AutoUpgrade,
            2 => Self::UseRampVersion,
            _ => Self::Unspecified,
        }
    }
}

impl From<workflow_commands::ContinueAsNewWorkflowExecution>
    for SdkWorkflowCommandContinueAsNewWorkflowExecution
{
    fn from(external: workflow_commands::ContinueAsNewWorkflowExecution) -> Self {
        Self {
            workflow_type: external.workflow_type,
            task_queue: external.task_queue,
            arguments: external
                .arguments
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            workflow_run_timeout: external.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: external.workflow_task_timeout.try_into_or_none(),
            memo: external
                .memo
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            search_attributes: external.search_attributes.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            versioning_intent: external.versioning_intent.into(),
            initial_versioning_behavior: external.initial_versioning_behavior.into(),
        }
    }
}

impl Into<workflow_commands::ContinueAsNewWorkflowExecution>
    for SdkWorkflowCommandContinueAsNewWorkflowExecution
{
    fn into(self) -> workflow_commands::ContinueAsNewWorkflowExecution {
        workflow_commands::ContinueAsNewWorkflowExecution {
            workflow_type: self.workflow_type,
            task_queue: self.task_queue,
            arguments: self
                .arguments
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            workflow_run_timeout: self.workflow_run_timeout.try_into_or_none(),
            workflow_task_timeout: self.workflow_task_timeout.try_into_or_none(),
            memo: self
                .memo
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            search_attributes: self.search_attributes.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            versioning_intent: self.versioning_intent.into(),
            initial_versioning_behavior: self.initial_versioning_behavior.into(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_workflow_execution"]
pub struct SdkWorkflowCommandCancelWorkflowExecution {}

impl From<workflow_commands::CancelWorkflowExecution>
    for SdkWorkflowCommandCancelWorkflowExecution
{
    fn from(_external: workflow_commands::CancelWorkflowExecution) -> Self {
        Self {}
    }
}

impl Into<workflow_commands::CancelWorkflowExecution>
    for SdkWorkflowCommandCancelWorkflowExecution
{
    fn into(self) -> workflow_commands::CancelWorkflowExecution {
        workflow_commands::CancelWorkflowExecution {}
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "set_patch_marker"]
pub struct SdkWorkflowCommandSetPatchMarker {
    pub patch_id: String,
    pub deprecated: bool,
}

impl From<workflow_commands::SetPatchMarker> for SdkWorkflowCommandSetPatchMarker {
    fn from(external: workflow_commands::SetPatchMarker) -> Self {
        Self {
            patch_id: external.patch_id,
            deprecated: external.deprecated,
        }
    }
}

impl Into<workflow_commands::SetPatchMarker> for SdkWorkflowCommandSetPatchMarker {
    fn into(self) -> workflow_commands::SetPatchMarker {
        workflow_commands::SetPatchMarker {
            patch_id: self.patch_id,
            deprecated: self.deprecated,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "start_child_workflow_execution"]
pub struct SdkWorkflowCommandStartChildWorkflowExecution {
    pub seq: u32,
    pub namespace: String,
    pub workflow_id: String,
    pub workflow_type: String,
    pub task_queue: String,
    pub input: Vec<SdkPayload>,
    pub workflow_execution_timeout: Option<SdkDuration>,
    pub workflow_run_timeout: Option<SdkDuration>,
    pub workflow_task_timeout: Option<SdkDuration>,
    pub parent_close_policy: SdkChildWorkflowParentClosePolicy,
    pub workflow_id_reuse_policy: SdkWorkflowIdReusePolicy,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub cron_schedule: String,
    pub headers: HashMap<String, SdkPayload>,
    pub memo: HashMap<String, SdkPayload>,
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
    pub cancellation_type: SdkChildWorkflowCancellationType,
    pub versioning_intent: SdkVersioningIntent,
    pub priority: Option<SdkPriority>,
}

impl From<workflow_commands::StartChildWorkflowExecution>
    for SdkWorkflowCommandStartChildWorkflowExecution
{
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
            parent_close_policy: external.parent_close_policy.into(),
            workflow_id_reuse_policy: external.workflow_id_reuse_policy.into(),
            retry_policy: external.retry_policy.try_into_or_none(),
            cron_schedule: external.cron_schedule,
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            memo: external
                .memo
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            search_attributes: external.search_attributes.try_into_or_none(),
            cancellation_type: external.cancellation_type.into(),
            versioning_intent: external.versioning_intent.into(),
            priority: external.priority.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::StartChildWorkflowExecution>
    for SdkWorkflowCommandStartChildWorkflowExecution
{
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
            parent_close_policy: self.parent_close_policy.into(),
            workflow_id_reuse_policy: self.workflow_id_reuse_policy.into(),
            retry_policy: self.retry_policy.try_into_or_none(),
            cron_schedule: self.cron_schedule,
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            memo: self
                .memo
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            search_attributes: self.search_attributes.try_into_or_none(),
            cancellation_type: self.cancellation_type.into(),
            versioning_intent: self.versioning_intent.into(),
            priority: self.priority.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkVersioningIntent {
    Unspecified = 0,
    Compatible = 1,
    Default = 2,
}

impl Into<i32> for SdkVersioningIntent {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Compatible => 1,
            Self::Default => 2,
        }
    }
}

impl From<i32> for SdkVersioningIntent {
    fn from(intent: i32) -> SdkVersioningIntent {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Compatible,
            2 => Self::Default,
            _ => Self::Unspecified,
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkChildWorkflowCancellationType {
    Abandon = 0,
    TryCancel = 1,
    WaitCancellationCompleted = 2,
    WaitCancellationRequested = 3,
}

impl Into<i32> for SdkChildWorkflowCancellationType {
    fn into(self) -> i32 {
        match self {
            Self::Abandon => 0,
            Self::TryCancel => 1,
            Self::WaitCancellationCompleted => 2,
            Self::WaitCancellationRequested => 3,
        }
    }
}

impl From<i32> for SdkChildWorkflowCancellationType {
    fn from(intent: i32) -> SdkChildWorkflowCancellationType {
        match intent {
            0 => Self::Abandon,
            1 => Self::TryCancel,
            2 => Self::WaitCancellationCompleted,
            3 => Self::WaitCancellationRequested,
            _ => Self::Abandon,
        }
    }
}
#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkChildWorkflowParentClosePolicy {
    Unspecified = 0,
    Terminate = 1,
    Abandon = 2,
    RequestCancel = 3,
}

impl Into<i32> for SdkChildWorkflowParentClosePolicy {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Terminate => 1,
            Self::Abandon => 2,
            Self::RequestCancel => 2,
        }
    }
}

impl From<i32> for SdkChildWorkflowParentClosePolicy {
    fn from(intent: i32) -> SdkChildWorkflowParentClosePolicy {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Terminate,
            2 => Self::Abandon,
            3 => Self::RequestCancel,
            _ => Self::Unspecified,
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkWorkflowIdReusePolicy {
    Unspecified = 0,
    AllowDuplicate = 1,
    AllowDuplicateFailedOnly = 2,
    RejectDuplicate = 3,
    TerminateIfRunning = 4,
}

impl Into<i32> for SdkWorkflowIdReusePolicy {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::AllowDuplicate => 1,
            Self::AllowDuplicateFailedOnly => 2,
            Self::RejectDuplicate => 3,
            Self::TerminateIfRunning => 4,
        }
    }
}

impl From<i32> for SdkWorkflowIdReusePolicy {
    fn from(intent: i32) -> SdkWorkflowIdReusePolicy {
        match intent {
            0 => Self::Unspecified,
            1 => Self::AllowDuplicate,
            2 => Self::AllowDuplicateFailedOnly,
            3 => Self::RejectDuplicate,
            4 => Self::TerminateIfRunning,
            _ => Self::Unspecified,
        }
    }
}

impl From<WorkflowIdReusePolicy> for SdkWorkflowIdReusePolicy {
    fn from(external: WorkflowIdReusePolicy) -> Self {
        match external {
            WorkflowIdReusePolicy::Unspecified => Self::Unspecified,
            WorkflowIdReusePolicy::AllowDuplicate => Self::AllowDuplicate,
            WorkflowIdReusePolicy::AllowDuplicateFailedOnly => Self::AllowDuplicateFailedOnly,
            WorkflowIdReusePolicy::RejectDuplicate => Self::RejectDuplicate,
            #[allow(deprecated)]
            WorkflowIdReusePolicy::TerminateIfRunning => Self::TerminateIfRunning,
        }
    }
}

impl Into<WorkflowIdReusePolicy> for SdkWorkflowIdReusePolicy {
    fn into(self) -> WorkflowIdReusePolicy {
        match self {
            Self::Unspecified => WorkflowIdReusePolicy::Unspecified,
            Self::AllowDuplicate => WorkflowIdReusePolicy::AllowDuplicate,
            Self::AllowDuplicateFailedOnly => WorkflowIdReusePolicy::AllowDuplicateFailedOnly,
            Self::RejectDuplicate => WorkflowIdReusePolicy::RejectDuplicate,
            #[allow(deprecated)]
            Self::TerminateIfRunning => WorkflowIdReusePolicy::TerminateIfRunning,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_child_workflow_execution"]
pub struct SdkWorkflowCommandCancelChildWorkflowExecution {
    pub child_workflow_seq: u32,
    pub reason: String,
}

impl From<workflow_commands::CancelChildWorkflowExecution>
    for SdkWorkflowCommandCancelChildWorkflowExecution
{
    fn from(external: workflow_commands::CancelChildWorkflowExecution) -> Self {
        Self {
            child_workflow_seq: external.child_workflow_seq,
            reason: external.reason,
        }
    }
}

impl Into<workflow_commands::CancelChildWorkflowExecution>
    for SdkWorkflowCommandCancelChildWorkflowExecution
{
    fn into(self) -> workflow_commands::CancelChildWorkflowExecution {
        workflow_commands::CancelChildWorkflowExecution {
            child_workflow_seq: self.child_workflow_seq,
            reason: self.reason,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "request_cancel_external_workflow_execution"]
pub struct SdkWorkflowCommandRequestCancelExternalWorkflowExecution {
    pub seq: u32,
    pub workflow_execution: Option<SdkWorkflowNamespacedExecution>,
    pub reason: String,
}

impl From<workflow_commands::RequestCancelExternalWorkflowExecution>
    for SdkWorkflowCommandRequestCancelExternalWorkflowExecution
{
    fn from(external: workflow_commands::RequestCancelExternalWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            reason: external.reason,
        }
    }
}

impl Into<workflow_commands::RequestCancelExternalWorkflowExecution>
    for SdkWorkflowCommandRequestCancelExternalWorkflowExecution
{
    fn into(self) -> workflow_commands::RequestCancelExternalWorkflowExecution {
        workflow_commands::RequestCancelExternalWorkflowExecution {
            seq: self.seq,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            reason: self.reason,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "signal_external_workflow_execution"]
pub struct SdkWorkflowCommandSignalExternalWorkflowExecution {
    pub seq: u32,
    pub signal_name: String,
    pub args: Vec<SdkPayload>,
    pub headers: HashMap<String, SdkPayload>,
    pub target: Option<SdkWorkflowCommandSignalExternalExecutionTarget>,
}

impl From<workflow_commands::SignalExternalWorkflowExecution>
    for SdkWorkflowCommandSignalExternalWorkflowExecution
{
    fn from(external: workflow_commands::SignalExternalWorkflowExecution) -> Self {
        Self {
            seq: external.seq,
            signal_name: external.signal_name,
            args: external.args.iter().map(|val| val.clone().into()).collect(),
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            target: external.target.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::SignalExternalWorkflowExecution>
    for SdkWorkflowCommandSignalExternalWorkflowExecution
{
    fn into(self) -> workflow_commands::SignalExternalWorkflowExecution {
        workflow_commands::SignalExternalWorkflowExecution {
            seq: self.seq,
            signal_name: self.signal_name,
            args: self.args.iter().map(|val| val.clone().into()).collect(),
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            target: self.target.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_signal_workflow"]
pub struct SdkWorkflowCommandCancelSignalWorkflow {
    pub seq: u32,
}

impl From<workflow_commands::CancelSignalWorkflow> for SdkWorkflowCommandCancelSignalWorkflow {
    fn from(external: workflow_commands::CancelSignalWorkflow) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_commands::CancelSignalWorkflow> for SdkWorkflowCommandCancelSignalWorkflow {
    fn into(self) -> workflow_commands::CancelSignalWorkflow {
        workflow_commands::CancelSignalWorkflow { seq: self.seq }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "schedule_local_activity"]
pub struct SdkWorkflowCommandScheduleLocalActivity {
    pub seq: u32,
    pub activity_id: String,
    pub activity_type: String,
    pub attempt: u32,
    pub headers: HashMap<String, SdkPayload>,
    pub arguments: Vec<SdkPayload>,
    pub original_schedule_time: Option<SdkTimestamp>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub local_retry_threshold: Option<SdkDuration>,
    pub cancellation_type: SdkActivityCancellationType,
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkActivityCancellationType {
    TryCancel = 0,
    WaitCancellationCompleted = 1,
    Abandon = 2,
}

impl Into<i32> for SdkActivityCancellationType {
    fn into(self) -> i32 {
        match self {
            Self::TryCancel => 0,
            Self::WaitCancellationCompleted => 1,
            Self::Abandon => 2,
        }
    }
}

impl From<i32> for SdkActivityCancellationType {
    fn from(intent: i32) -> SdkActivityCancellationType {
        match intent {
            0 => Self::TryCancel,
            1 => Self::WaitCancellationCompleted,
            2 => Self::Abandon,
            _ => Self::TryCancel,
        }
    }
}

impl From<workflow_commands::ScheduleLocalActivity> for SdkWorkflowCommandScheduleLocalActivity {
    fn from(external: workflow_commands::ScheduleLocalActivity) -> Self {
        Self {
            seq: external.seq,
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            attempt: external.attempt,
            original_schedule_time: external.original_schedule_time.try_into_or_none(),
            headers: external
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            arguments: external.arguments.iter().map(|val| val.into()).collect(),
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            local_retry_threshold: external.local_retry_threshold.try_into_or_none(),
            cancellation_type: external.cancellation_type.into(),
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
            headers: self
                .headers
                .iter()
                .map(|(k, v)| (k.clone(), v.clone().into()))
                .collect(),
            arguments: self.arguments.iter().map(|val| val.into()).collect(),
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            local_retry_threshold: self.local_retry_threshold.try_into_or_none(),
            cancellation_type: self.cancellation_type.into(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "request_cancel_local_activity"]
pub struct SdkWorkflowCommandRequestCancelLocalActivity {
    pub seq: u32,
}

impl From<workflow_commands::RequestCancelLocalActivity>
    for SdkWorkflowCommandRequestCancelLocalActivity
{
    fn from(external: workflow_commands::RequestCancelLocalActivity) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_commands::RequestCancelLocalActivity>
    for SdkWorkflowCommandRequestCancelLocalActivity
{
    fn into(self) -> workflow_commands::RequestCancelLocalActivity {
        workflow_commands::RequestCancelLocalActivity { seq: self.seq }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "upsert_workflow_search_attributes"]
pub struct SdkWorkflowCommandUpsertWorkflowSearchAttributes {
    pub search_attributes: Option<SdkWorkflowSearchAttributes>,
}

impl From<workflow_commands::UpsertWorkflowSearchAttributes>
    for SdkWorkflowCommandUpsertWorkflowSearchAttributes
{
    fn from(external: workflow_commands::UpsertWorkflowSearchAttributes) -> Self {
        Self {
            search_attributes: external.search_attributes.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::UpsertWorkflowSearchAttributes>
    for SdkWorkflowCommandUpsertWorkflowSearchAttributes
{
    fn into(self) -> workflow_commands::UpsertWorkflowSearchAttributes {
        workflow_commands::UpsertWorkflowSearchAttributes {
            search_attributes: self.search_attributes.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "modify_workflow_properties"]
pub struct SdkWorkflowCommandModifyWorkflowProperties {
    pub upserted_memo: Option<SdkWorkflowMemo>,
}

impl From<workflow_commands::ModifyWorkflowProperties>
    for SdkWorkflowCommandModifyWorkflowProperties
{
    fn from(external: workflow_commands::ModifyWorkflowProperties) -> Self {
        Self {
            upserted_memo: external.upserted_memo.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::ModifyWorkflowProperties>
    for SdkWorkflowCommandModifyWorkflowProperties
{
    fn into(self) -> workflow_commands::ModifyWorkflowProperties {
        workflow_commands::ModifyWorkflowProperties {
            upserted_memo: self.upserted_memo.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_response"]
pub struct SdkWorkflowCommandUpdateResponse {
    pub protocol_instance_id: String,
    pub response: Option<SdkWorkflowCommandUpdateResponseStatus>,
}

impl From<workflow_commands::UpdateResponse> for SdkWorkflowCommandUpdateResponse {
    fn from(external: workflow_commands::UpdateResponse) -> Self {
        Self {
            protocol_instance_id: external.protocol_instance_id,
            response: external.response.try_into_or_none(),
        }
    }
}

impl Into<workflow_commands::UpdateResponse> for SdkWorkflowCommandUpdateResponse {
    fn into(self) -> workflow_commands::UpdateResponse {
        workflow_commands::UpdateResponse {
            protocol_instance_id: self.protocol_instance_id,
            response: self.response.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowCommandUpdateResponseStatus {
    UpdateAccepted(()),
    UpdateRejected(SdkWorkflowFailure),
    UpdateCompleted(SdkPayload),
}

impl From<workflow_commands::update_response::Response> for SdkWorkflowCommandUpdateResponseStatus {
    fn from(external: workflow_commands::update_response::Response) -> Self {
        match external {
            workflow_commands::update_response::Response::Accepted(()) => Self::UpdateAccepted(()),
            workflow_commands::update_response::Response::Rejected(status) => {
                Self::UpdateRejected(status.into())
            }
            workflow_commands::update_response::Response::Completed(payload) => {
                Self::UpdateCompleted(payload.into())
            }
        }
    }
}

impl Into<workflow_commands::update_response::Response> for SdkWorkflowCommandUpdateResponseStatus {
    fn into(self) -> workflow_commands::update_response::Response {
        match self {
            Self::UpdateAccepted(()) => workflow_commands::update_response::Response::Accepted(()),
            Self::UpdateRejected(status) => {
                workflow_commands::update_response::Response::Rejected(status.into())
            }
            Self::UpdateCompleted(payload) => {
                workflow_commands::update_response::Response::Completed(payload.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "schedule_nexus_operation"]
pub struct SdkWorkflowCommandScheduleNexusOperation {
    pub seq: u32,
    pub endpoint: String,
    pub service: String,
    pub operation: String,
    pub input: Option<SdkPayload>,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub nexus_header: HashMap<String, String>,
    pub cancellation_type: SdkNexusOperationCancellationType,
    pub schedule_to_start_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
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
            cancellation_type: external.cancellation_type.into(),
            schedule_to_start_timeout: external.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
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
            cancellation_type: self.cancellation_type.into(),
            schedule_to_start_timeout: self.schedule_to_start_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkNexusOperationCancellationType {
    WaitCancellationCompleted = 0,
    Abandon = 1,
    TryCancel = 2,
    WaitCancellationRequested = 3,
}

impl Into<i32> for SdkNexusOperationCancellationType {
    fn into(self) -> i32 {
        match self {
            Self::WaitCancellationCompleted => 0,
            Self::Abandon => 1,
            Self::TryCancel => 2,
            Self::WaitCancellationRequested => 3,
        }
    }
}

impl From<i32> for SdkNexusOperationCancellationType {
    fn from(intent: i32) -> SdkNexusOperationCancellationType {
        match intent {
            0 => Self::WaitCancellationCompleted,
            1 => Self::Abandon,
            2 => Self::TryCancel,
            3 => Self::WaitCancellationRequested,
            _ => Self::WaitCancellationCompleted,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_nexus_operation"]
pub struct SdkWorkflowCommandRequestCancelNexusOperation {
    pub seq: u32,
}

impl From<workflow_commands::RequestCancelNexusOperation>
    for SdkWorkflowCommandRequestCancelNexusOperation
{
    fn from(external: workflow_commands::RequestCancelNexusOperation) -> Self {
        Self { seq: external.seq }
    }
}

impl Into<workflow_commands::RequestCancelNexusOperation>
    for SdkWorkflowCommandRequestCancelNexusOperation
{
    fn into(self) -> workflow_commands::RequestCancelNexusOperation {
        workflow_commands::RequestCancelNexusOperation { seq: self.seq }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowCommandSignalExternalExecutionTarget {
    WorkflowExecution(SdkWorkflowNamespacedExecution),
    ChildWorkflowId(String),
}

impl From<workflow_commands::signal_external_workflow_execution::Target>
    for SdkWorkflowCommandSignalExternalExecutionTarget
{
    fn from(external: workflow_commands::signal_external_workflow_execution::Target) -> Self {
        match external {
            workflow_commands::signal_external_workflow_execution::Target::WorkflowExecution(
                exec,
            ) => Self::WorkflowExecution(exec.into()),
            workflow_commands::signal_external_workflow_execution::Target::ChildWorkflowId(id) => {
                Self::ChildWorkflowId(id)
            }
        }
    }
}

impl Into<workflow_commands::signal_external_workflow_execution::Target>
    for SdkWorkflowCommandSignalExternalExecutionTarget
{
    fn into(self) -> workflow_commands::signal_external_workflow_execution::Target {
        match self {
            Self::WorkflowExecution(exec) => {
                workflow_commands::signal_external_workflow_execution::Target::WorkflowExecution(
                    exec.into(),
                )
            }
            Self::ChildWorkflowId(id) => {
                workflow_commands::signal_external_workflow_execution::Target::ChildWorkflowId(id)
            }
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkWorkflowCommandQueryResultVariant {
    Succeeded(SdkWorkflowCommandQuerySuccess),
    Failed(SdkWorkflowFailure),
}

impl From<workflow_commands::query_result::Variant> for SdkWorkflowCommandQueryResultVariant {
    fn from(external: workflow_commands::query_result::Variant) -> Self {
        match external {
            workflow_commands::query_result::Variant::Succeeded(status) => {
                Self::Succeeded(status.into())
            }
            workflow_commands::query_result::Variant::Failed(status) => Self::Failed(status.into()),
        }
    }
}

impl Into<workflow_commands::query_result::Variant> for SdkWorkflowCommandQueryResultVariant {
    fn into(self) -> workflow_commands::query_result::Variant {
        match self {
            Self::Succeeded(status) => {
                workflow_commands::query_result::Variant::Succeeded(status.into())
            }
            Self::Failed(status) => workflow_commands::query_result::Variant::Failed(status.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "query_success"]
pub struct SdkWorkflowCommandQuerySuccess {
    pub response: Option<SdkPayload>,
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
            response: self.response.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_start_opts"]
pub struct SdkWorkflowStartOptions {
    pub task_queue: String,
    pub workflow_id: String,
    pub id_reuse_policy: SdkWorkflowIdReusePolicy,
    pub id_conflict_policy: SdkWorkflowIdConflictPolicy,
    pub execution_timeout: Option<SdkDuration>,
    pub run_timeout: Option<SdkDuration>,
    pub task_timeout: Option<SdkDuration>,
    pub cron_schedule: Option<String>,
    pub search_attributes: Option<HashMap<String, SdkPayload>>,
    pub enable_eager_workflow_start: Option<bool>,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub start_signal: Option<SdkWorkflowStartSignal>,
    pub links: Vec<SdkLink>,
    pub completion_callbacks: Vec<SdkCallback>,
    pub priority: Option<SdkPriority>,
    pub header: Option<SdkHeader>,
    pub static_summary: Option<String>,
    pub static_details: Option<String>,
}

impl From<WorkflowStartOptions> for SdkWorkflowStartOptions {
    fn from(external: WorkflowStartOptions) -> Self {
        Self {
            task_queue: external.task_queue,
            workflow_id: external.workflow_id,
            id_reuse_policy: external.id_reuse_policy.into(),
            id_conflict_policy: external.id_conflict_policy.into(),
            execution_timeout: external.execution_timeout.try_into_or_none(),
            run_timeout: external.run_timeout.try_into_or_none(),
            task_timeout: external.task_timeout.try_into_or_none(),
            cron_schedule: external.cron_schedule.try_into_or_none(),
            search_attributes: match external.search_attributes {
                Some(attribs) => Some(
                    attribs
                        .iter()
                        .map(|(k, v)| (k.to_string(), v.into()))
                        .collect(),
                ),
                None => None,
            },
            enable_eager_workflow_start: Some(external.enable_eager_workflow_start),
            retry_policy: external.retry_policy.try_into_or_none(),
            start_signal: external.start_signal.try_into_or_none(),
            links: external
                .links
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            completion_callbacks: external
                .completion_callbacks
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            priority: Some(external.priority.into()),
            header: external.header.try_into_or_none(),
            static_summary: external.static_summary,
            static_details: external.static_details,
        }
    }
}

impl Into<WorkflowStartOptions> for SdkWorkflowStartOptions {
    fn into(self) -> WorkflowStartOptions {
        WorkflowStartOptions::new(self.task_queue, self.workflow_id)
            .id_reuse_policy(self.id_reuse_policy.into())
            .id_conflict_policy(self.id_conflict_policy.into())
            .maybe_execution_timeout(self.execution_timeout.try_into_or_none())
            .maybe_run_timeout(self.run_timeout.try_into_or_none())
            .maybe_task_timeout(self.task_timeout.try_into_or_none())
            .maybe_cron_schedule(self.cron_schedule)
            .maybe_search_attributes(match self.search_attributes {
                Some(attribs) => Some(
                    attribs
                        .iter()
                        .map(|(k, v)| (k.to_string(), v.into()))
                        .collect(),
                ),
                None => None,
            })
            .maybe_enable_eager_workflow_start(self.enable_eager_workflow_start)
            .maybe_retry_policy(self.retry_policy.try_into_or_none())
            .maybe_start_signal(self.start_signal.try_into_or_none())
            .links(self.links.into_iter().map(|val| val.into()).collect())
            .completion_callbacks(
                self.completion_callbacks
                    .into_iter()
                    .map(|val| val.into())
                    .collect(),
            )
            .maybe_priority(self.priority.try_into_or_none())
            .maybe_header(self.header.try_into_or_none())
            .maybe_static_summary(self.static_summary.clone())
            .maybe_static_details(self.static_details.clone())
            .build()
    }
}

#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkWorkflowIdConflictPolicy {
    Unspecified,
    Fail,
    UseExisting,
    TerminateExisting,
}

impl From<WorkflowIdConflictPolicy> for SdkWorkflowIdConflictPolicy {
    fn from(external: WorkflowIdConflictPolicy) -> Self {
        match external {
            WorkflowIdConflictPolicy::Unspecified => Self::Unspecified,
            WorkflowIdConflictPolicy::Fail => Self::Fail,
            WorkflowIdConflictPolicy::UseExisting => Self::UseExisting,
            WorkflowIdConflictPolicy::TerminateExisting => Self::TerminateExisting,
        }
    }
}

impl Into<WorkflowIdConflictPolicy> for SdkWorkflowIdConflictPolicy {
    fn into(self) -> WorkflowIdConflictPolicy {
        match self {
            Self::Unspecified => WorkflowIdConflictPolicy::Unspecified,
            Self::Fail => WorkflowIdConflictPolicy::Fail,
            Self::UseExisting => WorkflowIdConflictPolicy::UseExisting,
            Self::TerminateExisting => WorkflowIdConflictPolicy::TerminateExisting,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "start_signal"]
pub struct SdkWorkflowStartSignal {
    pub signal_name: String,
    pub input: Option<SdkPayloads>,
    pub header: Option<SdkHeader>,
}

impl From<WorkflowStartSignal> for SdkWorkflowStartSignal {
    fn from(external: WorkflowStartSignal) -> Self {
        Self {
            signal_name: external.signal_name,
            input: external.input.try_into_or_none(),
            header: external.header.try_into_or_none(),
        }
    }
}

impl Into<WorkflowStartSignal> for SdkWorkflowStartSignal {
    fn into(self) -> WorkflowStartSignal {
        WorkflowStartSignal::new(self.signal_name)
            .maybe_input(self.input.try_into_or_none())
            .maybe_header(self.header.try_into_or_none())
            .build()
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_definition"]
pub struct SdkWorkflowDefinition {
    pub name: String,
}

impl WorkflowDefinition for SdkWorkflowDefinition {
    type Input = SdkWorkflowArguments;
    type Output = SdkWorkflowArguments;
    fn name(&self) -> &str {
        self.name.as_str()
    }
}

impl HasWorkflowDefinition for SdkWorkflowDefinition {
    type Run = Self;
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "get_workflow_result"]
pub struct SdkWorkflowGetResultOptions {
    pub follow_runs: bool,
    pub timeout: Option<SdkDuration>,
}

impl From<temporalio_sdk_client::WorkflowGetResultOptions> for SdkWorkflowGetResultOptions {
    fn from(external: temporalio_sdk_client::WorkflowGetResultOptions) -> Self {
        Self {
            follow_runs: external.follow_runs,
            timeout: None,
        }
    }
}

impl Into<temporalio_sdk_client::WorkflowGetResultOptions> for SdkWorkflowGetResultOptions {
    fn into(self) -> temporalio_sdk_client::WorkflowGetResultOptions {
        temporalio_sdk_client::WorkflowGetResultOptions::builder()
            .follow_runs(self.follow_runs)
            .build()
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_query"]
pub struct SdkWorkflowQuery {
    pub query_type: String,
    pub query_args: Vec<SdkPayload>,
    pub header: Option<SdkHeader>,
}

impl From<WorkflowQuery> for SdkWorkflowQuery {
    fn from(external: WorkflowQuery) -> Self {
        Self {
            query_type: external.query_type,
            query_args: match external.query_args {
                None => vec![],
                Some(p) => p.payloads.iter().map(|val| val.clone().into()).collect(),
            },
            header: external.header.try_into_or_none(),
        }
    }
}

impl Into<WorkflowQuery> for SdkWorkflowQuery {
    fn into(self) -> WorkflowQuery {
        WorkflowQuery {
            query_type: self.query_type,
            query_args: if self.query_args.len() > 0 {
                Some(Payloads {
                    payloads: self.query_args.iter().map(|val| val.into()).collect(),
                })
            } else {
                None
            },
            header: self.header.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkQueryRejectCondition {
    Unspecified = 0,
    None = 1,
    NotOpen = 2,
    NotCompletedCleanly = 3,
}
impl Into<i32> for SdkQueryRejectCondition {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::None => 1,
            Self::NotOpen => 2,
            Self::NotCompletedCleanly => 3,
        }
    }
}

impl From<i32> for SdkQueryRejectCondition {
    fn from(intent: i32) -> SdkQueryRejectCondition {
        match intent {
            0 => Self::Unspecified,
            1 => Self::None,
            2 => Self::NotOpen,
            3 => Self::NotCompletedCleanly,
            _ => Self::Unspecified,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "query_workflow_response"]
pub struct SdkQueryWorkflowResponse {
    pub query_result: Vec<SdkPayload>,
    pub query_rejected: Option<SdkQueryRejected>,
}

impl From<QueryWorkflowResponse> for SdkQueryWorkflowResponse {
    fn from(external: QueryWorkflowResponse) -> Self {
        Self {
            query_result: match external.query_result {
                None => vec![],
                Some(p) => p.payloads.iter().map(|val| val.clone().into()).collect(),
            },
            query_rejected: external.query_rejected.try_into_or_none(),
        }
    }
}

impl Into<QueryWorkflowResponse> for SdkQueryWorkflowResponse {
    fn into(self) -> QueryWorkflowResponse {
        QueryWorkflowResponse {
            query_result: if self.query_result.len() > 0 {
                Some(Payloads {
                    payloads: self.query_result.iter().map(|val| val.into()).collect(),
                })
            } else {
                None
            },
            query_rejected: self.query_rejected.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "query_rejected"]
pub struct SdkQueryRejected {
    pub status: SdkWorkflowExecutionStatus,
}

impl From<QueryRejected> for SdkQueryRejected {
    fn from(external: QueryRejected) -> Self {
        Self {
            status: external.status.into(),
        }
    }
}

impl Into<QueryRejected> for SdkQueryRejected {
    fn into(self) -> QueryRejected {
        QueryRejected {
            status: self.status.into(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "signal_workflow_request"]
pub struct SdkSignalWorkflowRequest {
    pub namespace: String,
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub signal_name: String,
    pub input: Vec<SdkPayload>,
    pub identity: String,
    pub request_id: String,
    pub control: String,
    pub header: Option<SdkHeader>,
    pub links: Vec<SdkLink>,
}

impl From<SignalWorkflowExecutionRequest> for SdkSignalWorkflowRequest {
    fn from(external: SignalWorkflowExecutionRequest) -> Self {
        Self {
            namespace: external.namespace,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            signal_name: external.signal_name,
            input: match external.input {
                None => vec![],
                Some(p) => p.payloads.iter().map(|val| val.into()).collect(),
            },
            identity: external.identity,
            request_id: external.request_id,
            #[allow(deprecated)]
            control: external.control,
            header: external.header.try_into_or_none(),
            links: external
                .links
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

impl Into<SignalWorkflowExecutionRequest> for SdkSignalWorkflowRequest {
    fn into(self) -> SignalWorkflowExecutionRequest {
        SignalWorkflowExecutionRequest {
            namespace: self.namespace,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            signal_name: self.signal_name,
            input: if self.input.len() == 0 {
                None
            } else {
                Some(Payloads {
                    payloads: self.input.iter().map(|val| val.clone().into()).collect(),
                })
            },
            identity: self.identity,
            request_id: self.request_id,
            #[allow(deprecated)]
            control: self.control,
            header: self.header.try_into_or_none(),
            links: self.links.iter().map(|val| val.clone().into()).collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "signal_workflow_response"]
pub struct SdkSignalWorkflowResponse {
    pub link: Option<SdkLink>,
}

impl From<SignalWorkflowExecutionResponse> for SdkSignalWorkflowResponse {
    fn from(external: SignalWorkflowExecutionResponse) -> Self {
        Self {
            link: external.link.try_into_or_none(),
        }
    }
}

impl Into<SignalWorkflowExecutionResponse> for SdkSignalWorkflowResponse {
    fn into(self) -> SignalWorkflowExecutionResponse {
        SignalWorkflowExecutionResponse {
            link: self.link.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_update"]
pub struct SdkWorkflowUpdate {
    pub name: String,
    pub args: Vec<SdkPayload>,
    pub header: Option<SdkHeader>,
}

impl From<Input> for SdkWorkflowUpdate {
    fn from(external: Input) -> Self {
        Self {
            name: external.name,
            args: match external.args {
                None => vec![],
                Some(p) => p.payloads.iter().map(|val| val.clone().into()).collect(),
            },
            header: external.header.try_into_or_none(),
        }
    }
}

impl Into<Input> for SdkWorkflowUpdate {
    fn into(self) -> Input {
        Input {
            name: self.name,
            args: if self.args.len() > 0 {
                Some(Payloads {
                    payloads: self.args.iter().map(|val| val.into()).collect(),
                })
            } else {
                None
            },
            header: self.header.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_update_response"]
pub struct SdkWorkflowUpdateResponse {
    pub update_ref: Option<SdkUpdateRef>,
    pub outcome: Option<SdkUpdateOutcome>,
    pub stage: SdkUpdateLifecycleStage,
}

impl From<UpdateWorkflowExecutionResponse> for SdkWorkflowUpdateResponse {
    fn from(external: UpdateWorkflowExecutionResponse) -> Self {
        Self {
            update_ref: external.update_ref.try_into_or_none(),
            outcome: external.outcome.try_into_or_none(),
            stage: external.stage.into(),
        }
    }
}

impl Into<UpdateWorkflowExecutionResponse> for SdkWorkflowUpdateResponse {
    fn into(self) -> UpdateWorkflowExecutionResponse {
        UpdateWorkflowExecutionResponse {
            update_ref: self.update_ref.try_into_or_none(),
            outcome: self.outcome.try_into_or_none(),
            stage: self.stage.into(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_ref"]
pub struct SdkUpdateRef {
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub update_id: String,
}

impl From<UpdateRef> for SdkUpdateRef {
    fn from(external: UpdateRef) -> Self {
        Self {
            workflow_execution: external.workflow_execution.try_into_or_none(),
            update_id: external.update_id,
        }
    }
}

impl Into<UpdateRef> for SdkUpdateRef {
    fn into(self) -> UpdateRef {
        UpdateRef {
            workflow_execution: self.workflow_execution.try_into_or_none(),
            update_id: self.update_id,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_outcome"]
pub struct SdkUpdateOutcome {
    pub value: Option<SdkUpdateValue>,
}

impl From<Outcome> for SdkUpdateOutcome {
    fn from(external: Outcome) -> Self {
        Self {
            value: external.value.try_into_or_none(),
        }
    }
}

impl Into<Outcome> for SdkUpdateOutcome {
    fn into(self) -> Outcome {
        Outcome {
            value: self.value.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkUpdateValue {
    Success(Vec<SdkPayload>),
    Failure(SdkWorkflowFailure),
}

impl From<Value> for SdkUpdateValue {
    fn from(external: Value) -> Self {
        match external {
            Value::Success(payloads) => {
                Self::Success(payloads.payloads.iter().map(|val| val.into()).collect())
            }
            Value::Failure(failure) => Self::Failure(failure.into()),
        }
    }
}

impl Into<Value> for SdkUpdateValue {
    fn into(self) -> Value {
        match self {
            Self::Success(payloads) => Value::Success(Payloads {
                payloads: payloads.iter().map(|val| val.into()).collect(),
            }),
            Self::Failure(failure) => Value::Failure(failure.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "update_wait_policy"]
pub struct SdkUpdateWaitPolicy {
    pub lifecycle_stage: SdkUpdateLifecycleStage,
}

impl From<WaitPolicy> for SdkUpdateWaitPolicy {
    fn from(external: WaitPolicy) -> Self {
        Self {
            lifecycle_stage: external.lifecycle_stage.into(),
        }
    }
}

impl Into<WaitPolicy> for SdkUpdateWaitPolicy {
    fn into(self) -> WaitPolicy {
        WaitPolicy {
            lifecycle_stage: self.lifecycle_stage.into(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkUpdateLifecycleStage {
    Unspecified = 0,
    Admitted = 1,
    Accepted = 2,
    Completed = 3,
}

impl Into<i32> for SdkUpdateLifecycleStage {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Admitted => 1,
            Self::Accepted => 2,
            Self::Completed => 3,
        }
    }
}

impl From<i32> for SdkUpdateLifecycleStage {
    fn from(intent: i32) -> SdkUpdateLifecycleStage {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Admitted,
            2 => Self::Accepted,
            3 => Self::Completed,
            _ => Self::Unspecified,
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkWorkflowExecutionStatus {
    Unspecified = 0,
    Running = 1,
    Completed = 2,
    Failed = 3,
    Canceled = 4,
    Terminated = 5,
    ContinuedAsNew = 6,
    TimedOut = 7,
    Paused = 8,
}

impl Into<i32> for SdkWorkflowExecutionStatus {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Running => 1,
            Self::Completed => 2,
            Self::Failed => 3,
            Self::Canceled => 4,
            Self::Terminated => 5,
            Self::ContinuedAsNew => 6,
            Self::TimedOut => 7,
            Self::Paused => 8,
        }
    }
}

impl From<i32> for SdkWorkflowExecutionStatus {
    fn from(intent: i32) -> SdkWorkflowExecutionStatus {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Running,
            2 => Self::Completed,
            3 => Self::Failed,
            4 => Self::Canceled,
            5 => Self::Terminated,
            6 => Self::ContinuedAsNew,
            7 => Self::TimedOut,
            8 => Self::Paused,
            _ => Self::Unspecified,
        }
    }
}
