use crate::common::{SdkDuration, SdkPriority, SdkRetryPolicy, SdkTimestamp};
use crate::core_workflows::{SdkWorkflowExecution, SdkWorkflowFailure};
use crate::data::common::SdkPayload;
use rustler::{NifRecord, NifUnitEnum, NifUntaggedEnum};
use std::collections::HashMap;
use temporalio_sdk_common::protos::coresdk::activity_result::activity_execution_result::Status as ActivityExecutionStatus;
use temporalio_sdk_common::protos::coresdk::activity_task;
use temporalio_sdk_common::protos::coresdk::activity_task::activity_task::Variant as ActivityTaskVariant;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_task"]
pub struct SdkActivityTask {
    pub variant: Option<SdkActivityTaskVariant>,
    pub task_token: Vec<u8>,
}

impl From<activity_task::ActivityTask> for SdkActivityTask {
    fn from(external: activity_task::ActivityTask) -> Self {
        Self {
            task_token: external.task_token,
            variant: external.variant.try_into_or_none(),
        }
    }
}

impl Into<activity_task::ActivityTask> for SdkActivityTask {
    fn into(self) -> activity_task::ActivityTask {
        activity_task::ActivityTask {
            task_token: self.task_token,
            variant: self.variant.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkActivityTaskVariant {
    Start(SdkActivityTaskStart),
    Cancel(SdkActivityTaskCancel),
}

impl From<ActivityTaskVariant> for SdkActivityTaskVariant {
    fn from(external: ActivityTaskVariant) -> Self {
        match external {
            ActivityTaskVariant::Start(task) => Self::Start(task.into()),
            ActivityTaskVariant::Cancel(task) => Self::Cancel(task.into()),
        }
    }
}

impl Into<ActivityTaskVariant> for SdkActivityTaskVariant {
    fn into(self) -> ActivityTaskVariant {
        match self {
            Self::Start(task) => ActivityTaskVariant::Start(task.into()),
            Self::Cancel(task) => ActivityTaskVariant::Cancel(task.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "start_activity"]
pub struct SdkActivityTaskStart {
    pub workflow_namespace: String,
    pub workflow_type: String,
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub activity_id: String,
    pub activity_type: String,
    pub header_fields: HashMap<String, SdkPayload>,
    pub input: Vec<SdkPayload>,
    pub heartbeat_details: Vec<SdkPayload>,
    pub scheduled_time: Option<SdkTimestamp>,
    pub current_attempt_scheduled_time: Option<SdkTimestamp>,
    pub started_time: Option<SdkTimestamp>,
    pub attempt: u32,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub heartbeat_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkRetryPolicy>,
    pub priority: Option<SdkPriority>,
    pub is_local: bool,
    pub run_id: String,
}

impl From<activity_task::Start> for SdkActivityTaskStart {
    fn from(external: activity_task::Start) -> Self {
        Self {
            workflow_namespace: external.workflow_namespace,
            workflow_type: external.workflow_type,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            header_fields: external
                .header_fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            input: external.input.iter().map(|val| val.into()).collect(),
            heartbeat_details: external
                .heartbeat_details
                .iter()
                .map(|val| val.into())
                .collect(),
            scheduled_time: external.scheduled_time.try_into_or_none(),
            current_attempt_scheduled_time: external
                .current_attempt_scheduled_time
                .try_into_or_none(),
            started_time: external.started_time.try_into_or_none(),
            attempt: external.attempt,
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: external.heartbeat_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            priority: external.priority.try_into_or_none(),
            is_local: external.is_local,
            run_id: external.run_id,
        }
    }
}

impl Into<activity_task::Start> for SdkActivityTaskStart {
    fn into(self) -> activity_task::Start {
        activity_task::Start {
            workflow_namespace: self.workflow_namespace,
            workflow_type: self.workflow_type,
            workflow_execution: self.workflow_execution.try_into_or_none(),
            activity_id: self.activity_id,
            activity_type: self.activity_type,
            header_fields: self
                .header_fields
                .iter()
                .map(|(k, v)| (k.clone(), v.into()))
                .collect(),
            input: self.input.iter().map(|val| val.into()).collect(),
            heartbeat_details: self
                .heartbeat_details
                .iter()
                .map(|val| val.into())
                .collect(),
            scheduled_time: self.scheduled_time.try_into_or_none(),
            current_attempt_scheduled_time: self.current_attempt_scheduled_time.try_into_or_none(),
            started_time: self.started_time.try_into_or_none(),
            attempt: self.attempt,
            schedule_to_close_timeout: self.schedule_to_close_timeout.try_into_or_none(),
            start_to_close_timeout: self.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: self.heartbeat_timeout.try_into_or_none(),
            retry_policy: self.retry_policy.try_into_or_none(),
            priority: self.priority.try_into_or_none(),
            is_local: self.is_local,
            run_id: self.run_id,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "cancel_activity"]
pub struct SdkActivityTaskCancel {
    pub reason: SdkActivityTaskCancelReason,
    pub details: Option<SdkActivityCancellationDetails>,
}

impl From<activity_task::Cancel> for SdkActivityTaskCancel {
    fn from(external: activity_task::Cancel) -> Self {
        Self {
            reason: external.reason.into(),
            details: external.details.try_into_or_none(),
        }
    }
}

impl Into<activity_task::Cancel> for SdkActivityTaskCancel {
    fn into(self) -> activity_task::Cancel {
        activity_task::Cancel {
            reason: self.reason.into(),
            details: self.details.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(Debug, NifUnitEnum, Clone)]
pub enum SdkActivityTaskCancelReason {
    NotFound = 0,
    Cancelled = 1,
    TimedOut = 2,
    WorkerShutdown = 3,
    Paused = 4,
    Reset = 5,
}

impl Into<i32> for SdkActivityTaskCancelReason {
    fn into(self) -> i32 {
        match self {
            Self::NotFound => 0,
            Self::Cancelled => 1,
            Self::TimedOut => 2,
            Self::WorkerShutdown => 3,
            Self::Paused => 4,
            Self::Reset => 5,
        }
    }
}

impl From<i32> for SdkActivityTaskCancelReason {
    fn from(intent: i32) -> SdkActivityTaskCancelReason {
        match intent {
            0 => Self::NotFound,
            1 => Self::Cancelled,
            2 => Self::TimedOut,
            3 => Self::WorkerShutdown,
            4 => Self::Paused,
            5 => Self::Reset,
            _ => Self::NotFound,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_cancellation_details"]
pub struct SdkActivityCancellationDetails {
    pub is_not_found: bool,
    pub is_cancelled: bool,
    pub is_paused: bool,
    pub is_timed_out: bool,
    pub is_worker_shutdown: bool,
    pub is_reset: bool,
}

impl From<activity_task::ActivityCancellationDetails> for SdkActivityCancellationDetails {
    fn from(external: activity_task::ActivityCancellationDetails) -> Self {
        Self {
            is_not_found: external.is_not_found,
            is_cancelled: external.is_cancelled,
            is_paused: external.is_paused,
            is_timed_out: external.is_timed_out,
            is_worker_shutdown: external.is_worker_shutdown,
            is_reset: external.is_reset,
        }
    }
}

impl Into<activity_task::ActivityCancellationDetails> for SdkActivityCancellationDetails {
    fn into(self) -> activity_task::ActivityCancellationDetails {
        activity_task::ActivityCancellationDetails {
            is_not_found: self.is_not_found,
            is_cancelled: self.is_cancelled,
            is_paused: self.is_paused,
            is_timed_out: self.is_timed_out,
            is_worker_shutdown: self.is_worker_shutdown,
            is_reset: self.is_reset,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "task_completion"]
pub struct SdkActivityTaskCompletion {
    result: Option<SdkActivityExecutionResult>,
    task_token: Vec<u8>,
}

impl From<temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion>
    for SdkActivityTaskCompletion
{
    fn from(external: temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion) -> Self {
        Self {
            task_token: external.task_token,
            result: external.result.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion>
    for SdkActivityTaskCompletion
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion {
        temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion {
            task_token: self.task_token,
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_execution_result"]
pub struct SdkActivityExecutionResult {
    status: Option<SdkActivityExecutionStatus>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult>
    for SdkActivityExecutionResult
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult,
    ) -> Self {
        Self {
            status: external.status.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult>
    for SdkActivityExecutionResult
{
    fn into(
        self,
    ) -> temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult {
        temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult {
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifUntaggedEnum, Clone)]
pub enum SdkActivityExecutionStatus {
    Completed(SdkActivityExecutionSuccess),
    Failed(SdkActivityExecutionFailure),
    Cancelled(SdkActivityExecutionCancellation),
    WillCompleteAsync(SdkActivityExecutionWillCompleteAsync),
}

impl From<ActivityExecutionStatus> for SdkActivityExecutionStatus {
    fn from(external: ActivityExecutionStatus) -> Self {
        match external {
            ActivityExecutionStatus::Completed(status) => Self::Completed(status.into()),
            ActivityExecutionStatus::Failed(status) => Self::Failed(status.into()),
            ActivityExecutionStatus::Cancelled(status) => Self::Cancelled(status.into()),
            ActivityExecutionStatus::WillCompleteAsync(status) => {
                Self::WillCompleteAsync(status.into())
            }
        }
    }
}

impl Into<ActivityExecutionStatus> for SdkActivityExecutionStatus {
    fn into(self) -> ActivityExecutionStatus {
        match self {
            Self::Completed(status) => ActivityExecutionStatus::Completed(status.into()),
            Self::Failed(status) => ActivityExecutionStatus::Failed(status.into()),
            Self::Cancelled(status) => ActivityExecutionStatus::Cancelled(status.into()),
            Self::WillCompleteAsync(status) => {
                ActivityExecutionStatus::WillCompleteAsync(status.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_completed"]
pub struct SdkActivityExecutionSuccess {
    result: Option<SdkPayload>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Success>
    for SdkActivityExecutionSuccess
{
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Success) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Success>
    for SdkActivityExecutionSuccess
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Success {
        temporalio_sdk_common::protos::coresdk::activity_result::Success {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_failed"]
pub struct SdkActivityExecutionFailure {
    failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Failure>
    for SdkActivityExecutionFailure
{
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Failure>
    for SdkActivityExecutionFailure
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Failure {
        temporalio_sdk_common::protos::coresdk::activity_result::Failure {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_cancelled"]
pub struct SdkActivityExecutionCancellation {
    failure: Option<SdkWorkflowFailure>,
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Cancellation>
    for SdkActivityExecutionCancellation
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
    for SdkActivityExecutionCancellation
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
        temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "activity_will_complete_async"]
pub struct SdkActivityExecutionWillCompleteAsync {}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync>
    for SdkActivityExecutionWillCompleteAsync
{
    fn from(
        _external: temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync,
    ) -> Self {
        Self {}
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync>
    for SdkActivityExecutionWillCompleteAsync
{
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync {
        temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync {}
    }
}
