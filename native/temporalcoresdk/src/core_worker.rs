use crate::common::SdkDuration;
use rustler::{NifStruct, NifTaggedEnum, NifUnitEnum, Resource};
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
#[module = "TemporalEngineNif.Data.WorkerOpts"]
pub struct SdkWorkerOpts {
    pub namespace: String,
    pub task_queue: String,
    pub deployment_options: SdkWorkerDeploymentOpts,
    pub max_cached_workflows: u32,
    pub nonsticky_to_sticky_poll_ratio: f32,
    pub enable_workflows: bool,
    pub enable_local_activities: bool,
    pub enable_remote_activities: bool,
    pub enable_nexus: bool,
    pub sticky_queue_schedule_to_start_timeout: SdkDuration,
    pub max_heartbeat_throttle_interval: SdkDuration,
    pub default_heartbeat_throttle_interval: SdkDuration,
    pub graceful_shutdown_period: Option<SdkDuration>,
    pub nondeterminism_as_workflow_fail: bool,
    pub tuner: SdkWorkerTunerOpts,
    pub nondeterminism_as_workflow_fail_for_types: Vec<String>,
    pub plugins: Vec<String>,
    pub max_worker_activities_per_second: Option<f64>,
    pub max_task_queue_activities_per_second: Option<f64>,
    pub identity_override: Option<String>,
    pub workflow_task_poller_behavior: SdkWorkerPollerOpts,
    pub activity_task_poller_behavior: SdkWorkerPollerOpts,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkerDeploymentOpts"]
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
#[module = "TemporalEngineNif.Data.WorkerDeploymentVersion"]
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

#[derive(NifTaggedEnum, Clone)]
pub enum SdkWorkerPollerOpts {
    Autoscaling(SdkWorkerPollerAutoscalingOpts),
    SimpleMaximum(SdkWorkerPollerSimpleMaximumOpts),
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkerPollerAutoscalingOpts"]
pub struct SdkWorkerPollerAutoscalingOpts {
    pub minimum: u32,
    pub maximum: u32,
    pub initial: u32,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkerPollerSimpleMaximumOpts"]
pub struct SdkWorkerPollerSimpleMaximumOpts {
    pub simple_maximum: u32,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkerTunerOpts"]
pub struct SdkWorkerTunerOpts {
    pub workflow_slot_supplier: SdkWorkerSlotSupplierOpts,
    pub activity_slot_supplier: SdkWorkerSlotSupplierOpts,
    pub local_activity_slot_supplier: SdkWorkerSlotSupplierOpts,
}

#[derive(NifTaggedEnum, Clone)]
pub enum SdkWorkerSlotSupplierOpts {
    FixedSize(u32),
    ResourceBased(SdkWorkerTunerResourceOpts),
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngineNif.Data.WorkerTunerResourceOpts"]
pub struct SdkWorkerTunerResourceOpts {
    pub target_mem_usage: f64,
    pub target_cpu_usage: f64,
    pub min_slots: u32,
    pub max_slots: u32,
    pub ramp_throttle: f64,
}
