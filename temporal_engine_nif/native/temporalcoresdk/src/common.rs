use crate::data::common::SdkPayload;
use rustler::{NifRecord, NifTaggedEnum};
use std::collections::HashMap;
use temporalio_sdk_common::protos::temporal::api as temporal_api;
use temporalio_sdk_common::protos::temporal::api::common as api_common;
use temporalio_sdk_common::protos::temporal::api::common::v1::Callback;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;

#[derive(Debug, NifRecord, Clone)]
#[tag = "duration"]
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

impl From<core::time::Duration> for SdkDuration {
    fn from(external: core::time::Duration) -> Self {
        Self {
            seconds: external.as_secs() as i64,
            nanos: external.subsec_nanos() as i32,
        }
    }
}

impl Into<core::time::Duration> for SdkDuration {
    fn into(self) -> core::time::Duration {
        core::time::Duration::new(self.seconds as u64, self.nanos as u32)
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "timestamp"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "payloads"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "priority"]
pub struct SdkPriority {
    pub priority_key: Option<i32>,
    pub fairness_key: Option<String>,
    pub fairness_weight: Option<f32>,
}

impl From<temporal_api::common::v1::Priority> for SdkPriority {
    fn from(external: temporal_api::common::v1::Priority) -> Self {
        Self {
            priority_key: Some(external.priority_key),
            fairness_key: Some(external.fairness_key),
            fairness_weight: Some(external.fairness_weight),
        }
    }
}

impl From<temporalio_sdk_client::Priority> for SdkPriority {
    fn from(external: temporalio_sdk_client::Priority) -> Self {
        Self {
            priority_key: match external.priority_key {
                None => None,
                Some(val) => Some(val as i32),
            },
            fairness_key: external.fairness_key,
            fairness_weight: external.fairness_weight,
        }
    }
}

impl Into<temporal_api::common::v1::Priority> for SdkPriority {
    fn into(self) -> temporal_api::common::v1::Priority {
        temporal_api::common::v1::Priority {
            priority_key: self.priority_key.unwrap_or(1),
            fairness_key: self.fairness_key.unwrap_or("".to_string()),
            fairness_weight: self.fairness_weight.unwrap_or(1.0),
        }
    }
}

impl Into<temporalio_sdk_client::Priority> for SdkPriority {
    fn into(self) -> temporalio_sdk_client::Priority {
        temporalio_sdk_client::Priority {
            priority_key: match self.priority_key {
                None => None,
                Some(val) => Some(val as u32),
            },
            fairness_key: self.fairness_key,
            fairness_weight: self.fairness_weight,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "retry_policy"]
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "header"]
pub struct SdkHeader {
    fields: HashMap<String, SdkPayload>,
}

impl From<api_common::v1::Header> for SdkHeader {
    fn from(external: api_common::v1::Header) -> Self {
        Self {
            fields: external
                .fields
                .into_iter()
                .map(|(k, v)| (k, v.into()))
                .collect(),
        }
    }
}

impl Into<api_common::v1::Header> for SdkHeader {
    fn into(self) -> api_common::v1::Header {
        api_common::v1::Header {
            fields: self
                .fields
                .into_iter()
                .map(|(k, v)| (k, v.into()))
                .collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "link"]
pub struct SdkLink {
    variant: Option<SdkLinkVariant>,
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

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkLinkVariant {
    WorkflowEvent(SdkLinkWorkflowEvent),
    BatchJob(SdkLinkBatchJob),
    Activity(SdkLinkActivity),
    NexusOperation(SdkLinkNexusOperation),
}

impl From<api_common::v1::link::Variant> for SdkLinkVariant {
    fn from(external: api_common::v1::link::Variant) -> Self {
        match external {
            api_common::v1::link::Variant::WorkflowEvent(variant) => {
                Self::WorkflowEvent(variant.into())
            }
            api_common::v1::link::Variant::BatchJob(variant) => Self::BatchJob(variant.into()),
            api_common::v1::link::Variant::Activity(variant) => Self::Activity(variant.into()),
            api_common::v1::link::Variant::NexusOperation(variant) => {
                Self::NexusOperation(variant.into())
            }
        }
    }
}

impl Into<api_common::v1::link::Variant> for SdkLinkVariant {
    fn into(self) -> api_common::v1::link::Variant {
        match self {
            Self::WorkflowEvent(variant) => {
                api_common::v1::link::Variant::WorkflowEvent(variant.into())
            }
            Self::BatchJob(variant) => api_common::v1::link::Variant::BatchJob(variant.into()),
            Self::Activity(variant) => api_common::v1::link::Variant::Activity(variant.into()),
            Self::NexusOperation(variant) => {
                api_common::v1::link::Variant::NexusOperation(variant.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "link_workflow_event"]
pub struct SdkLinkWorkflowEvent {
    namespace: String,
    workflow_id: String,
    run_id: String,
    reference: Option<SdkWorkflowEventReference>,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "link_batch_job"]
pub struct SdkLinkBatchJob {
    job_id: String,
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

#[derive(Debug, NifRecord, Clone)]
#[tag = "link_activity"]
pub struct SdkLinkActivity {
    namespace: String,
    activity_id: String,
    run_id: String,
}

impl From<api_common::v1::link::Activity> for SdkLinkActivity {
    fn from(external: api_common::v1::link::Activity) -> Self {
        Self {
            namespace: external.namespace,
            activity_id: external.activity_id,
            run_id: external.run_id,
        }
    }
}

impl Into<api_common::v1::link::Activity> for SdkLinkActivity {
    fn into(self) -> api_common::v1::link::Activity {
        api_common::v1::link::Activity {
            namespace: self.namespace,
            activity_id: self.activity_id,
            run_id: self.run_id,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "link_nexus_operation"]
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

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkWorkflowEventReference {
    EventRef(SdkWorkflowEventReferenceEvent),
    RequestIdRef(SdkWorkflowEventReferenceRequest),
}

impl From<api_common::v1::link::workflow_event::Reference> for SdkWorkflowEventReference {
    fn from(external: api_common::v1::link::workflow_event::Reference) -> Self {
        match external {
            api_common::v1::link::workflow_event::Reference::EventRef(variant) => {
                Self::EventRef(variant.into())
            }
            api_common::v1::link::workflow_event::Reference::RequestIdRef(variant) => {
                Self::RequestIdRef(variant.into())
            }
        }
    }
}

impl Into<api_common::v1::link::workflow_event::Reference> for SdkWorkflowEventReference {
    fn into(self) -> api_common::v1::link::workflow_event::Reference {
        match self {
            Self::EventRef(variant) => {
                api_common::v1::link::workflow_event::Reference::EventRef(variant.into())
            }
            Self::RequestIdRef(variant) => {
                api_common::v1::link::workflow_event::Reference::RequestIdRef(variant.into())
            }
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "reference_event"]
pub struct SdkWorkflowEventReferenceEvent {
    event_id: i64,
    event_type: i32,
}

impl From<api_common::v1::link::workflow_event::EventReference> for SdkWorkflowEventReferenceEvent {
    fn from(external: api_common::v1::link::workflow_event::EventReference) -> Self {
        Self {
            event_id: external.event_id,
            event_type: external.event_type,
        }
    }
}

impl Into<api_common::v1::link::workflow_event::EventReference> for SdkWorkflowEventReferenceEvent {
    fn into(self) -> api_common::v1::link::workflow_event::EventReference {
        api_common::v1::link::workflow_event::EventReference {
            event_id: self.event_id,
            event_type: self.event_type,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "reference_request"]
pub struct SdkWorkflowEventReferenceRequest {
    request_id: String,
    event_type: i32,
}

impl From<api_common::v1::link::workflow_event::RequestIdReference>
    for SdkWorkflowEventReferenceRequest
{
    fn from(external: api_common::v1::link::workflow_event::RequestIdReference) -> Self {
        Self {
            request_id: external.request_id,
            event_type: external.event_type,
        }
    }
}

impl Into<api_common::v1::link::workflow_event::RequestIdReference>
    for SdkWorkflowEventReferenceRequest
{
    fn into(self) -> api_common::v1::link::workflow_event::RequestIdReference {
        api_common::v1::link::workflow_event::RequestIdReference {
            request_id: self.request_id,
            event_type: self.event_type,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "callback"]
pub struct SdkCallback {
    pub links: Vec<SdkLink>,
    pub variant: Option<SdkCallbackVariant>,
}

impl From<Callback> for SdkCallback {
    fn from(external: Callback) -> Self {
        Self {
            links: external
                .links
                .iter()
                .map(|val| val.clone().into())
                .collect(),
            variant: external.variant.try_into_or_none(),
        }
    }
}

impl Into<Callback> for SdkCallback {
    fn into(self) -> Callback {
        Callback {
            links: self.links.iter().map(|val| val.clone().into()).collect(),
            variant: self.variant.try_into_or_none(),
        }
    }
}

#[derive(Debug, NifTaggedEnum, Clone)]
pub enum SdkCallbackVariant {
    Nexus(SdkCallbackNexus),
    Internal(SdkCallbackInternal),
}

impl From<api_common::v1::callback::Variant> for SdkCallbackVariant {
    fn from(external: api_common::v1::callback::Variant) -> Self {
        match external {
            api_common::v1::callback::Variant::Nexus(cb) => Self::Nexus(cb.into()),
            api_common::v1::callback::Variant::Internal(cb) => Self::Internal(cb.into()),
        }
    }
}

impl Into<api_common::v1::callback::Variant> for SdkCallbackVariant {
    fn into(self) -> api_common::v1::callback::Variant {
        match self {
            Self::Nexus(cb) => api_common::v1::callback::Variant::Nexus(cb.into()),
            Self::Internal(cb) => api_common::v1::callback::Variant::Internal(cb.into()),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "callback_nexus"]
pub struct SdkCallbackNexus {
    pub url: String,
    pub header: HashMap<String, String>,
}

impl From<api_common::v1::callback::Nexus> for SdkCallbackNexus {
    fn from(external: api_common::v1::callback::Nexus) -> Self {
        Self {
            url: external.url,
            header: external.header,
        }
    }
}

impl Into<api_common::v1::callback::Nexus> for SdkCallbackNexus {
    fn into(self) -> api_common::v1::callback::Nexus {
        api_common::v1::callback::Nexus {
            url: self.url,
            header: self.header,
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "callback_internal"]
pub struct SdkCallbackInternal {
    pub data: Vec<u8>,
}

impl From<api_common::v1::callback::Internal> for SdkCallbackInternal {
    fn from(external: api_common::v1::callback::Internal) -> Self {
        Self {
            data: external.data,
        }
    }
}

impl Into<api_common::v1::callback::Internal> for SdkCallbackInternal {
    fn into(self) -> api_common::v1::callback::Internal {
        api_common::v1::callback::Internal { data: self.data }
    }
}
