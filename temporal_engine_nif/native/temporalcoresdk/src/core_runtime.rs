use crate::common::SdkDuration;
use rustler::{NifRecord, Resource};
use std::sync::{Arc, RwLock};
use temporalio_sdk_core::CoreRuntime;

pub struct ElixirRuntime {
    #[allow(dead_code)]
    pub core: RwLock<Arc<CoreRuntime>>,
}

#[rustler::resource_impl]
impl Resource for ElixirRuntime {}

#[derive(Debug, NifRecord, Clone)]
#[tag = "runtime_opts"]
pub struct SdkRuntimeOpts {
    pub id: String,
    pub heartbeat_interval: Option<SdkDuration>,
}
