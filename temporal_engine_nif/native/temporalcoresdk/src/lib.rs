use crate::core_activities::{SdkActivityTask, SdkActivityTaskCompletion};
use crate::core_client::ElixirClient;
use crate::core_nexus::SdkNexusTask;
use crate::core_runtime::{ElixirRuntime, SdkRuntimeOpts};
use crate::core_worker::ElixirWorker;
use crate::core_workflows::{
    ElixirWorkflowHandle, SdkQueryRejectCondition, SdkQueryWorkflowResponse,
    SdkSignalWorkflowRequest, SdkSignalWorkflowResponse, SdkUpdateWaitPolicy,
    SdkWorkflowActivation, SdkWorkflowActivationCompletion, SdkWorkflowDefinition,
    SdkWorkflowExecution, SdkWorkflowGetResultError, SdkWorkflowGetResultOptions, SdkWorkflowQuery,
    SdkWorkflowStartOptions, SdkWorkflowUpdate, SdkWorkflowUpdateResponse,
};
use crate::data::common::{SdkPayload, SdkWorkflowArguments};
use futures_util::StreamExt;
use rustler::{Atom, Error, LocalPid, NifResult, OwnedEnv, ResourceArc};
use std::collections::{HashMap, HashSet};
use std::ops::Deref;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use temporalio_sdk_client::grpc::WorkflowService;
use temporalio_sdk_client::tonic::Request;
use temporalio_sdk_client::{
    Client, ClientOptions, Connection, ConnectionOptions, NamespacedClient, WorkflowListOptions,
};
use temporalio_sdk_common::protos::coresdk::ActivityHeartbeat;
use temporalio_sdk_common::protos::temporal::api::update;
use temporalio_sdk_common::protos::temporal::api::update::v1::Meta;
use temporalio_sdk_common::protos::temporal::api::worker::v1::PluginInfo;
use temporalio_sdk_common::protos::temporal::api::workflowservice::v1::{
    QueryWorkflowRequest, UpdateWorkflowExecutionRequest,
};
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;
use temporalio_sdk_common::worker::{
    WorkerDeploymentOptions, WorkerDeploymentVersion, WorkerTaskTypes,
};
use temporalio_sdk_core::{
    init_worker, CoreRuntime, PollError, PollerBehavior, ResourceBasedSlotsOptions,
    ResourceSlotOptions, RuntimeOptions, SlotKind, SlotSupplierOptions, TokioRuntimeBuilder,
    TunerHolder, TunerHolderOptions, WorkerConfig, WorkerVersioningStrategy, WorkflowErrorType,
};
use tokio::runtime::Runtime;
use tracing::{error, warn};
use url::Url;
use uuid::Uuid;

mod common;
mod core_activities;
mod core_client;
mod core_nexus;
mod core_runtime;
mod core_worker;
mod core_workflows;
mod data;

mod atoms {
    rustler::atoms! {
        ok,
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn _create_runtime(opts: Option<SdkRuntimeOpts>) -> Result<ResourceArc<ElixirRuntime>, String> {
    let core_opts = match opts {
        Some(sdk_opts) => {
            let hb_interval = sdk_opts.heartbeat_interval.try_into_or_none();

            RuntimeOptions::builder()
                .heartbeat_interval(hb_interval)
                .build()
                .map_err(|err| panic!("Invalid runtime options: {}", err))
                .unwrap()
        }
        None => RuntimeOptions::default(),
    };

    let core = CoreRuntime::new(core_opts, TokioRuntimeBuilder::default());

    match core {
        Ok(new_core) => {
            let runtime = ElixirRuntime {
                core: RwLock::new(Arc::new(new_core)),
            };

            Ok(ResourceArc::new(runtime))
        }
        Err(e) => Err(format!("Error creating runtime: {e:?}")),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
fn _create_client(
    runtime: ResourceArc<ElixirRuntime>,
    options: crate::core_client::SdkConnectionOpts,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let parsed_host = Url::parse(
        format!(
            "{}://{}",
            if options.tls_options.is_some() {
                "https"
            } else {
                "http"
            },
            options.target
        )
        .as_str(),
    );

    let host_url = match parsed_host {
        Ok(host) => host,
        Err(err) => {
            return Err(Error::Term(Box::new(format!(
                "Failed parsing host: {}",
                err
            ))))
        }
    };

    let has_http_connect_settings = options.http_connect_proxy.is_some();
    let opts = ConnectionOptions::new(host_url)
        .maybe_override_origin(options.override_origin.try_into_or_none())
        .client_name(options.client_name)
        .client_version(options.client_version)
        .headers(options.headers.unwrap_or_default())
        .binary_headers(options.binary_headers.unwrap_or_default())
        .maybe_api_key(options.api_key)
        .identity(options.identity)
        .maybe_tls_options(options.tls_options.try_into_or_none())
        .maybe_retry_options(options.retry_options.try_into_or_none())
        .keep_alive(options.keep_alive.try_into_or_none())
        .maybe_http_connect_proxy(options.http_connect_proxy.try_into_or_none())
        .dns_load_balancing(if has_http_connect_settings {
            warn!("Disabling DNS load balancing because http_connect_proxy is set");
            None
        } else {
            options.dns_load_balancing.try_into_or_none()
        })
        .build();

    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match Connection::connect(opts).await {
            Ok(conn) => {
                let client =
                    Client::new(conn, ClientOptions::new(options.namespace).build()).unwrap();

                let resp: Result<ResourceArc<ElixirClient>, String> =
                    Ok(ResourceArc::new(ElixirClient { client }));

                owned_env
                    .send_and_clear(&resp_pid, |_env| resp)
                    .unwrap_or_else(|err| {
                        error!("Error sending client response message: {:?}", err)
                    });
            }

            Err(err) => {
                let resp: Result<ResourceArc<ElixirClient>, String> =
                    Err(format!("Error creating Elixir client: {}", err));
                owned_env
                    .send_and_clear(&resp_pid, |_env| resp)
                    .unwrap_or_else(|err| {
                        error!("Error sending client response message: {:?}", err)
                    });
            }
        };
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn _create_worker(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    options: core_worker::SdkWorkerConfig,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let config = WorkerConfig::builder()
        .namespace(options.namespace)
        .task_queue(options.task_queue)
        .versioning_strategy({
            let dopts = options.versioning_strategy;
            WorkerVersioningStrategy::WorkerDeploymentBased(WorkerDeploymentOptions {
                version: WorkerDeploymentVersion {
                    deployment_name: dopts.version.deployment_name,
                    build_id: dopts.version.build_id,
                },
                use_worker_versioning: dopts.use_worker_versioning,
                default_versioning_behavior: {
                    match dopts.default_versioning_behavior {
                        None => None,
                        Some(val) => Some(val.into()),
                    }
                },
            })
        })
        .maybe_client_identity_override(options.client_identity_override)
        .max_cached_workflows(options.max_cached_workflows as usize)
        .workflow_task_poller_behavior({
            match options.workflow_task_poller_behavior {
                core_worker::SdkWorkerPollerOpts::Autoscaling(autoscaling) => {
                    PollerBehavior::Autoscaling {
                        minimum: autoscaling.minimum as usize,
                        maximum: autoscaling.maximum as usize,
                        initial: autoscaling.initial as usize,
                    }
                }

                core_worker::SdkWorkerPollerOpts::SimpleMaximum(simple_max) => {
                    PollerBehavior::SimpleMaximum(simple_max.simple_maximum as usize)
                }
            }
        })
        .nonsticky_to_sticky_poll_ratio(options.nonsticky_to_sticky_poll_ratio)
        .activity_task_poller_behavior({
            match options.activity_task_poller_behavior {
                core_worker::SdkWorkerPollerOpts::Autoscaling(autoscaling) => {
                    PollerBehavior::Autoscaling {
                        minimum: autoscaling.minimum as usize,
                        maximum: autoscaling.maximum as usize,
                        initial: autoscaling.initial as usize,
                    }
                }

                core_worker::SdkWorkerPollerOpts::SimpleMaximum(simple_max) => {
                    PollerBehavior::SimpleMaximum(simple_max.simple_maximum as usize)
                }
            }
        })
        .task_types(WorkerTaskTypes {
            enable_workflows: options.task_types.enable_workflows,
            enable_local_activities: options.task_types.enable_local_activities,
            enable_remote_activities: options.task_types.enable_remote_activities,
            enable_nexus: options.task_types.enable_nexus,
        })
        .sticky_queue_schedule_to_start_timeout(
            options.sticky_queue_schedule_to_start_timeout.into(),
        )
        .max_heartbeat_throttle_interval(options.max_heartbeat_throttle_interval.into())
        .default_heartbeat_throttle_interval(options.default_heartbeat_throttle_interval.into())
        .maybe_max_worker_activities_per_second(options.max_worker_activities_per_second)
        .maybe_max_task_queue_activities_per_second(options.max_task_queue_activities_per_second)
        .maybe_graceful_shutdown_period(options.graceful_shutdown_period.try_into_or_none())
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
                .map(|info| PluginInfo {
                    name: info.name,
                    version: String::new(),
                })
                .collect::<HashSet<_>>(),
        )
        .build();

    match config {
        Ok(config) => {
            let core_runtime = runtime.core.read().expect("Invalid runtime handle").clone();
            let handle = core_runtime.tokio_handle();
            handle.spawn(async move {
                let initialized = init_worker(
                    core_runtime.as_ref(),
                    config,
                    client.client.connection().clone(),
                );

                let resp = match initialized {
                    Ok(worker) => Ok(ResourceArc::new(ElixirWorker {
                        worker: Some(worker),
                    })),
                    Err(err) => Err(format!("Error creating worker.ex: {}", err)),
                };

                let mut owned_env = OwnedEnv::new();
                owned_env
                    .send_and_clear(&resp_pid, |_env| resp)
                    .unwrap_or_else(|err| {
                        error!("Error sending worker.ex response message: {:?}", err)
                    });
            });

            Ok(atoms::ok())
        }

        Err(err) => Err(Error::Term(Box::new(format!(
            "Error creating worker.ex opts: {}",
            err
        )))),
    }
}

pub fn build_tuner(options: crate::core_worker::SdkWorkerTunerOpts) -> Result<TunerHolder, Error> {
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
            return Err(Error::Term(Box::new(format!(
                "Failed building tuner holder opts: {}",
                err
            ))));
        }
    };

    match tuner_holder_results {
        Ok(tuner_holder) => Ok(tuner_holder),

        Err(err) => Err(Error::Term(Box::new(format!(
            "Failed building tuner holder: {}",
            err
        )))),
    }
}

pub fn build_tuner_slot_options<SK: SlotKind + Send + Sync + 'static>(
    options: crate::core_worker::SdkWorkerSlotSupplierOpts,
    prev_slots_options: Option<ResourceBasedSlotsOptions>,
) -> Result<(SlotSupplierOptions<SK>, Option<ResourceBasedSlotsOptions>), Error> {
    match options {
        crate::core_worker::SdkWorkerSlotSupplierOpts::FixedSize(slots) => Ok((
            SlotSupplierOptions::FixedSize {
                slots: slots.size as usize,
            },
            prev_slots_options,
        )),
        crate::core_worker::SdkWorkerSlotSupplierOpts::ResourceBased(resource) => {
            build_tuner_resource_options(resource, prev_slots_options)
        }
    }
}

pub fn build_tuner_resource_options<SK: SlotKind>(
    options: crate::core_worker::SdkWorkerTunerResourceOpts,
    prev_slots_options: Option<ResourceBasedSlotsOptions>,
) -> Result<(SlotSupplierOptions<SK>, Option<ResourceBasedSlotsOptions>), Error> {
    let slots_options = ResourceBasedSlotsOptions::builder()
        .target_mem_usage(options.target_mem_usage)
        .target_cpu_usage(options.target_cpu_usage)
        .build();

    match prev_slots_options {
        Some(prev_slots_opts) => {
            if slots_options.target_cpu_usage != prev_slots_opts.target_cpu_usage
                || slots_options.target_mem_usage != prev_slots_opts.target_mem_usage
            {
                return Err(Error::Term(Box::new(
                    "All resource-based slot suppliers must have the same resource-based tuner options"
                )));
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
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let validate_resp = core_worker.validate().await;
                let msg = match validate_resp {
                    Ok(_) => Ok(true),
                    Err(err) => Err(format!("Error validating worker.ex: {}", err)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_poll_activity_task(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let poll_result = core_worker.poll_activity_task().await;
                let msg: Result<SdkActivityTask, String> = match poll_result {
                    Ok(activity_task) => Ok(activity_task.into()),
                    Err(PollError::ShutDown) => Err(String::from("core_shutdown")),
                    Err(error) => Err(format!("Error polling activity tasks: {}", error)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_poll_nexus_task(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let poll_result = core_worker.poll_nexus_task().await;
                let msg: Result<SdkNexusTask, String> = match poll_result {
                    Ok(task) => Ok(task.into()),
                    Err(PollError::ShutDown) => Err(String::from("core_shutdown")),
                    Err(error) => Err(format!("Error polling nexus tasks: {}", error)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _worker_complete_workflow_activation(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    completion: SdkWorkflowActivationCompletion,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let completion_result = core_worker
                    .complete_workflow_activation(completion.into())
                    .await;

                let msg: Result<Atom, String> = match completion_result {
                    Ok(()) => Ok(atoms::ok()),
                    Err(error) => Err(format!("Error completing workflows activation: {}", error)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _worker_complete_activity_task(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    completion: SdkActivityTaskCompletion,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let completion_result = core_worker.complete_activity_task(completion.into()).await;

                let msg: Result<bool, String> = match completion_result {
                    Ok(()) => Ok(true),
                    Err(error) => Err(format!("Error completing workflows activation: {}", error)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _worker_poll_workflow_activation(
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let poll_result = core_worker.poll_workflow_activation().await;
                let msg: Result<SdkWorkflowActivation, String> = match poll_result {
                    Ok(activation) => Ok(activation.into()),
                    Err(PollError::ShutDown) => Err(String::from("core_shutdown")),
                    Err(error) => Err(format!("Error polling workflow activations: {}", error)),
                };

                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_initiate_shutdown(worker: ResourceArc<ElixirWorker>) -> NifResult<Atom> {
    let rt = Runtime::new().unwrap();
    match worker.worker.as_ref() {
        Some(core_worker) => {
            rt.block_on(async move {
                core_worker.initiate_shutdown();
            });
            Ok(atoms::ok())
        }

        None => Err(rustler::Error::Term(Box::new(
            "Core Worker instance unavailable...",
        ))),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_finalize_shutdown(worker: ResourceArc<ElixirWorker>) -> NifResult<Atom> {
    let worker_mut = worker.deref() as *const ElixirWorker as *mut ElixirWorker;
    let stolen_core = unsafe { (*worker_mut).worker.take() };

    match stolen_core {
        Some(core_worker) => {
            let _ = core_worker.finalize_shutdown();
            Ok(atoms::ok())
        }

        None => Err(rustler::Error::Term(Box::new(
            "Core Worker instance unavailable...",
        ))),
    }
}

#[rustler::nif]
fn _worker_record_activity_heartbeat(
    worker: ResourceArc<ElixirWorker>,
    task_token: Vec<u8>,
    payloads: Vec<SdkPayload>,
) -> NifResult<Atom> {
    match worker.worker.as_ref() {
        Some(worker) => {
            worker.record_activity_heartbeat(ActivityHeartbeat {
                task_token: task_token,
                details: payloads.iter().map(|p| p.into()).collect(),
            });
        }

        None => (),
    }

    Ok(atoms::ok())
}

#[rustler::nif]
fn _handle_query_workflow(
    runtime: ResourceArc<ElixirRuntime>,
    wf_handle: ResourceArc<ElixirWorkflowHandle<SdkWorkflowDefinition>>,
    query: Option<SdkWorkflowQuery>,
    query_reject_condition: SdkQueryRejectCondition,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let wf_handle_ref = wf_handle
        .handle
        .read()
        .expect("Could not unwrap Workflow Handle");
    let mut client = wf_handle_ref.client().clone();
    let wf_info = wf_handle_ref.info();
    let exec = SdkWorkflowExecution {
        workflow_id: wf_info.workflow_id.clone(),
        run_id: match wf_info.run_id.clone() {
            Some(run_id) => run_id,
            None => String::from(""),
        },
    };

    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let query_resp = client
            .query_workflow(Request::new(QueryWorkflowRequest {
                namespace: client.namespace(),
                execution: Some(exec.into()),
                query: query.try_into_or_none(),
                query_reject_condition: query_reject_condition.into(),
            }))
            .await;

        let msg: Result<SdkQueryWorkflowResponse, String> = match query_resp {
            Ok(resp) => Ok(resp.into_inner().into()),
            Err(error) => Err(format!("Error querying workflow - {}", error)),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _handle_update_workflow(
    runtime: ResourceArc<ElixirRuntime>,
    wf_handle: ResourceArc<ElixirWorkflowHandle<SdkWorkflowDefinition>>,
    update_id: String,
    request: SdkWorkflowUpdate,
    wait_policy: Option<SdkUpdateWaitPolicy>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let wf_handle_ref = wf_handle
        .handle
        .read()
        .expect("Could not unwrap Workflow Handle");
    let mut client = wf_handle_ref.client().clone();
    let wf_info = wf_handle_ref.info();
    let exec = SdkWorkflowExecution {
        workflow_id: wf_info.workflow_id.clone(),
        run_id: wf_info.run_id.clone().unwrap(),
    };

    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();

    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let query_resp = client
            .update_workflow_execution(Request::new(UpdateWorkflowExecutionRequest {
                namespace: client.namespace(),
                workflow_execution: Some(exec.clone().into()),
                first_execution_run_id: exec.run_id,
                wait_policy: wait_policy.try_into_or_none(),
                request: Some(update::v1::Request {
                    request_id: Uuid::new_v4().to_string(),
                    completion_callbacks: vec![],
                    links: vec![],
                    meta: Some(Meta {
                        update_id: update_id,
                        identity: client.identity(),
                    }),
                    input: Some(request.into()),
                }),
            }))
            .await;

        let msg: Result<SdkWorkflowUpdateResponse, String> = match query_resp {
            Ok(resp) => Ok(resp.into_inner().into()),
            Err(error) => Err(format!("Error updating workflow - {}", error)),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _handle_signal_workflow(
    runtime: ResourceArc<ElixirRuntime>,
    wf_handle: ResourceArc<ElixirWorkflowHandle<SdkWorkflowDefinition>>,
    signal: SdkSignalWorkflowRequest,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let wf_handle_ref = wf_handle
        .handle
        .read()
        .expect("Could not unwrap Workflow Handle");
    let mut client = wf_handle_ref.client().clone();
    let wf_info = wf_handle_ref.info();

    let mut signal_req = signal.clone();

    signal_req.namespace = client.namespace();
    signal_req.identity = client.identity();

    signal_req.workflow_execution = Some(SdkWorkflowExecution {
        workflow_id: wf_info.workflow_id.clone(),
        run_id: match wf_info.run_id.clone() {
            Some(run_id) => run_id,
            None => String::from(""),
        },
    });

    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();

    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let query_resp = client
            .signal_workflow_execution(Request::new(signal_req.into()))
            .await;

        let msg: Result<SdkSignalWorkflowResponse, String> = match query_resp {
            Ok(resp) => Ok(resp.into_inner().into()),
            Err(error) => Err(format!("Error signaling workflow - {}", error)),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _client_get_workflow_handle(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    workflow_id: String,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let handle = client.client.get_workflow_handle(workflow_id);

        let msg: Result<ResourceArc<ElixirWorkflowHandle<SdkWorkflowDefinition>>, String> =
            Ok(ResourceArc::new(ElixirWorkflowHandle {
                handle: RwLock::new(handle),
            }));

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _client_list_workflows(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    query: String,
    limit: Option<usize>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let mut wf_stream = client.client.list_workflows(
            query,
            WorkflowListOptions::builder().maybe_limit(limit).build(),
        );
        let mut execs: Vec<SdkWorkflowExecution> = vec![];
        let mut list_error: Option<String> = None;

        while let Some(exec) = wf_stream.next().await {
            match exec {
                Ok(exec) => execs.push(SdkWorkflowExecution {
                    run_id: String::from(exec.run_id()),
                    workflow_id: String::from(exec.id()),
                }),

                Err(err) => list_error = Some(format!("Error listing workflows: {}", err)),
            }
        }

        let msg: Result<Vec<SdkWorkflowExecution>, String> = match list_error {
            Some(err) => Err(err),
            None => Ok(execs),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif]
fn _client_start_workflow(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    workflow: SdkWorkflowDefinition,
    input: SdkWorkflowArguments,
    options: SdkWorkflowStartOptions,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let started = client
            .client
            .start_workflow(workflow, input, options.into())
            .await;

        let msg = match started {
            Ok(handle) => Ok(ResourceArc::new(ElixirWorkflowHandle {
                handle: RwLock::new(handle),
            })),
            Err(error) => Err(format!("Error starting workflow - {}", error)),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyIo")]
fn _workflow_handle_get_result(
    runtime: ResourceArc<ElixirRuntime>,
    workflow_handle: ResourceArc<ElixirWorkflowHandle<SdkWorkflowDefinition>>,
    options: SdkWorkflowGetResultOptions,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();

    let wf_handle = workflow_handle
        .handle
        .read()
        .expect("Invalid workflow handle")
        .clone();
    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let result = wf_handle.get_result(options.into()).await;

        let msg: Result<SdkWorkflowArguments, SdkWorkflowGetResultError> = match result {
            Ok(outputs) => Ok(outputs),
            Err(error) => Err(error.into()),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

rustler::init!("Elixir.TemporalEngineNif.Core");
