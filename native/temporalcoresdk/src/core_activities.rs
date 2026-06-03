use std::collections::HashMap;
use rustler::NifStruct;
use temporalio_sdk_common::protos::coresdk::activity_task;
use temporalio_sdk_common::protos::coresdk::activity_task::activity_task::Variant as ActivityTaskVariant;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use crate::common::{SdkDuration, SdkTimestamp};
use crate::core_workflows::{SdkActivationPayload, SdkWorkflowExecution, SdkWorkflowFailure, SdkWorkflowPriority, SdkWorkflowRetryPolicy};
use temporalio_sdk_common::protos::coresdk::activity_result::activity_execution_result::Status as ActivityExecutionStatus;

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityTask"]
pub struct SdkActivityTask {
    pub task_token: Vec<u8>,
    pub variant: Option<SdkActivityTaskVariant>,
}

impl From<activity_task::ActivityTask> for SdkActivityTask {
    fn from(external: activity_task::ActivityTask) -> Self {
        Self {
            task_token: external.task_token,
            variant: external.variant.try_into_or_none()
        }
    }
}

impl Into<activity_task::ActivityTask> for SdkActivityTask {
    fn into(self) -> activity_task::ActivityTask {
        activity_task::ActivityTask {
            task_token: self.task_token,
            variant: self.variant.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityTaskVariant"]
pub struct SdkActivityTaskVariant {
    pub start: Option<SdkActivityTaskStart>,
    pub cancel: Option<SdkActivityTaskCancel>
}

impl From<ActivityTaskVariant> for SdkActivityTaskVariant {
    fn from(external: ActivityTaskVariant) -> Self {
        match external {
            ActivityTaskVariant::Start(task) => {
                Self{start: Some(task.into()), ..Self::default()}
            }
            ActivityTaskVariant::Cancel(task) => {
                Self{cancel: Some(task.into()), ..Self::default()}
            }
        }
    }
}

impl Into<ActivityTaskVariant> for SdkActivityTaskVariant {
    fn into(self) -> ActivityTaskVariant {
        match self {
            Self{start: Some(task), ..} => ActivityTaskVariant::Start(task.into()),
            Self{cancel: Some(task), ..} => ActivityTaskVariant::Cancel(task.into()),
            _ => panic!("ActivityTaskVariant needs a value!")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityTaskStart"]
pub struct SdkActivityTaskStart {
    pub workflow_namespace: String,
    pub workflow_type: String,
    pub workflow_execution: Option<SdkWorkflowExecution>,
    pub activity_id: String,
    pub activity_type: String,
    pub header_fields: HashMap<String, SdkActivationPayload>,
    pub input: Vec<SdkActivationPayload>,
    pub heartbeat_details: Vec<SdkActivationPayload>,
    pub scheduled_time: Option<SdkTimestamp>,
    pub current_attempt_scheduled_time: Option<SdkTimestamp>,
    pub started_time: Option<SdkTimestamp>,
    pub attempt: u32,
    pub schedule_to_close_timeout: Option<SdkDuration>,
    pub start_to_close_timeout: Option<SdkDuration>,
    pub heartbeat_timeout: Option<SdkDuration>,
    pub retry_policy: Option<SdkWorkflowRetryPolicy>,
    pub priority: Option<SdkWorkflowPriority>,
    pub is_local: bool,
    pub run_id: String
}

impl From<activity_task::Start> for SdkActivityTaskStart {
    fn from(external: activity_task::Start) -> Self {
        Self {
            workflow_namespace: external.workflow_namespace,
            workflow_type: external.workflow_type,
            workflow_execution: external.workflow_execution.try_into_or_none(),
            activity_id: external.activity_id,
            activity_type: external.activity_type,
            header_fields: external.header_fields.iter().map(|(k, v)| (k.clone(), v.into())).collect(),
            input: external.input.iter().map(|val| val.into()).collect(),
            heartbeat_details: external.heartbeat_details.iter().map(|val| val.into()).collect(),
            scheduled_time: external.scheduled_time.try_into_or_none(),
            current_attempt_scheduled_time: external.current_attempt_scheduled_time.try_into_or_none(),
            started_time: external.started_time.try_into_or_none(),
            attempt: external.attempt,
            schedule_to_close_timeout: external.schedule_to_close_timeout.try_into_or_none(),
            start_to_close_timeout: external.start_to_close_timeout.try_into_or_none(),
            heartbeat_timeout: external.heartbeat_timeout.try_into_or_none(),
            retry_policy: external.retry_policy.try_into_or_none(),
            priority: external.priority.try_into_or_none(),
            is_local: external.is_local,
            run_id: external.run_id
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
            header_fields: self.header_fields.iter().map(|(k, v)| (k.clone(), v.into())).collect(),
            input: self.input.iter().map(|val| val.into()).collect(),
            heartbeat_details: self.heartbeat_details.iter().map(|val| val.into()).collect(),
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
            run_id: self.run_id
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityTaskCancel"]
pub struct SdkActivityTaskCancel {
    pub reason: i32,
    pub details: Option<SdkActivityCancellationDetails>
}

impl From<activity_task::Cancel> for SdkActivityTaskCancel {
    fn from(external: activity_task::Cancel) -> Self {
        Self {
            reason: external.reason,
            details: external.details.try_into_or_none()
        }
    }
}

impl Into<activity_task::Cancel> for SdkActivityTaskCancel {
    fn into(self) -> activity_task::Cancel {
        activity_task::Cancel {
            reason: self.reason,
            details: self.details.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityCancellationDetails"]
pub struct SdkActivityCancellationDetails {
    pub is_not_found: bool,
    pub is_cancelled: bool,
    pub is_paused: bool,
    pub is_timed_out: bool,
    pub is_worker_shutdown: bool,
    pub is_reset: bool
}

impl From<activity_task::ActivityCancellationDetails> for SdkActivityCancellationDetails {
    fn from(external: activity_task::ActivityCancellationDetails) -> Self {
        Self {
            is_not_found: external.is_not_found,
            is_cancelled: external.is_cancelled,
            is_paused: external.is_paused,
            is_timed_out: external.is_timed_out,
            is_worker_shutdown: external.is_worker_shutdown,
            is_reset: external.is_reset
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
            is_reset: self.is_reset
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityTaskCompletion"]
pub struct SdkActivityTaskCompletion {
    task_token: Vec<u8>,
    result: Option<SdkActivityExecutionResult>
}

impl From<temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion> for SdkActivityTaskCompletion {
    fn from(external: temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion) -> Self {
        Self {
            task_token: external.task_token,
            result: external.result.try_into_or_none()
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion> for SdkActivityTaskCompletion {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion {
        temporalio_sdk_common::protos::coresdk::ActivityTaskCompletion {
            task_token: self.task_token,
            result: self.result.try_into_or_none()
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionResult"]
pub struct SdkActivityExecutionResult {
    status: Option<SdkActivityExecutionStatus>
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult> for SdkActivityExecutionResult {
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult) -> Self {
        Self {
            status: external.status.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult> for SdkActivityExecutionResult {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult {
        temporalio_sdk_common::protos::coresdk::activity_result::ActivityExecutionResult {
            status: self.status.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionStatus"]
pub struct SdkActivityExecutionStatus {
    completed: Option<SdkActivityExecutionSuccess>,
    failed: Option<SdkActivityExecutionFailure>,
    cancelled: Option<SdkActivityExecutionCancellation>,
    will_complete_async: Option<SdkActivityExecutionWillCompleteAsync>,
}

impl From<ActivityExecutionStatus> for SdkActivityExecutionStatus {
    fn from(external: ActivityExecutionStatus) -> Self {
        match external {
            ActivityExecutionStatus::Completed(status) => {
                Self{completed: Some(status.into()), ..Self::default()}
            }
            ActivityExecutionStatus::Failed(status) => {
                Self{failed: Some(status.into()), ..Self::default()}
            }
            ActivityExecutionStatus::Cancelled(status) => {
                Self{cancelled: Some(status.into()), ..Self::default()}
            }
            ActivityExecutionStatus::WillCompleteAsync(status) => {
                Self{will_complete_async: Some(status.into()), ..Self::default()}
            }
        }
    }
}

impl Into<ActivityExecutionStatus> for SdkActivityExecutionStatus {
    fn into(self) -> ActivityExecutionStatus {
        match self {
            Self{completed: Some(status), ..} => ActivityExecutionStatus::Completed(status.into()),
            Self{failed: Some(status), ..} => ActivityExecutionStatus::Failed(status.into()),
            Self{cancelled: Some(status), ..} => ActivityExecutionStatus::Cancelled(status.into()),
            Self{will_complete_async: Some(status), ..} => ActivityExecutionStatus::WillCompleteAsync(status.into()),
            _ => panic!("ActivityExecutionStatus needs a value!")
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionSuccess"]
pub struct SdkActivityExecutionSuccess {
    result: Option<SdkActivationPayload>
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Success> for SdkActivityExecutionSuccess {
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Success) -> Self {
        Self {
            result: external.result.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Success> for SdkActivityExecutionSuccess {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Success {
        temporalio_sdk_common::protos::coresdk::activity_result::Success {
            result: self.result.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionFailure"]
pub struct SdkActivityExecutionFailure {
    failure: Option<SdkWorkflowFailure>
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Failure> for SdkActivityExecutionFailure {
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Failure) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Failure> for SdkActivityExecutionFailure {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Failure {
        temporalio_sdk_common::protos::coresdk::activity_result::Failure {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionCancellation"]
pub struct SdkActivityExecutionCancellation {
    failure: Option<SdkWorkflowFailure>
}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::Cancellation> for SdkActivityExecutionCancellation {
    fn from(external: temporalio_sdk_common::protos::coresdk::activity_result::Cancellation) -> Self {
        Self {
            failure: external.failure.try_into_or_none(),
        }
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::Cancellation> for SdkActivityExecutionCancellation {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
        temporalio_sdk_common::protos::coresdk::activity_result::Cancellation {
            failure: self.failure.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ActivityExecutionWillCompleteAsync"]
pub struct SdkActivityExecutionWillCompleteAsync {}

impl From<temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync> for SdkActivityExecutionWillCompleteAsync {
    fn from(_external: temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync) -> Self {
        Self {}
    }
}

impl Into<temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync> for SdkActivityExecutionWillCompleteAsync {
    fn into(self) -> temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync {
        temporalio_sdk_common::protos::coresdk::activity_result::WillCompleteAsync {}
    }
}