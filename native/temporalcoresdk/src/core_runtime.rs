use rustler::{NifStruct, Resource};
use std::sync::{Arc, RwLock};
use temporalio_sdk_core::CoreRuntime;
use crate::common::SdkDuration;

pub struct ElixirRuntime {
    #[allow(dead_code)]
    pub core: RwLock<Arc<CoreRuntime>>,
}

#[rustler::resource_impl]
impl Resource for ElixirRuntime {}

#[derive(NifStruct)]
#[module = "TemporalEngineNif.Data.RuntimeOpts"]
pub struct SdkRuntimeOpts {
    pub heartbeat_interval: Option<SdkDuration>,
}
