use crate::common::{SdkPayload, SdkTimestamp};
use rustler::NifStruct;
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
#[module = "Temporal.CoreSdk.Data.NexusTask"]
pub struct SdkNexusTask<'a> {
    pub request_deadline: Option<SdkTimestamp>,
    pub endpoint: String,
    pub variant: Option<SdkNexusTaskVariant<'a>>,
}

impl<'a> From<nexus::NexusTask> for SdkNexusTask<'a> {
    fn from(external: nexus::NexusTask) -> Self {
        Self {
            request_deadline: external.request_deadline.try_into_or_none(),
            endpoint: external.endpoint,
            variant: external.variant.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Default)]
#[module = "Temporal.CoreSdk.Data.NexusTaskVariant"]
pub struct SdkNexusTaskVariant<'a> {
    task: Option<SdkNexusPollTaskQueueResponse<'a>>,
    cancel_task: Option<SdkNexusCancelTask>,
}

impl<'a> From<nexus::nexus_task::Variant> for SdkNexusTaskVariant<'a> {
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
#[module = "Temporal.CoreSdk.Data.NexusPollTaskQueueResponse"]
pub struct SdkNexusPollTaskQueueResponse<'a> {
    pub task_token: Vec<u8>,
    pub request: Option<SdkNexusRequest<'a>>,
    pub poller_scaling_decision: Option<SdkPollerScalingDecision>,
    pub poller_group_id: String,
    pub poller_group_infos: Vec<SdkPollerGroupInfo>,
}

impl<'a> From<PollNexusTaskQueueResponse> for SdkNexusPollTaskQueueResponse<'a> {
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
#[module = "Temporal.CoreSdk.Data.NexusCancelTask"]
pub struct SdkNexusCancelTask {
    pub task_token: Vec<u8>,
    pub reason: i32,
}

impl From<CancelNexusTask> for SdkNexusCancelTask {
    fn from(external: CancelNexusTask) -> Self {
        Self {
            task_token: external.task_token,
            reason: external.reason,
        }
    }
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.PollerScalingDecision"]
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
#[module = "Temporal.CoreSdk.Data.PollerGroupInfo"]
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
#[module = "Temporal.CoreSdk.Data.NexusRequest"]
pub struct SdkNexusRequest<'a> {
    pub header: HashMap<String, String>,
    pub scheduled_time: Option<SdkTimestamp>,
    pub capabilities: Option<SdkNexusCapabilities>,
    pub endpoint: String,
    pub variant: Option<SdkNexusRequestVariant<'a>>,
}

impl<'a> From<NexusRequest> for SdkNexusRequest<'a> {
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
#[module = "Temporal.CoreSdk.Data.NexusCapabilities"]
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
#[module = "Temporal.CoreSdk.Data.NexusRequestVariant"]
pub struct SdkNexusRequestVariant<'a> {
    pub start_operation: Option<SdkNexusStartOperationRequest<'a>>,
    pub cancel_operation: Option<SdkNexusCancelOperationRequest>,
}

impl<'a> From<NexusRequestVariant> for SdkNexusRequestVariant<'a> {
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
#[module = "Temporal.CoreSdk.Data.NexusCancelOperationRequest"]
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
#[module = "Temporal.CoreSdk.Data.NexusStartOperationRequest"]
pub struct SdkNexusStartOperationRequest<'a> {
    pub service: String,
    pub operation: String,
    pub request_id: String,
    pub callback: String,
    pub payload: Option<SdkPayload<'a>>,
    pub callback_header: HashMap<String, String>,
    pub links: Vec<SdkNexusLink>,
}

impl<'a> From<NexusStartOperationRequest> for SdkNexusStartOperationRequest<'a> {
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
#[module = "Temporal.CoreSdk.Data.NexusLink"]
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
