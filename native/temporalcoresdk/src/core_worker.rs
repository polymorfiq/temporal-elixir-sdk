use crate::core_client::ElixirClient;
use crate::core_runtime::ElixirRuntime;
use crate::core_workflows::{SdkWorkflowActivation};
use rustler::{Env, LocalPid, NifStruct, OwnedEnv, Resource, ResourceArc};
use std::collections::{HashMap, HashSet};
use std::sync::Arc;
use std::time::Duration;
use temporalio_sdk_common::protos::temporal::api::enums::v1::VersioningBehavior;
use temporalio_sdk_common::protos::temporal::api::worker::v1::PluginInfo;
use temporalio_sdk_common::worker::{
    WorkerDeploymentOptions, WorkerDeploymentVersion, WorkerTaskTypes,
};
use temporalio_sdk_core::{
    init_worker, PollerBehavior, ResourceBasedSlotsOptions, ResourceSlotOptions, SlotKind,
    SlotSupplierOptions, TunerHolder, TunerHolderOptions, Worker, WorkerConfig,
    WorkerVersioningStrategy, WorkflowErrorType,
};
use tokio::runtime::Runtime;
use tokio::sync::Mutex;
use tracing::error;
use crate::core_activites::SdkActivityTask;
use crate::core_nexus::SdkNexusTask;

pub struct ElixirWorker {
    #[allow(dead_code)]
    pub worker: Mutex<Worker>,
}

#[rustler::resource_impl]
impl Resource for ElixirWorker {}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerOpts"]
struct SdkWorkerOpts {
    namespace: String,
    task_queue: String,
    deployment_options: SdkWorkerDeploymentOpts,
    max_cached_workflows: u32,
    nonsticky_to_sticky_poll_ratio: f32,
    enable_workflows: bool,
    enable_local_activities: bool,
    enable_remote_activities: bool,
    enable_nexus: bool,
    sticky_queue_schedule_to_start_timeout_secs: f64,
    max_heartbeat_throttle_interval_secs: f64,
    default_heartbeat_throttle_interval_secs: f64,
    graceful_shutdown_period_secs: f64,
    nondeterminism_as_workflow_fail: bool,
    tuner: SdkWorkerTunerOpts,
    nondeterminism_as_workflow_fail_for_types: Vec<String>,
    plugins: Vec<String>,
    max_worker_activities_per_second: Option<f64>,
    max_task_queue_activities_per_second: Option<f64>,
    identity_override: Option<String>,
    workflow_task_poller_behavior: Option<SdkWorkerPollerOpts>,
    activity_task_poller_behavior: Option<SdkWorkerPollerOpts>,
}

#[derive(NifStruct)]
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
                None => None
            }
        }
    }
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerDeploymentVersion"]
pub struct SdkWorkerDeploymentVersion {
    pub build_id: String,
    pub deployment_name: String,
}

impl From<temporalio_sdk_common::protos::coresdk::common::WorkerDeploymentVersion> for SdkWorkerDeploymentVersion {
    fn from(external: temporalio_sdk_common::protos::coresdk::common::WorkerDeploymentVersion) -> Self {
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

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerPollerOpts"]
struct SdkWorkerPollerOpts {
    autoscaling: Option<SdkWorkerPollerAutoscalingOpts>,
    simple_maximum: Option<SdkWorkerPollerSimpleMaximumOpts>,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerPollerAutoscalingOpts"]
struct SdkWorkerPollerAutoscalingOpts {
    minimum: u32,
    maximum: u32,
    initial: u32,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerPollerSimpleMaximumOpts"]
struct SdkWorkerPollerSimpleMaximumOpts {
    simple_maximum: u32,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerTunerOpts"]
struct SdkWorkerTunerOpts {
    workflow_slot_supplier: SdkWorkerSlotSupplierOpts,
    activity_slot_supplier: SdkWorkerSlotSupplierOpts,
    local_activity_slot_supplier: SdkWorkerSlotSupplierOpts,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerSlotSupplierOpts"]
struct SdkWorkerSlotSupplierOpts {
    fixed_size: Option<u32>,
    resource_based: Option<SdkWorkerTunerResourceOpts>,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.WorkerTunerResourceOpts"]
struct SdkWorkerTunerResourceOpts {
    target_mem_usage: f64,
    target_cpu_usage: f64,
    min_slots: u32,
    max_slots: u32,
    ramp_throttle: f64,
}

#[rustler::nif]
fn _create_worker(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    options: SdkWorkerOpts,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let config = WorkerConfig::builder()
        .namespace(options.namespace)
        .task_queue(options.task_queue)
        .versioning_strategy({
            let dopts = options.deployment_options;
            WorkerVersioningStrategy::WorkerDeploymentBased(WorkerDeploymentOptions {
                version: WorkerDeploymentVersion {
                    deployment_name: dopts.version.deployment_name,
                    build_id: dopts.version.build_id,
                },
                use_worker_versioning: dopts.use_worker_versioning,
                default_versioning_behavior: {
                    match dopts.default_versioning_behavior {
                        None => None,
                        Some(0) => None,
                        Some(1) => Some(VersioningBehavior::Pinned),
                        Some(2) => Some(VersioningBehavior::AutoUpgrade),
                        Some(behavior) => {
                            return Err(format!(
                                "Unknown default versioning behavior: {}",
                                behavior
                            ))
                        }
                    }
                },
            })
        })
        .maybe_client_identity_override(options.identity_override)
        .max_cached_workflows(options.max_cached_workflows as usize)
        .workflow_task_poller_behavior({
            match options.workflow_task_poller_behavior {
                Some(SdkWorkerPollerOpts {
                    autoscaling: Some(autoscaling),
                    ..
                }) => PollerBehavior::Autoscaling {
                    minimum: autoscaling.minimum as usize,
                    maximum: autoscaling.maximum as usize,
                    initial: autoscaling.initial as usize,
                },

                Some(SdkWorkerPollerOpts {
                    simple_maximum: Some(simple_max),
                    ..
                }) => PollerBehavior::SimpleMaximum(simple_max.simple_maximum as usize),

                _ => return Err(String::from("workflow_task_poller_behavior not configured")),
            }
        })
        .nonsticky_to_sticky_poll_ratio(options.nonsticky_to_sticky_poll_ratio)
        .activity_task_poller_behavior({
            match options.activity_task_poller_behavior {
                Some(SdkWorkerPollerOpts {
                    autoscaling: Some(autoscaling),
                    ..
                }) => PollerBehavior::Autoscaling {
                    minimum: autoscaling.minimum as usize,
                    maximum: autoscaling.maximum as usize,
                    initial: autoscaling.initial as usize,
                },

                Some(SdkWorkerPollerOpts {
                    simple_maximum: Some(simple_max),
                    ..
                }) => PollerBehavior::SimpleMaximum(simple_max.simple_maximum as usize),

                _ => return Err(String::from("activity_task_poller_behavior not configured")),
            }
        })
        .task_types(WorkerTaskTypes {
            enable_workflows: options.enable_workflows,
            enable_local_activities: options.enable_local_activities,
            enable_remote_activities: options.enable_remote_activities,
            enable_nexus: options.enable_nexus,
        })
        .sticky_queue_schedule_to_start_timeout(Duration::from_secs_f64(
            options.sticky_queue_schedule_to_start_timeout_secs,
        ))
        .max_heartbeat_throttle_interval(Duration::from_secs_f64(
            options.max_heartbeat_throttle_interval_secs,
        ))
        .default_heartbeat_throttle_interval(Duration::from_secs_f64(
            options.default_heartbeat_throttle_interval_secs,
        ))
        .maybe_max_worker_activities_per_second(options.max_worker_activities_per_second)
        .maybe_max_task_queue_activities_per_second(options.max_task_queue_activities_per_second)
        .graceful_shutdown_period(Duration::from_secs_f64(
            options.graceful_shutdown_period_secs,
        ))
        .tuner(Arc::new(build_tuner(options.tuner)?))
        .workflow_failure_errors(if options.nondeterminism_as_workflow_fail {
            HashSet::from([WorkflowErrorType::Nondeterminism])
        } else {
            HashSet::new()
        })
        .workflow_types_to_failure_errors(
            options
                .nondeterminism_as_workflow_fail_for_types
                .into_iter()
                .map(|s| (s, HashSet::from([WorkflowErrorType::Nondeterminism])))
                .collect::<HashMap<String, HashSet<WorkflowErrorType>>>(),
        )
        .plugins(
            options
                .plugins
                .into_iter()
                .map(|name| PluginInfo {
                    name,
                    version: String::new(),
                })
                .collect::<HashSet<_>>(),
        )
        .build();

    match config {
        Ok(config) => {
            let handle = runtime.core.lock().unwrap().tokio_handle();
            handle.spawn(async move {
                let initialized = match runtime.core.lock() {
                    Ok(core) => {
                        init_worker(&core, config, client.connection.lock().unwrap().clone())
                    }

                    Err(err) => {
                        return Err(format!("Error getting runtime handle: {}", err));
                    }
                };

                let resp = match initialized {
                    Ok(worker) => Ok(ResourceArc::new(ElixirWorker {
                        worker: Mutex::new(worker),
                    })),
                    Err(err) => Err(format!("Error creating worker: {}", err)),
                };

                let mut owned_env = OwnedEnv::new();
                owned_env
                    .send_and_clear(&resp_pid, |_curr_env| resp)
                    .unwrap_or_else(|err| {
                        error!("Error sending worker response message: {:?}", err)
                    });

                Ok(true)
            });

            Ok(true)
        }

        Err(err) => Err(String::from(format!("Error creating worker opts: {}", err))),
    }
}

fn build_tuner(options: SdkWorkerTunerOpts) -> Result<TunerHolder, String> {
    let (workflow_slot_options, resource_slot_options) =
        build_tuner_slot_options(options.workflow_slot_supplier, None)?;
    let (activity_slot_options, resource_slot_options) =
        build_tuner_slot_options(options.activity_slot_supplier, resource_slot_options)?;
    let (local_activity_slot_options, resource_slot_options) =
        build_tuner_slot_options(options.local_activity_slot_supplier, resource_slot_options)?;

    let tuner_holder_opts = TunerHolderOptions::builder()
        .maybe_resource_based_options(resource_slot_options)
        .workflow_slot_options(workflow_slot_options)
        .activity_slot_options(activity_slot_options)
        .local_activity_slot_options(local_activity_slot_options)
        .build();

    let tuner_holder_results = match tuner_holder_opts {
        Ok(tuner_holder_opts) => tuner_holder_opts.build_tuner_holder(),

        Err(err) => {
            return Err(String::from(format!(
                "Failed building tuner holder opts: {}",
                err
            )));
        }
    };

    match tuner_holder_results {
        Ok(tuner_holder) => Ok(tuner_holder),

        Err(err) => Err(String::from(format!(
            "Failed building tuner holder: {}",
            err
        ))),
    }
}

fn build_tuner_slot_options<SK: SlotKind + Send + Sync + 'static>(
    options: SdkWorkerSlotSupplierOpts,
    prev_slots_options: Option<ResourceBasedSlotsOptions>,
) -> Result<(SlotSupplierOptions<SK>, Option<ResourceBasedSlotsOptions>), String> {
    if let Some(slots) = options.fixed_size {
        Ok((
            SlotSupplierOptions::FixedSize {
                slots: slots as usize,
            },
            prev_slots_options,
        ))
    } else if let Some(resource) = options.resource_based {
        build_tuner_resource_options(resource, prev_slots_options)
    } else {
        Err(String::from(
            "Slot supplier must be fixed size or resource based",
        ))
    }
}

fn build_tuner_resource_options<SK: SlotKind>(
    options: SdkWorkerTunerResourceOpts,
    prev_slots_options: Option<ResourceBasedSlotsOptions>,
) -> Result<(SlotSupplierOptions<SK>, Option<ResourceBasedSlotsOptions>), String> {
    let slots_options = ResourceBasedSlotsOptions::builder()
        .target_mem_usage(options.target_mem_usage)
        .target_cpu_usage(options.target_cpu_usage)
        .build();

    match prev_slots_options {
        Some(prev_slots_opts) => {
            if slots_options.target_cpu_usage != prev_slots_opts.target_cpu_usage
                || slots_options.target_mem_usage != prev_slots_opts.target_mem_usage
            {
                return Err(String::from(
                    "All resource-based slot suppliers must have the same resource-based tuner options"
                ));
            }
        }

        None => {}
    }

    Ok((
        SlotSupplierOptions::ResourceBased(ResourceSlotOptions::new(
            options.min_slots as usize,
            options.max_slots as usize,
            Duration::from_secs_f64(options.ramp_throttle),
        )),
        Some(slots_options),
    ))
}

#[rustler::nif]
fn _validate_worker(
    env: Env,
    _runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let rt = Runtime::new().unwrap();

    rt.block_on(async {
        let core_worker = worker.worker.lock().await;
        let validate_resp = core_worker.validate().await;

        let resp = match validate_resp {
            Ok(_) => Ok(true),
            Err(err) => Err(format!("Error validating worker: {}", err)),
        };

        let _ = env.send(&resp_pid, resp);
    });

    Ok(true)
}

#[rustler::nif]
fn _worker_poll_workflow_activation(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let handle = runtime.core.lock().unwrap().tokio_handle();
    handle.spawn(async move {
        let poll_result = worker.worker.lock().await.poll_workflow_activation().await;

        let msg: Result<SdkWorkflowActivation, String> = match poll_result {
            Ok(activation) => Ok(activation.into()),
            Err(error) => Err(format!("Error polling workflow activation: {}", error)),
        };

        let mut owned_env = OwnedEnv::new();
        let _ = owned_env.send_and_clear(&resp_pid, |_curr_env| msg);
    });

    Ok(true)
}

#[rustler::nif]
fn _worker_poll_activity_task(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let handle = runtime.core.lock().unwrap().tokio_handle();
    handle.spawn(async move {
        let poll_result = worker.worker.lock().await.poll_activity_task().await;

        let msg: Result<SdkActivityTask, String> = match poll_result {
            Ok(activity_task) => Ok(activity_task.into()),
            Err(error) => Err(format!("Error polling workflow activation: {}", error)),
        };

        let mut owned_env = OwnedEnv::new();
        let _ = owned_env.send_and_clear(&resp_pid, |_curr_env| msg);
    });

    Ok(true)
}

#[rustler::nif]
fn _worker_poll_nexus_task(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let handle = runtime.core.lock().unwrap().tokio_handle();
    handle.spawn(async move {
        let poll_result = worker.worker.lock().await.poll_nexus_task().await;

        let msg: Result<SdkNexusTask, String> = match poll_result {
            Ok(task) => Ok(task.into()),
            Err(error) => Err(format!("Error polling workflow activation: {}", error)),
        };

        let mut owned_env = OwnedEnv::new();
        let _ = owned_env.send_and_clear(&resp_pid, |_curr_env| msg);
    });

    Ok(true)
}
