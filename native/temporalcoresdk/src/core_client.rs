use crate::core_runtime::ElixirRuntime;
use rustler::{LocalPid, NifStruct, OwnedEnv, Resource, ResourceArc};
use std::collections::HashMap;
use std::sync::Mutex;
use std::time::Duration;
use temporalio_sdk_client::{
    ClientKeepAliveOptions, ClientTlsOptions, Connection, ConnectionOptions,
    DnsLoadBalancingOptions, HttpConnectProxyOptions, RetryOptions, TlsOptions,
};
use tracing::{error, warn};
use url::Url;

pub struct ElixirClient {
    #[allow(dead_code)]
    pub connection: Mutex<Connection>,
}

#[rustler::resource_impl]
impl Resource for ElixirClient {}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientOpts"]
struct SdkClientOpts {
    target_host: String,
    client_name: String,
    client_version: String,
    identity: String,
    headers: Option<HashMap<String, String>>,
    binary_headers: Option<HashMap<String, Vec<u8>>>,
    api_key: Option<String>,
    tls: Option<SdkClientTlsOpts>,
    rpc_retry: SdkClientRetryOpts,
    keep_alive: Option<SdkClientKeepAliveOpts>,
    http_connect_proxy: Option<SdkClientHttpConnectProxyOpts>,
    dns_load_balancing: Option<SdkClientDnsLoadBalancingOpts>,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientTlsOpts"]
struct SdkClientTlsOpts {
    client_cert: Option<String>,
    client_private_key: Option<String>,
    server_root_ca_cert: Option<String>,
    domain: Option<String>,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientRetryOpts"]
struct SdkClientRetryOpts {
    initial_interval_secs: f64,
    randomization_factor: f64,
    multiplier: f64,
    max_interval_secs: f64,
    max_elapsed_time_secs: f64,
    max_retries: u32,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientKeepAliveOpts"]
struct SdkClientKeepAliveOpts {
    interval_secs: f64,
    timeout_secs: f64,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientHttpConnectProxyOpts"]
struct SdkClientHttpConnectProxyOpts {
    target_host: String,
    basic_auth_user: Option<String>,
    basic_auth_pass: Option<String>,
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts"]
struct SdkClientDnsLoadBalancingOpts {
    resolution_interval_secs: f64,
}

#[rustler::nif]
fn _create_client(
    runtime: ResourceArc<ElixirRuntime>,
    options: SdkClientOpts,
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
    let core_runtime = runtime.core.lock().unwrap();
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
        .maybe_metrics_meter(core_runtime.telemetry().get_temporal_metric_meter())
        .build();

    core_runtime.tokio_handle().spawn(async move {
        let mut owned_env = OwnedEnv::new();
        match Connection::connect(opts).await {
            Ok(conn) => {
                owned_env
                    .send_and_clear(&resp_pid, |_curr_env| {
                        let resp: Result<ResourceArc<ElixirClient>, String> =
                            Ok(ResourceArc::new(ElixirClient {
                                connection: Mutex::new(conn),
                            }));
                        resp
                    })
                    .unwrap_or_else(|err| {
                        error!("Error sending client response message: {:?}", err)
                    });
            }

            Err(err) => {
                owned_env
                    .send_and_clear(&resp_pid, |_curr_env| {
                        let resp: Result<ResourceArc<ElixirClient>, String> =
                            Err(format!("Error creating Elixir client: {}", err));
                        resp
                    })
                    .unwrap_or_else(|err| {
                        error!("Error sending client response message: {:?}", err)
                    });
            }
        };
    });

    Ok(true)
}
