use rustler::{NifStruct, Resource};
use std::sync::{Arc, RwLock};
use temporalio_sdk_core::CoreRuntime;

pub struct ElixirRuntime {
    #[allow(dead_code)]
    pub core: RwLock<Arc<CoreRuntime>>,
}

#[rustler::resource_impl]
impl Resource for ElixirRuntime {}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.RuntimeOpts"]
pub struct SdkRuntimeOpts {
    pub heartbeat_interval_secs: Option<u64>,
}
