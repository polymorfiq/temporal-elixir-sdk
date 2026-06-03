use std::collections::HashMap;
use rustler::NifStruct;
use temporalio_sdk_common::protos::coresdk::activity_task;
use temporalio_sdk_common::protos::coresdk::activity_task::activity_task::Variant as ActivityTaskVariant;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use crate::common::{SdkDuration, SdkTimestamp};
use crate::core_workflows::{SdkActivationPayload, SdkWorkflowExecution, SdkWorkflowPriority, SdkWorkflowRetryPolicy};

#[derive(NifStruct)]
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

#[derive(NifStruct, Default)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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

#[derive(NifStruct)]
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