use rustler::{NifStruct, Resource};
use std::collections::HashMap;
use temporalio_sdk_client::Client;

pub struct ElixirClient {
    pub client: Client,
}

#[rustler::resource_impl]
impl Resource for ElixirClient {}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientOpts"]
pub struct SdkClientOpts {
    pub target_host: String,
    pub namespace: String,
    pub client_name: String,
    pub client_version: String,
    pub identity: String,
    pub headers: Option<HashMap<String, String>>,
    pub binary_headers: Option<HashMap<String, Vec<u8>>>,
    pub api_key: Option<String>,
    pub tls: Option<SdkClientTlsOpts>,
    pub rpc_retry: SdkClientRetryOpts,
    pub keep_alive: Option<SdkClientKeepAliveOpts>,
    pub http_connect_proxy: Option<SdkClientHttpConnectProxyOpts>,
    pub dns_load_balancing: Option<SdkClientDnsLoadBalancingOpts>,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientTlsOpts"]
pub struct SdkClientTlsOpts {
    pub client_cert: Option<String>,
    pub client_private_key: Option<String>,
    pub server_root_ca_cert: Option<String>,
    pub domain: Option<String>,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientRetryOpts"]
pub struct SdkClientRetryOpts {
    pub initial_interval_secs: f64,
    pub randomization_factor: f64,
    pub multiplier: f64,
    pub max_interval_secs: f64,
    pub max_elapsed_time_secs: f64,
    pub max_retries: u32,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientKeepAliveOpts"]
pub struct SdkClientKeepAliveOpts {
    pub interval_secs: f64,
    pub timeout_secs: f64,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientHttpConnectProxyOpts"]
pub struct SdkClientHttpConnectProxyOpts {
    pub target_host: String,
    pub basic_auth_user: Option<String>,
    pub basic_auth_pass: Option<String>,
}

#[derive(NifStruct, Clone)]
#[module = "Temporal.CoreSdk.Data.ClientDnsLoadBalancingOpts"]
pub struct SdkClientDnsLoadBalancingOpts {
    pub resolution_interval_secs: f64,
}
