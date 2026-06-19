use crate::common::SdkDuration;
use rustler::{NifStruct, NifUnitEnum, NifUntaggedEnum, Resource};
use std::collections::HashMap;
use temporalio_sdk_common::protos::temporal::api::enums::v1::VersioningBehavior;
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use temporalio_sdk_common::worker::{WorkerDeploymentOptions, WorkerDeploymentVersion};
use temporalio_sdk_core::Worker;

pub struct ElixirWorker {
    #[allow(dead_code)]
    pub worker: Option<Worker>,
}

#[rustler::resource_impl]
impl Resource for ElixirWorker {}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.WorkerConfig"]
pub struct SdkWorkerConfig {
    pub id: String,
    pub namespace: String,
    pub task_queue: String,
    pub client_identity_override: Option<String>,
    pub tuner: SdkWorkerTunerOpts,
    pub workflow_task_poller_behavior: SdkWorkerPollerOpts,
    pub nonsticky_to_sticky_poll_ratio: f32,
    pub activity_task_poller_behavior: SdkWorkerPollerOpts,
    pub nexus_task_poller_behavior: SdkWorkerPollerOpts,
    pub task_types: SdkWorkerTaskTypesOpts,
    pub sticky_queue_schedule_to_start_timeout: SdkDuration,
    pub max_heartbeat_throttle_interval: SdkDuration,
    pub default_heartbeat_throttle_interval: SdkDuration,
    pub max_task_queue_activities_per_second: Option<f64>,
    pub max_worker_activities_per_second: Option<f64>,
    pub ignore_evicts_on_shutdown: bool,
    pub graceful_shutdown_period: Option<SdkDuration>,
    pub local_timeout_buffer_for_activities: SdkDuration,
    pub max_outstanding_workflow_tasks: Option<u32>,
    pub max_outstanding_activities: Option<u32>,
    pub max_outstanding_local_activities: Option<u32>,
    pub max_outstanding_nexus_tasks: Option<u32>,
    pub workflow_failure_errors: Vec<SdkWorkflowFailureErrors>,
    pub workflow_types_to_failure_errors: HashMap<String, SdkWorkflowFailureErrors>,
    pub versioning_strategy: SdkWorkerDeploymentOpts,
    pub max_cached_workflows: u32,
    pub nondeterminism_as_workflow_fail: bool,
    pub nondeterminism_as_workflow_fail_for_types: Vec<String>,
    pub plugins: Vec<SdkPluginInfo>,
    pub skip_client_worker_set_check: bool,
    pub storage_drivers: Vec<SdkStorageDriverInfo>,
}

#[repr(i32)]
#[derive(NifUnitEnum, Clone)]
pub enum SdkWorkflowFailureErrors {
    Nondeterminism = 0,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.WorkerTaskTypes"]
pub struct SdkWorkerTaskTypesOpts {
    pub enable_workflows: bool,
    pub enable_local_activities: bool,
    pub enable_remote_activities: bool,
    pub enable_nexus: bool,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.PluginInfo"]
pub struct SdkPluginInfo {
    pub name: String,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.StorageDriverInfo"]
pub struct SdkStorageDriverInfo {
    pub r#type: String,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.WorkerDeploymentOptions"]
pub struct SdkWorkerDeploymentOpts {
    pub version: SdkWorkerDeploymentVersion,
    pub use_worker_versioning: bool,
    pub default_versioning_behavior: Option<SdkDeploymentVersioningBehavior>,
}

impl From<WorkerDeploymentOptions> for SdkWorkerDeploymentOpts {
    fn from(external: WorkerDeploymentOptions) -> Self {
        Self {
            version: external.version.into(),
            use_worker_versioning: external.use_worker_versioning,
            default_versioning_behavior: external.default_versioning_behavior.try_into_or_none(),
        }
    }
}

#[repr(i32)]
#[derive(NifUnitEnum, Clone)]
pub enum SdkDeploymentVersioningBehavior {
    Unspecified = 0,
    Pinned = 1,
    AutoUpgrade = 2,
}

impl Into<i32> for SdkDeploymentVersioningBehavior {
    fn into(self) -> i32 {
        match self {
            Self::Unspecified => 0,
            Self::Pinned => 1,
            Self::AutoUpgrade => 2,
        }
    }
}

impl From<i32> for SdkDeploymentVersioningBehavior {
    fn from(intent: i32) -> SdkDeploymentVersioningBehavior {
        match intent {
            0 => Self::Unspecified,
            1 => Self::Pinned,
            2 => Self::AutoUpgrade,
            _ => Self::Unspecified,
        }
    }
}

impl From<VersioningBehavior> for SdkDeploymentVersioningBehavior {
    fn from(intent: VersioningBehavior) -> SdkDeploymentVersioningBehavior {
        match intent {
            VersioningBehavior::Unspecified => Self::Unspecified,
            VersioningBehavior::Pinned => Self::Pinned,
            VersioningBehavior::AutoUpgrade => Self::AutoUpgrade,
        }
    }
}

impl Into<VersioningBehavior> for SdkDeploymentVersioningBehavior {
    fn into(self) -> VersioningBehavior {
        match self {
            Self::Unspecified => VersioningBehavior::Unspecified,
            Self::Pinned => VersioningBehavior::Pinned,
            Self::AutoUpgrade => VersioningBehavior::AutoUpgrade,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Data.Common.WorkerDeploymentVersion"]
pub struct SdkWorkerDeploymentVersion {
    pub build_id: String,
    pub deployment_name: String,
}

impl From<temporalio_sdk_common::protos::coresdk::common::WorkerDeploymentVersion>
    for SdkWorkerDeploymentVersion
{
    fn from(
        external: temporalio_sdk_common::protos::coresdk::common::WorkerDeploymentVersion,
    ) -> Self {
        Self {
            build_id: external.build_id,
            deployment_name: external.deployment_name,
        }
    }
}

impl From<WorkerDeploymentVersion> for SdkWorkerDeploymentVersion {
    fn from(external: WorkerDeploymentVersion) -> Self {
        Self {
            build_id: external.build_id,
            deployment_name: external.deployment_name,
        }
    }
}

#[derive(NifUntaggedEnum, Clone)]
pub enum SdkWorkerPollerOpts {
    Autoscaling(SdkWorkerPollerAutoscalingOpts),
    SimpleMaximum(SdkWorkerPollerSimpleMaximumOpts),
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.AutoscalingPoller"]
pub struct SdkWorkerPollerAutoscalingOpts {
    pub minimum: u32,
    pub maximum: u32,
    pub initial: u32,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.SimpleMaximumPoller"]
pub struct SdkWorkerPollerSimpleMaximumOpts {
    pub simple_maximum: u32,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.WorkerTuner"]
pub struct SdkWorkerTunerOpts {
    pub workflow_slot_supplier: SdkWorkerSlotSupplierOpts,
    pub activity_slot_supplier: SdkWorkerSlotSupplierOpts,
    pub local_activity_slot_supplier: SdkWorkerSlotSupplierOpts,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.FixedSlotSupplier"]
pub struct SdkFixedSlotSupplierOpts {
    pub size: u32,
}

#[derive(NifUntaggedEnum, Clone)]
pub enum SdkWorkerSlotSupplierOpts {
    FixedSize(SdkFixedSlotSupplierOpts),
    ResourceBased(SdkWorkerTunerResourceOpts),
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Config.ResourceBasedSlotSupplier"]
pub struct SdkWorkerTunerResourceOpts {
    pub target_mem_usage: f64,
    pub target_cpu_usage: f64,
    pub min_slots: u32,
    pub max_slots: u32,
    pub ramp_throttle: f64,
}
