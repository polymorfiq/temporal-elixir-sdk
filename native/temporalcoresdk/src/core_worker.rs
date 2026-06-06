use rustler::{NifStruct, NifTaggedEnum, Resource};
use temporalio_sdk_common::worker::{WorkerDeploymentOptions, WorkerDeploymentVersion};
use temporalio_sdk_core::Worker;

pub struct ElixirWorker {
    #[allow(dead_code)]
    pub worker: Option<Worker>,
}

#[rustler::resource_impl]
impl Resource for ElixirWorker {}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkerOpts"]
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
    pub sticky_queue_schedule_to_start_timeout_secs: f64,
    pub max_heartbeat_throttle_interval_secs: f64,
    pub default_heartbeat_throttle_interval_secs: f64,
    pub graceful_shutdown_period_secs: f64,
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
#[module = "Temporal.CoreSdk.Data.WorkerDeploymentOpts"]
pub struct SdkWorkerDeploymentOpts {
    pub version: SdkWorkerDeploymentVersion,
    pub use_worker_versioning: bool,
    pub default_versioning_behavior: Option<u32>,
}

impl From<WorkerDeploymentOptions> for SdkWorkerDeploymentOpts {
    fn from(external: WorkerDeploymentOptions) -> Self {
        Self {
            version: external.version.into(),
            use_worker_versioning: external.use_worker_versioning,
            default_versioning_behavior: match external.default_versioning_behavior {
                Some(behavior) => Some(behavior as u32),
                None => None,
            },
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkerDeploymentVersion"]
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
#[module = "Temporal.CoreSdk.Data.WorkerPollerAutoscalingOpts"]
pub struct SdkWorkerPollerAutoscalingOpts {
    pub minimum: u32,
    pub maximum: u32,
    pub initial: u32,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts"]
pub struct SdkWorkerPollerSimpleMaximumOpts {
    pub simple_maximum: u32,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.WorkerTunerOpts"]
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
#[module = "Temporal.CoreSdk.Data.WorkerTunerResourceOpts"]
pub struct SdkWorkerTunerResourceOpts {
    pub target_mem_usage: f64,
    pub target_cpu_usage: f64,
    pub min_slots: u32,
    pub max_slots: u32,
    pub ramp_throttle: f64,
}
