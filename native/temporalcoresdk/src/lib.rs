use crate::core_activities::{SdkActivityTask, SdkActivityTaskCompletion};
use crate::core_client::ElixirClient;
use crate::core_nexus::SdkNexusTask;
use crate::core_runtime::ElixirRuntime;
use crate::core_worker::ElixirWorker;
use crate::core_workflows::{
    ElixirWorkflowHandle, SdkClientPayloads, SdkServerPayload, SdkWorkflowActivation,
    SdkWorkflowActivationCompletion, SdkWorkflowDefinition, SdkWorkflowExecHandle,
    SdkWorkflowGetResultOptions, SdkWorkflowStartOptions,
};
use rustler::{Atom, Env, LocalPid, NifResult, OwnedEnv, ResourceArc};
use std::collections::{HashMap, HashSet};
use std::ops::Deref;
use std::sync::{Arc, RwLock};
use std::time::Duration;
use temporalio_sdk_client::errors::{
    WorkflowGetResultError, WorkflowInteractionError, WorkflowStartError,
};
use temporalio_sdk_client::grpc::WorkflowService;
use temporalio_sdk_client::tonic::{Code, IntoRequest};
use temporalio_sdk_client::{
    Client, ClientKeepAliveOptions, ClientOptions, ClientTlsOptions, Connection, ConnectionOptions,
    DnsLoadBalancingOptions, HttpConnectProxyOptions, NamespacedClient, RetryOptions, TlsOptions,
    WorkflowExecutionResult, WorkflowFetchHistoryOptions, WorkflowGetResultOptions,
};
use temporalio_sdk_common::data_converters::{
    GenericPayloadConverter, PayloadConverter, SerializationContext, SerializationContextData,
};
use temporalio_sdk_common::protos::coresdk::FromPayloadsExt;
use temporalio_sdk_common::protos::coresdk::IntoPayloadsExt;
use temporalio_sdk_common::protos::temporal::api::common::v1::{
    Payload, Priority, SearchAttributes, WorkflowExecution, WorkflowType,
};
use temporalio_sdk_common::protos::temporal::api::enums::v1::{
    HistoryEventFilterType, TaskQueueKind, VersioningBehavior,
};
use temporalio_sdk_common::protos::temporal::api::errordetails::v1::WorkflowExecutionAlreadyStartedFailure;
use temporalio_sdk_common::protos::temporal::api::history::v1::history_event::Attributes;
use temporalio_sdk_common::protos::temporal::api::history::v1::HistoryEvent;
use temporalio_sdk_common::protos::temporal::api::sdk::v1::UserMetadata;
use temporalio_sdk_common::protos::temporal::api::taskqueue::v1::TaskQueue;
use temporalio_sdk_common::protos::temporal::api::worker::v1::PluginInfo;
use temporalio_sdk_common::protos::temporal::api::workflowservice::v1::{
    GetWorkflowExecutionHistoryRequest, StartWorkflowExecutionRequest,
};
use temporalio_sdk_common::protos::utilities::{decode_status_detail, TryIntoOrNone};
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

mod atoms {
    rustler::atoms! {
        ok,
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn _create_runtime(
    opts: Option<core_runtime::SdkRuntimeOpts>,
) -> Result<ResourceArc<ElixirRuntime>, String> {
    let core_opts = match opts {
        Some(sdk_opts) => {
            let hb_interval = match sdk_opts.heartbeat_interval_secs {
                Some(hb) => Some(Duration::from_secs(hb)),
                None => None,
            };

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

#[rustler::nif]
fn _create_client(
    runtime: ResourceArc<ElixirRuntime>,
    options: core_client::SdkClientOpts,
    resp_pid: LocalPid,
) -> Result<bool, String> {
    let parsed_host = Url::parse(
        format!(
            "{}://{}",
            if options.tls.is_some() {
                "https"
            } else {
                "http"
            },
            options.target_host
        )
        .as_str(),
    );

    let host_url = match parsed_host {
        Ok(host) => host,
        Err(err) => return Err(format!("Failed parsing host: {}", err)),
    };

    let has_http_connect_settings = options.http_connect_proxy.is_some();
    let opts = ConnectionOptions::new(host_url)
        .client_name(options.client_name)
        .client_version(options.client_version)
        .headers(options.headers.unwrap_or_default())
        .binary_headers(options.binary_headers.unwrap_or_default())
        .maybe_api_key(options.api_key)
        .identity(options.identity)
        .maybe_tls_options(if let Some(tls) = options.tls {
            Some(TlsOptions {
                client_tls_options: match (tls.client_cert, tls.client_private_key) {
                    (None, None) => None,
                    (Some(client_cert), Some(client_private_key)) => Some(ClientTlsOptions {
                        // These are unsafe because of lifetime issues, but we copy right away
                        client_cert: client_cert.into_bytes(),
                        client_private_key: client_private_key.into_bytes(),
                    }),
                    _ => {
                        return Err(String::from(
                            "Must have both client cert and private key or neither",
                        ));
                    }
                },
                server_root_ca_cert: tls.server_root_ca_cert.map(|rstr| rstr.into_bytes()),
                domain: tls.domain,
            })
        } else {
            None
        })
        .retry_options(RetryOptions {
            initial_interval: Duration::from_secs_f64(options.rpc_retry.initial_interval_secs),
            randomization_factor: options.rpc_retry.randomization_factor,
            multiplier: options.rpc_retry.multiplier,
            max_interval: Duration::from_secs_f64(options.rpc_retry.max_interval_secs),
            max_elapsed_time: match options.rpc_retry.max_elapsed_time_secs {
                // 0 means none
                0.0 => None,
                val => Some(Duration::from_secs_f64(val)),
            },
            max_retries: options.rpc_retry.max_retries as usize,
        })
        .keep_alive(if let Some(keep_alive) = options.keep_alive {
            Some(ClientKeepAliveOptions {
                interval: Duration::from_secs_f64(keep_alive.interval_secs),
                timeout: Duration::from_secs_f64(keep_alive.timeout_secs),
            })
        } else {
            None
        })
        .maybe_http_connect_proxy(if let Some(proxy) = options.http_connect_proxy {
            Some(HttpConnectProxyOptions {
                target_addr: proxy.target_host,
                basic_auth: match (proxy.basic_auth_user, proxy.basic_auth_pass) {
                    (None, None) => None,
                    (Some(user), Some(pass)) => Some((user, pass)),
                    _ => {
                        return Err(String::from(
                            "Must have both basic auth and pass or neither",
                        ));
                    }
                },
            })
        } else {
            None
        })
        .dns_load_balancing(if has_http_connect_settings {
            warn!("Disabling DNS load balancing because http_connect_proxy is set");
            None
        } else if let Some(dns) = options.dns_load_balancing {
            let mut opts = DnsLoadBalancingOptions::default();
            opts.resolution_interval = Duration::from_secs_f64(dns.resolution_interval_secs);
            Some(opts)
        } else {
            None
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

    Ok(true)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn _create_worker(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    options: core_worker::SdkWorkerOpts,
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

            Ok(true)
        }

        Err(err) => Err(String::from(format!(
            "Error creating worker.ex opts: {}",
            err
        ))),
    }
}

fn build_tuner(options: core_worker::SdkWorkerTunerOpts) -> Result<TunerHolder, String> {
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
    options: core_worker::SdkWorkerSlotSupplierOpts,
    prev_slots_options: Option<ResourceBasedSlotsOptions>,
) -> Result<(SlotSupplierOptions<SK>, Option<ResourceBasedSlotsOptions>), String> {
    match options {
        core_worker::SdkWorkerSlotSupplierOpts::FixedSize(slots) => Ok((
            SlotSupplierOptions::FixedSize {
                slots: slots as usize,
            },
            prev_slots_options,
        )),
        core_worker::SdkWorkerSlotSupplierOpts::ResourceBased(resource) => {
            build_tuner_resource_options(resource, prev_slots_options)
        }
    }
}

fn build_tuner_resource_options<SK: SlotKind>(
    options: core_worker::SdkWorkerTunerResourceOpts,
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
    runtime: ResourceArc<ElixirRuntime>,
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> Result<bool, String> {
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

    Ok(true)
}

#[rustler::nif]
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

#[rustler::nif]
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

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_complete_workflow_activation(
    env: Env,
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

    handle.block_on(async move {
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let completion_result = core_worker
                    .complete_workflow_activation(completion.into())
                    .await;

                let msg: Result<Atom, String> = match completion_result {
                    Ok(()) => Ok(atoms::ok()),
                    Err(error) => Err(format!("Error completing workflows activation: {}", error)),
                };

                env.send(&resp_pid, msg).unwrap_or_else(|err| {
                    error!("Error sending activation completion message: {:?}", err)
                });
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));

                env.send(&resp_pid, msg).unwrap_or_else(|err| {
                    error!("Error sending activation completion error: {:?}", err)
                });
            }
        }
    });

    Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyIo")]
fn _worker_complete_activity_task(
    env: Env,
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

    handle.block_on(async move {
        match worker.worker.as_ref() {
            Some(core_worker) => {
                let completion_result = core_worker.complete_activity_task(completion.into()).await;

                let msg: Result<bool, String> = match completion_result {
                    Ok(()) => Ok(true),
                    Err(error) => Err(format!("Error completing workflows activation: {}", error)),
                };

                env.send(&resp_pid, msg).unwrap_or_else(|err| {
                    error!("Error sending complete activity message: {:?}", err)
                });
            }

            None => {
                let msg: Result<bool, String> =
                    Err(String::from("Core Worker instance unavailable..."));
                env.send(&resp_pid, msg).unwrap_or_else(|err| {
                    error!("Error sending complete activity error: {:?}", err)
                });
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

#[rustler::nif]
fn _worker_initiate_shutdown(
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let rt = Runtime::new().unwrap();

    let _ = rt.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match worker.worker.as_ref() {
            Some(core_worker) => {
                core_worker.initiate_shutdown();

                let msg: Result<bool, String> = Ok(true);
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
fn _worker_finalize_shutdown(
    worker: ResourceArc<ElixirWorker>,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let worker_mut = worker.deref() as *const ElixirWorker as *mut ElixirWorker;
    let stolen_core = unsafe { (*worker_mut).worker.take() };

    let rt = Runtime::new().unwrap();
    let _ = rt.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match stolen_core {
            Some(core_worker) => {
                core_worker.finalize_shutdown().await;

                let msg: Atom = atoms::ok();
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
fn _client_start_workflow(
    env: Env,
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    workflow: SdkWorkflowDefinition,
    input: SdkClientPayloads,
    options: SdkWorkflowStartOptions,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();

    let payloads: Vec<Payload> = input.into();
    handle.block_on(async move {
        let msg = match start_workflow(&client.client, workflow, options, payloads).await {
            Ok(handle) => Ok(ResourceArc::new(ElixirWorkflowHandle { handle: handle })),
            Err(error) => Err(format!("Error starting workflow - {}", error)),
        };

        env.send(&resp_pid, msg)
            .unwrap_or_else(|err| error!("Error sending start workflow message: {:?}", err));
    });

    Ok(atoms::ok())
}

async fn start_workflow<'a>(
    client: &Client,
    workflow: SdkWorkflowDefinition,
    options: SdkWorkflowStartOptions<'a>,
    payloads: Vec<Payload>,
) -> Result<SdkWorkflowExecHandle, WorkflowStartError> {
    let user_metadata = if options.static_summary.is_some() || options.static_details.is_some() {
        let payload_converter = PayloadConverter::default();
        let context = SerializationContext {
            data: &SerializationContextData::Workflow,
            converter: &payload_converter,
        };
        Some(UserMetadata {
            summary: options.static_summary.map(|s| {
                payload_converter
                    .to_payload(&context, &s)
                    .expect("String-to-JSON payload serialization is infallible")
            }),
            details: options.static_details.map(|s| {
                payload_converter
                    .to_payload(&context, &s)
                    .expect("String-to-JSON payload serialization is infallible")
            }),
        })
    } else {
        None
    };

    let res = client
        .clone()
        .start_workflow_execution(
            StartWorkflowExecutionRequest {
                namespace: client.namespace().clone(),
                input: payloads.into_payloads(),
                workflow_id: options.workflow_id.clone(),
                workflow_type: Some(WorkflowType {
                    name: workflow.name,
                }),
                task_queue: Some(TaskQueue {
                    name: options.task_queue,
                    kind: TaskQueueKind::Unspecified as i32,
                    normal_name: "".to_string(),
                }),
                request_id: Uuid::new_v4().to_string(),
                workflow_id_reuse_policy: options.id_reuse_policy as i32,
                workflow_id_conflict_policy: options.id_conflict_policy as i32,
                workflow_execution_timeout: options
                    .execution_timeout
                    .and_then(|d| d.try_into().ok()),
                workflow_run_timeout: options.run_timeout.and_then(|d| d.try_into().ok()),
                workflow_task_timeout: options.task_timeout.and_then(|d| d.try_into().ok()),
                search_attributes: {
                    match options.search_attributes {
                        Some(attributes) => Some(SearchAttributes {
                            indexed_fields: attributes
                                .iter()
                                .map(|(k, v)| (k.clone(), v.clone().into()))
                                .collect(),
                        }),
                        None => None,
                    }
                },
                cron_schedule: options.cron_schedule.unwrap_or_default(),
                request_eager_execution: options.enable_eager_workflow_start,
                retry_policy: options.retry_policy.try_into_or_none(),
                links: options
                    .links
                    .iter()
                    .map(|link| link.clone().into())
                    .collect(),
                completion_callbacks: options
                    .completion_callbacks
                    .iter()
                    .map(|c| c.clone().into())
                    .collect(),
                priority: Some(Priority {
                    priority_key: options.priority.priority_key.unwrap_or(0) as i32,
                    fairness_key: options.priority.fairness_key.unwrap_or_default(),
                    fairness_weight: options.priority.fairness_weight.unwrap_or(0.0),
                }),
                header: options.header.try_into_or_none(),
                user_metadata,
                ..Default::default()
            }
            .into_request(),
        )
        .await
        .map_err(|status| {
            if status.code() == Code::AlreadyExists {
                let run_id = decode_status_detail::<WorkflowExecutionAlreadyStartedFailure>(
                    status.details(),
                )
                .map(|f| f.run_id);
                WorkflowStartError::AlreadyStarted {
                    run_id,
                    source: status,
                }
            } else {
                WorkflowStartError::Rpc(status)
            }
        })?
        .into_inner();

    Ok(SdkWorkflowExecHandle {
        namespace: client.namespace(),
        workflow_id: options.workflow_id.clone(),
        run_id: res.run_id.clone(),
        first_execution_run_id: res.run_id,
    })
}

#[rustler::nif]
fn _workflow_handle_get_result(
    runtime: ResourceArc<ElixirRuntime>,
    client: ResourceArc<ElixirClient>,
    workflow_handle: ResourceArc<ElixirWorkflowHandle>,
    options: SdkWorkflowGetResultOptions,
    resp_pid: LocalPid,
) -> NifResult<Atom> {
    let handle = runtime
        .core
        .read()
        .expect("Invalid runtime handle")
        .tokio_handle();

    handle.spawn(async move {
        let mut owned_env = OwnedEnv::new();
        let result =
            get_workflow_result(&client.client, &workflow_handle.handle, options.into()).await;

        let parsed_result: Result<Payload, WorkflowGetResultError> = match result {
            Ok(WorkflowExecutionResult::Succeeded(v)) => Ok(v),
            Ok(WorkflowExecutionResult::Failed(f)) => {
                Err(WorkflowGetResultError::Failed(Box::new(f)))
            }
            Ok(WorkflowExecutionResult::Cancelled { details }) => {
                Err(WorkflowGetResultError::Cancelled { details })
            }
            Ok(WorkflowExecutionResult::Terminated { details }) => {
                Err(WorkflowGetResultError::Terminated { details })
            }
            Ok(WorkflowExecutionResult::TimedOut) => Err(WorkflowGetResultError::TimedOut),
            Ok(WorkflowExecutionResult::ContinuedAsNew) => {
                Err(WorkflowGetResultError::ContinuedAsNew)
            }
            Err(err) => Err(WorkflowGetResultError::Other(Box::new(err))),
        };

        let msg: Result<SdkServerPayload, String> = match parsed_result {
            Ok(payload) => Ok(payload.into()),
            Err(error) => Err(format!("Error getting workflow results - {}", error)),
        };

        let _ = owned_env.send_and_clear(&resp_pid, |_env| msg);
    });

    Ok(atoms::ok())
}

async fn get_workflow_result(
    client: &Client,
    handle: &SdkWorkflowExecHandle,
    opts: WorkflowGetResultOptions,
) -> Result<WorkflowExecutionResult<Payload>, WorkflowInteractionError> {
    let fetch_opts = WorkflowFetchHistoryOptions::builder()
        .skip_archival(true)
        .wait_new_event(true)
        .event_filter_type(HistoryEventFilterType::CloseEvent)
        .build();

    #[allow(unused)]
    let mut run_id = handle.run_id.clone();
    loop {
        let mut events =
            fetch_history_for_run(client, &run_id, &handle.workflow_id, &fetch_opts).await?;

        if events.is_empty() {
            continue;
        }

        let event_attrs = events.pop().and_then(|ev| ev.attributes);

        macro_rules! follow {
            ($attrs:ident) => {
                if opts.follow_runs && $attrs.new_execution_run_id != "" {
                    run_id = $attrs.new_execution_run_id;
                    continue;
                }
            };
        }

        break match event_attrs {
            Some(Attributes::WorkflowExecutionCompletedEventAttributes(attrs)) => {
                follow!(attrs);
                let payload = attrs
                    .result
                    .and_then(|p| p.payloads.into_iter().next())
                    .unwrap_or_default();
                let result = payload;
                Ok(WorkflowExecutionResult::Succeeded(result))
            }
            Some(Attributes::WorkflowExecutionFailedEventAttributes(attrs)) => {
                follow!(attrs);
                Ok(WorkflowExecutionResult::Failed(
                    attrs.failure.unwrap_or_default(),
                ))
            }
            Some(Attributes::WorkflowExecutionCanceledEventAttributes(attrs)) => {
                Ok(WorkflowExecutionResult::Cancelled {
                    details: Vec::from_payloads(attrs.details),
                })
            }
            Some(Attributes::WorkflowExecutionTimedOutEventAttributes(attrs)) => {
                follow!(attrs);
                Ok(WorkflowExecutionResult::TimedOut)
            }
            Some(Attributes::WorkflowExecutionTerminatedEventAttributes(attrs)) => {
                Ok(WorkflowExecutionResult::Terminated {
                    details: Vec::from_payloads(attrs.details),
                })
            }
            Some(Attributes::WorkflowExecutionContinuedAsNewEventAttributes(attrs)) => {
                if opts.follow_runs {
                    if !attrs.new_execution_run_id.is_empty() {
                        run_id = attrs.new_execution_run_id;
                        continue;
                    } else {
                        return Err(WorkflowInteractionError::Other(
                            "New execution run id was empty in continue as new event!".into(),
                        ));
                    }
                } else {
                    Ok(WorkflowExecutionResult::ContinuedAsNew)
                }
            }
            o => Err(WorkflowInteractionError::Other(
                format!(
                    "Server returned an event that didn't match the CloseEvent filter. \
                         This is either a server bug or a new event the SDK does not understand. \
                         Event details: {o:?}"
                )
                .into(),
            )),
        };
    }
}

async fn fetch_history_for_run(
    client: &Client,
    run_id: &String,
    workflow_id: &String,
    opts: &WorkflowFetchHistoryOptions,
) -> Result<Vec<HistoryEvent>, WorkflowInteractionError> {
    let mut all_events = Vec::new();
    let mut next_page_token = vec![];

    loop {
        let response = WorkflowService::get_workflow_execution_history(
            &mut client.clone(),
            GetWorkflowExecutionHistoryRequest {
                namespace: client.namespace(),
                execution: Some(WorkflowExecution {
                    workflow_id: workflow_id.clone(),
                    run_id: run_id.clone(),
                }),
                next_page_token: next_page_token.clone(),
                skip_archival: opts.skip_archival,
                wait_new_event: opts.wait_new_event,
                history_event_filter_type: opts.event_filter_type as i32,
                ..Default::default()
            }
            .into_request(),
        )
        .await
        .map_err(|status| {
            if status.code() == Code::NotFound {
                WorkflowInteractionError::NotFound(status)
            } else {
                WorkflowInteractionError::Rpc(status)
            }
        })?
        .into_inner();

        if let Some(history) = response.history {
            all_events.extend(history.events);
        }

        if response.next_page_token.is_empty() {
            break;
        }
        next_page_token = response.next_page_token;
    }

    Ok(all_events)
}

rustler::init!("Elixir.Temporal.CoreSdk");
