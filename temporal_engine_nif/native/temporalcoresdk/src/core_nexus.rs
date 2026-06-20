use crate::common::SdkTimestamp;
use crate::data::common::SdkPayload;
use rustler::{NifStruct, NifUnitEnum};
use std::collections::HashMap;
use temporalio_sdk_common::protos::coresdk::nexus;
use temporalio_sdk_common::protos::coresdk::nexus::CancelNexusTask;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::request::Capabilities as NexusCapabilities;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::request::Variant as NexusRequestVariant;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::CancelOperationRequest as NexusCancelOperationRequest;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::Link as NexusLink;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::Request as NexusRequest;
use temporalio_sdk_common::protos::temporal::api::nexus::v1::StartOperationRequest as NexusStartOperationRequest;
use temporalio_sdk_common::protos::temporal::api::taskqueue::v1::PollerGroupInfo as TaskQueuePollerGroupInfo;
use temporalio_sdk_common::protos::temporal::api::taskqueue::v1::PollerScalingDecision as TaskQueuePollerScalingDecision;
use temporalio_sdk_common::protos::temporal::api::workflowservice::v1::PollNexusTaskQueueResponse;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusTask"]
pub struct SdkNexusTask {
    pub request_deadline: Option<SdkTimestamp>,
    pub endpoint: String,
    pub variant: Option<SdkNexusTaskVariant>,
}

impl From<nexus::NexusTask> for SdkNexusTask {
    fn from(external: nexus::NexusTask) -> Self {
        Self {
            request_deadline: external.request_deadline.try_into_or_none(),
            endpoint: external.endpoint,
            variant: external.variant.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default)]
#[module = "TemporalEngineNif.Data.NexusTaskVariant"]
pub struct SdkNexusTaskVariant {
    task: Option<SdkNexusPollTaskQueueResponse>,
    cancel_task: Option<SdkNexusCancelTask>,
}

impl From<nexus::nexus_task::Variant> for SdkNexusTaskVariant {
    fn from(external: nexus::nexus_task::Variant) -> Self {
        match external {
            nexus::nexus_task::Variant::Task(task) => Self {
                task: Some(task.into()),
                ..Self::default()
            },

            nexus::nexus_task::Variant::CancelTask(task) => Self {
                cancel_task: Some(task.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusPollTaskQueueResponse"]
pub struct SdkNexusPollTaskQueueResponse {
    pub task_token: Vec<u8>,
    pub request: Option<SdkNexusRequest>,
    pub poller_scaling_decision: Option<SdkPollerScalingDecision>,
    pub poller_group_id: String,
    pub poller_group_infos: Vec<SdkPollerGroupInfo>,
}

impl From<PollNexusTaskQueueResponse> for SdkNexusPollTaskQueueResponse {
    fn from(external: PollNexusTaskQueueResponse) -> Self {
        Self {
            task_token: external.task_token,
            request: external.request.try_into_or_none(),
            poller_scaling_decision: external.poller_scaling_decision.try_into_or_none(),
            poller_group_id: external.poller_group_id,
            poller_group_infos: external
                .poller_group_infos
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusCancelTask"]
pub struct SdkNexusCancelTask {
    pub task_token: Vec<u8>,
    pub reason: SdkNexusTaskCancelReason,
}

impl From<CancelNexusTask> for SdkNexusCancelTask {
    fn from(external: CancelNexusTask) -> Self {
        Self {
            task_token: external.task_token,
            reason: external.reason.into(),
        }
    }
}

#[repr(i32)]
#[derive(NifUnitEnum, Clone)]
pub enum SdkNexusTaskCancelReason {
    TimedOut = 0,
    WorkerShutdown = 1,
}

impl Into<i32> for SdkNexusTaskCancelReason {
    fn into(self) -> i32 {
        match self {
            Self::TimedOut => 0,
            Self::WorkerShutdown => 1,
        }
    }
}

impl From<i32> for SdkNexusTaskCancelReason {
    fn from(intent: i32) -> SdkNexusTaskCancelReason {
        match intent {
            0 => Self::TimedOut,
            1 => Self::WorkerShutdown,
            _ => Self::TimedOut,
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.PollerScalingDecision"]
pub struct SdkPollerScalingDecision {
    pub poll_request_delta_suggestion: i32,
}

impl From<TaskQueuePollerScalingDecision> for SdkPollerScalingDecision {
    fn from(external: TaskQueuePollerScalingDecision) -> Self {
        Self {
            poll_request_delta_suggestion: external.poll_request_delta_suggestion,
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.PollerGroupInfo"]
pub struct SdkPollerGroupInfo {
    pub id: String,
    pub weight: f32,
}

impl From<TaskQueuePollerGroupInfo> for SdkPollerGroupInfo {
    fn from(external: TaskQueuePollerGroupInfo) -> Self {
        Self {
            id: external.id,
            weight: external.weight,
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusRequest"]
pub struct SdkNexusRequest {
    pub header: HashMap<String, String>,
    pub scheduled_time: Option<SdkTimestamp>,
    pub capabilities: Option<SdkNexusCapabilities>,
    pub endpoint: String,
    pub variant: Option<SdkNexusRequestVariant>,
}

impl From<NexusRequest> for SdkNexusRequest {
    fn from(external: NexusRequest) -> Self {
        Self {
            header: external.header,
            scheduled_time: external.scheduled_time.try_into_or_none(),
            capabilities: external.capabilities.try_into_or_none(),
            endpoint: external.endpoint,
            variant: external.variant.try_into_or_none(),
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusCapabilities"]
pub struct SdkNexusCapabilities {
    pub temporal_failure_responses: bool,
}

impl From<NexusCapabilities> for SdkNexusCapabilities {
    fn from(external: NexusCapabilities) -> Self {
        Self {
            temporal_failure_responses: external.temporal_failure_responses,
        }
    }
}

#[derive(NifStruct, Default)]
#[module = "TemporalEngineNif.Data.NexusRequestVariant"]
pub struct SdkNexusRequestVariant {
    pub start_operation: Option<SdkNexusStartOperationRequest>,
    pub cancel_operation: Option<SdkNexusCancelOperationRequest>,
}

impl From<NexusRequestVariant> for SdkNexusRequestVariant {
    fn from(external: NexusRequestVariant) -> Self {
        match external {
            NexusRequestVariant::StartOperation(op) => Self {
                start_operation: Some(op.into()),
                ..Self::default()
            },

            NexusRequestVariant::CancelOperation(op) => Self {
                cancel_operation: Some(op.into()),
                ..Self::default()
            },
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusCancelOperationRequest"]
pub struct SdkNexusCancelOperationRequest {
    pub service: String,
    pub operation: String,
    pub operation_id: String,
    pub operation_token: String,
}

impl From<NexusCancelOperationRequest> for SdkNexusCancelOperationRequest {
    fn from(external: NexusCancelOperationRequest) -> Self {
        Self {
            service: external.service,
            operation: external.operation,
            #[allow(deprecated)]
            operation_id: external.operation_id,
            operation_token: external.operation_token,
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusStartOperationRequest"]
pub struct SdkNexusStartOperationRequest {
    pub service: String,
    pub operation: String,
    pub request_id: String,
    pub callback: String,
    pub payload: Option<SdkPayload>,
    pub callback_header: HashMap<String, String>,
    pub links: Vec<SdkNexusLink>,
}

impl From<NexusStartOperationRequest> for SdkNexusStartOperationRequest {
    fn from(external: NexusStartOperationRequest) -> Self {
        Self {
            service: external.service,
            operation: external.operation,
            request_id: external.request_id,
            callback: external.callback,
            payload: external.payload.try_into_or_none(),
            callback_header: external.callback_header,
            links: external
                .links
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.NexusLink"]
pub struct SdkNexusLink {
    pub url: String,
    pub link_type: String,
}

impl From<NexusLink> for SdkNexusLink {
    fn from(external: NexusLink) -> Self {
        Self {
            url: external.url,
            link_type: external.r#type,
        }
    }
}
