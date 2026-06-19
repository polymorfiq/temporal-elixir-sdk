use crate::common::SdkDuration;
use rustler::{NifStruct, Resource};
use std::collections::HashMap;
use temporalio_sdk_client::{
    Client, ClientKeepAliveOptions, ClientTlsOptions, DnsLoadBalancingOptions,
    HttpConnectProxyOptions, RetryOptions, TlsOptions,
};
use temporalio_sdk_common::protos::utilities::TryIntoOrNone;

pub struct ElixirClient {
    pub client: Client,
}

#[rustler::resource_impl]
impl Resource for ElixirClient {}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.ConnectionOpts"]
pub struct SdkConnectionOpts {
    pub target: String,
    pub namespace: String,
    pub identity: String,
    pub tls_options: Option<SdkTlsOpts>,
    pub override_origin: Option<String>,
    pub api_key: Option<String>,
    pub retry_options: Option<SdkClientRetryOpts>,
    pub client_name: String,
    pub client_version: String,
    pub headers: Option<HashMap<String, String>>,
    pub binary_headers: Option<HashMap<String, Vec<u8>>>,
    pub keep_alive: Option<SdkClientKeepAliveOpts>,
    pub http_connect_proxy: Option<SdkClientHttpConnectProxyOpts>,
    pub dns_load_balancing: Option<SdkClientDnsLoadBalancingOpts>,
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.TlsOpts"]
pub struct SdkTlsOpts {
    pub server_root_ca_cert: Option<String>,
    pub domain: Option<String>,
    pub client_tls_options: Option<SdkClientTlsOpts>,
}

impl From<TlsOptions> for SdkTlsOpts {
    fn from(external: TlsOptions) -> Self {
        Self {
            server_root_ca_cert: external.server_root_ca_cert.try_into_or_none(),
            domain: external.domain.try_into_or_none(),
            client_tls_options: external.client_tls_options.try_into_or_none(),
        }
    }
}

impl Into<TlsOptions> for SdkTlsOpts {
    fn into(self) -> TlsOptions {
        TlsOptions {
            server_root_ca_cert: self.server_root_ca_cert.try_into_or_none(),
            domain: self.domain.try_into_or_none(),
            client_tls_options: self.client_tls_options.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.ClientTlsOpts"]
pub struct SdkClientTlsOpts {
    pub client_cert: Vec<u8>,
    pub client_private_key: Vec<u8>,
}

impl From<ClientTlsOptions> for SdkClientTlsOpts {
    fn from(external: ClientTlsOptions) -> Self {
        Self {
            client_cert: external.client_cert,
            client_private_key: external.client_private_key,
        }
    }
}

impl Into<ClientTlsOptions> for SdkClientTlsOpts {
    fn into(self) -> ClientTlsOptions {
        ClientTlsOptions {
            client_cert: self.client_cert,
            client_private_key: self.client_private_key,
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.RetryOpts"]
pub struct SdkClientRetryOpts {
    pub initial_interval: SdkDuration,
    pub randomization_factor: f64,
    pub multiplier: f64,
    pub max_interval: SdkDuration,
    pub max_elapsed_time: Option<SdkDuration>,
    pub max_retries: usize,
}

impl From<RetryOptions> for SdkClientRetryOpts {
    fn from(external: RetryOptions) -> Self {
        Self {
            initial_interval: external.initial_interval.into(),
            randomization_factor: external.randomization_factor,
            multiplier: external.multiplier,
            max_interval: external.max_interval.into(),
            max_elapsed_time: external.max_elapsed_time.try_into_or_none(),
            max_retries: external.max_retries.into(),
        }
    }
}

impl Into<RetryOptions> for SdkClientRetryOpts {
    fn into(self) -> RetryOptions {
        RetryOptions {
            initial_interval: self.initial_interval.into(),
            randomization_factor: self.randomization_factor,
            multiplier: self.multiplier,
            max_interval: self.max_interval.into(),
            max_elapsed_time: self.max_elapsed_time.try_into_or_none(),
            max_retries: self.max_retries.into(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.KeepAliveOpts"]
pub struct SdkClientKeepAliveOpts {
    pub interval: SdkDuration,
    pub timeout: SdkDuration,
}

impl From<ClientKeepAliveOptions> for SdkClientKeepAliveOpts {
    fn from(external: ClientKeepAliveOptions) -> Self {
        Self {
            interval: external.interval.into(),
            timeout: external.timeout.into(),
        }
    }
}

impl Into<ClientKeepAliveOptions> for SdkClientKeepAliveOpts {
    fn into(self) -> ClientKeepAliveOptions {
        ClientKeepAliveOptions {
            interval: self.interval.into(),
            timeout: self.timeout.into(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.HttpProxyOpts"]
pub struct SdkClientHttpConnectProxyOpts {
    pub target_addr: String,
    pub basic_auth: Option<(String, String)>,
}

impl From<HttpConnectProxyOptions> for SdkClientHttpConnectProxyOpts {
    fn from(external: HttpConnectProxyOptions) -> Self {
        Self {
            target_addr: external.target_addr,
            basic_auth: external.basic_auth.try_into_or_none(),
        }
    }
}

impl Into<HttpConnectProxyOptions> for SdkClientHttpConnectProxyOpts {
    fn into(self) -> HttpConnectProxyOptions {
        HttpConnectProxyOptions {
            target_addr: self.target_addr,
            basic_auth: self.basic_auth.try_into_or_none(),
        }
    }
}

#[derive(NifStruct, Clone)]
#[module = "TemporalEngine.Opts.ClientOpts.DnsLbOpts"]
pub struct SdkClientDnsLoadBalancingOpts {
    pub resolution_interval: SdkDuration,
}

impl From<DnsLoadBalancingOptions> for SdkClientDnsLoadBalancingOpts {
    fn from(external: DnsLoadBalancingOptions) -> Self {
        Self {
            resolution_interval: external.resolution_interval.into(),
        }
    }
}

impl Into<DnsLoadBalancingOptions> for SdkClientDnsLoadBalancingOpts {
    fn into(self) -> DnsLoadBalancingOptions {
        let mut opts = DnsLoadBalancingOptions::default();
        opts.resolution_interval = self.resolution_interval.into();
        opts
    }
}
