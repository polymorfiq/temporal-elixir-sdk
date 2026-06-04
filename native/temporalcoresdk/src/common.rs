use std::collections::HashMap;
use rustler::{NifStruct, NifTaggedEnum};
use crate::core_workflows::SdkActivationExternalPayloadDetails;
use temporalio_sdk_common::protos::temporal::api as temporal_api;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use temporalio_sdk_common::protos::temporal::api::common as api_common;

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.Duration"]
pub struct SdkDuration {
    seconds: i64,
    nanos: i32,
}

impl From<prost_wkt_types::Duration> for SdkDuration {
    fn from(external: prost_wkt_types::Duration) -> Self {
        Self {
            seconds: external.seconds,
            nanos: external.nanos,
        }
    }
}

impl Into<prost_wkt_types::Duration> for SdkDuration {
    fn into(self) -> prost_wkt_types::Duration {
        prost_wkt_types::Duration {
            seconds: self.seconds,
            nanos: self.nanos,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.Timestamp"]
pub struct SdkTimestamp {
    seconds: i64,
    nanos: i32,
}

impl From<prost_wkt_types::Timestamp> for SdkTimestamp {
    fn from(external: prost_wkt_types::Timestamp) -> Self {
        Self {
            seconds: external.seconds,
            nanos: external.nanos,
        }
    }
}

impl Into<prost_wkt_types::Timestamp> for SdkTimestamp {
    fn into(self) -> prost_wkt_types::Timestamp {
        prost_wkt_types::Timestamp {
            seconds: self.seconds,
            nanos: self.nanos,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.Payload"]
pub struct SdkPayload {
    pub metadata: HashMap<String, Vec<u8>>,
    pub data: Vec<u8>,
    pub external_payloads: Vec<SdkActivationExternalPayloadDetails>,
}

impl From<temporal_api::common::v1::Payload> for SdkPayload {
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

impl From<&temporal_api::common::v1::Payload> for SdkPayload {
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

impl Into<temporal_api::common::v1::Payload> for SdkPayload {
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

impl Into<temporal_api::common::v1::Payload> for &SdkPayload {
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
#[module = "Temporal.CoreSdk.Data.Payloads"]
pub struct SdkPayloads {
    pub payloads: Vec<SdkPayload>,
}

impl From<temporal_api::common::v1::Payloads> for SdkPayloads {
    fn from(external: temporal_api::common::v1::Payloads) -> Self {
        Self {
            payloads: external.payloads.iter().map(|val| val.into()).collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Payloads> for SdkPayloads {
    fn into(self) -> temporal_api::common::v1::Payloads {
        temporal_api::common::v1::Payloads {
            payloads: self.payloads.iter().map(|val| val.clone().into()).collect(),
        }
    }
}

impl Into<temporal_api::common::v1::Payloads> for &SdkPayloads {
    fn into(self) -> temporal_api::common::v1::Payloads {
        temporal_api::common::v1::Payloads {
            payloads: self.payloads.iter().map(|val| val.clone().into()).collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.Priority"]
pub struct SdkPriority {
    pub priority_key: i32,
    pub fairness_key: String,
    pub fairness_weight: f32,
}

impl From<temporal_api::common::v1::Priority> for SdkPriority {
    fn from(external: temporal_api::common::v1::Priority) -> Self {
        Self {
            priority_key: external.priority_key,
            fairness_key: external.fairness_key,
            fairness_weight: external.fairness_weight,
        }
    }
}

impl Into<temporal_api::common::v1::Priority> for SdkPriority {
    fn into(self) -> temporal_api::common::v1::Priority {
        temporal_api::common::v1::Priority {
            priority_key: self.priority_key,
            fairness_key: self.fairness_key,
            fairness_weight: self.fairness_weight,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.RetryPolicy"]
pub struct SdkRetryPolicy {
    pub initial_interval: Option<SdkDuration>,
    pub backoff_coefficient: f64,
    pub maximum_interval: Option<SdkDuration>,
    pub maximum_attempts: i32,
    pub non_retryable_error_types: Vec<String>,
}

impl From<temporal_api::common::v1::RetryPolicy> for SdkRetryPolicy {
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

impl Into<temporal_api::common::v1::RetryPolicy> for SdkRetryPolicy {
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
#[module = "Temporal.CoreSdk.Data.Header"]
pub struct SdkHeader {
    fields: HashMap<String, SdkPayload>,
}

impl From<api_common::v1::Header> for SdkHeader {
    fn from(external: api_common::v1::Header) -> Self {
        Self {
            fields: external.fields.into_iter().map(|(k, v)| (k, v.into())).collect(),
        }
    }
}

impl Into<api_common::v1::Header> for SdkHeader {
    fn into(self) -> api_common::v1::Header {
        api_common::v1::Header {
            fields: self.fields.into_iter().map(|(k, v)| (k, v.into())).collect(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.Link"]
pub struct SdkLink {
    variant: Option<SdkLinkVariant>
}

impl From<api_common::v1::Link> for SdkLink {
    fn from(external: api_common::v1::Link) -> Self {
        Self {
            variant: external.variant.try_into_or_none(),
        }
    }
}

impl Into<api_common::v1::Link> for SdkLink {
    fn into(self) -> api_common::v1::Link {
        api_common::v1::Link {
            variant: self.variant.try_into_or_none(),
        }
    }
}

#[derive(NifTaggedEnum, Clone)]
pub enum SdkLinkVariant {
    WorkflowEvent(SdkLinkWorkflowEvent),
    BatchJob(SdkLinkBatchJob),
    Activity(SdkLinkActivity),
    NexusOperation(SdkLinkNexusOperation)
}

impl From<api_common::v1::link::Variant> for SdkLinkVariant {
    fn from(external: api_common::v1::link::Variant) -> Self {
        match external {
            api_common::v1::link::Variant::WorkflowEvent(variant) => Self::WorkflowEvent(variant.into()),
            api_common::v1::link::Variant::BatchJob(variant) => Self::BatchJob(variant.into()),
            api_common::v1::link::Variant::Activity(variant) => Self::Activity(variant.into()),
            api_common::v1::link::Variant::NexusOperation(variant) => Self::NexusOperation(variant.into()),
        }
    }
}

impl Into<api_common::v1::link::Variant> for SdkLinkVariant {
    fn into(self) -> api_common::v1::link::Variant {
        match self {
            Self::WorkflowEvent(variant) => api_common::v1::link::Variant::WorkflowEvent(variant.into()),
            Self::BatchJob(variant) => api_common::v1::link::Variant::BatchJob(variant.into()),
            Self::Activity(variant) => api_common::v1::link::Variant::Activity(variant.into()),
            Self::NexusOperation(variant) => api_common::v1::link::Variant::NexusOperation(variant.into()),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowEvent"]
pub struct SdkLinkWorkflowEvent {
    namespace: String,
    workflow_id: String,
    run_id: String,
    reference: Option<SdkWorkflowEventReference>
}

impl From<api_common::v1::link::WorkflowEvent> for SdkLinkWorkflowEvent {
    fn from(external: api_common::v1::link::WorkflowEvent) -> Self {
        Self {
            namespace: external.namespace,
            workflow_id: external.workflow_id,
            run_id: external.run_id,
            reference: external.reference.try_into_or_none(),
        }
    }
}

impl Into<api_common::v1::link::WorkflowEvent> for SdkLinkWorkflowEvent {
    fn into(self) -> api_common::v1::link::WorkflowEvent {
        api_common::v1::link::WorkflowEvent {
            namespace: self.namespace,
            workflow_id: self.workflow_id,
            run_id: self.run_id,
            reference: self.reference.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.LinkActivity"]
pub struct SdkLinkBatchJob {
    job_id: String
}

impl From<api_common::v1::link::BatchJob> for SdkLinkBatchJob {
    fn from(external: api_common::v1::link::BatchJob) -> Self {
        Self {
            job_id: external.job_id,
        }
    }
}

impl Into<api_common::v1::link::BatchJob> for SdkLinkBatchJob {
    fn into(self) -> api_common::v1::link::BatchJob {
        api_common::v1::link::BatchJob {
            job_id: self.job_id,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.LinkActivity"]
pub struct SdkLinkActivity {
    namespace: String,
    activity_id: String,
    run_id: String
}

impl From<api_common::v1::link::Activity> for SdkLinkActivity {
    fn from(external: api_common::v1::link::Activity) -> Self {
        Self {
            namespace: external.namespace,
            activity_id: external.activity_id,
            run_id: external.run_id
        }
    }
}

impl Into<api_common::v1::link::Activity> for SdkLinkActivity {
    fn into(self) -> api_common::v1::link::Activity {
        api_common::v1::link::Activity {
            namespace: self.namespace,
            activity_id: self.activity_id,
            run_id: self.run_id
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.LinkNexusOperation"]
pub struct SdkLinkNexusOperation {
    namespace: String,
    operation_id: String,
    run_id: String,
}

impl From<api_common::v1::link::NexusOperation> for SdkLinkNexusOperation {
    fn from(external: api_common::v1::link::NexusOperation) -> Self {
        Self {
            namespace: external.namespace,
            operation_id: external.operation_id,
            run_id: external.run_id,
        }
    }
}

impl Into<api_common::v1::link::NexusOperation> for SdkLinkNexusOperation {
    fn into(self) -> api_common::v1::link::NexusOperation {
        api_common::v1::link::NexusOperation {
            namespace: self.namespace,
            operation_id: self.operation_id,
            run_id: self.run_id,
        }
    }
}

#[derive(NifTaggedEnum, Clone)]
pub enum SdkWorkflowEventReference {
    EventRef(SdkWorkflowEventReferenceEvent),
    RequestIdRef(SdkWorkflowEventReferenceRequest)
}


impl From<api_common::v1::link::workflow_event::Reference> for SdkWorkflowEventReference {
    fn from(external: api_common::v1::link::workflow_event::Reference) -> Self {
        match external {
            api_common::v1::link::workflow_event::Reference::EventRef(variant) => Self::EventRef(variant.into()),
            api_common::v1::link::workflow_event::Reference::RequestIdRef(variant) => Self::RequestIdRef(variant.into()),
        }
    }
}

impl Into<api_common::v1::link::workflow_event::Reference> for SdkWorkflowEventReference {
    fn into(self) -> api_common::v1::link::workflow_event::Reference {
        match self {
            Self::EventRef(variant) => api_common::v1::link::workflow_event::Reference::EventRef(variant.into()),
            Self::RequestIdRef(variant) => api_common::v1::link::workflow_event::Reference::RequestIdRef(variant.into()),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowEventReferenceEvent"]
pub struct SdkWorkflowEventReferenceEvent {
    event_id: i64,
    event_type: i32
}

impl From<api_common::v1::link::workflow_event::EventReference> for SdkWorkflowEventReferenceEvent {
    fn from(external: api_common::v1::link::workflow_event::EventReference) -> Self {
        Self {
            event_id: external.event_id,
            event_type: external.event_type
        }
    }
}

impl Into<api_common::v1::link::workflow_event::EventReference> for SdkWorkflowEventReferenceEvent {
    fn into(self) -> api_common::v1::link::workflow_event::EventReference {
        api_common::v1::link::workflow_event::EventReference {
            event_id: self.event_id,
            event_type: self.event_type
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkflowEventReferenceRequest"]
pub struct SdkWorkflowEventReferenceRequest {
    request_id: String,
    event_type: i32
}

impl From<api_common::v1::link::workflow_event::RequestIdReference> for SdkWorkflowEventReferenceRequest {
    fn from(external: api_common::v1::link::workflow_event::RequestIdReference) -> Self {
        Self {
            request_id: external.request_id,
            event_type: external.event_type
        }
    }
}

impl Into<api_common::v1::link::workflow_event::RequestIdReference> for SdkWorkflowEventReferenceRequest {
    fn into(self) -> api_common::v1::link::workflow_event::RequestIdReference {
        api_common::v1::link::workflow_event::RequestIdReference {
            request_id: self.request_id,
            event_type: self.event_type
        }
    }
}