use rustler::{NifStruct, Resource, ResourceArc};
use std::sync::Mutex;
use std::time::Duration;
use temporalio_sdk_core::{CoreRuntime, RuntimeOptions, TokioRuntimeBuilder};

pub struct ElixirRuntime {
    #[allow(dead_code)]
    pub core: Mutex<CoreRuntime>,
}

#[rustler::resource_impl]
impl Resource for ElixirRuntime {}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.RuntimeOpts"]
struct SdkRuntimeOpts {
    heartbeat_interval_secs: Option<u64>,
}

#[rustler::nif]
fn _create_runtime(opts: Option<SdkRuntimeOpts>) -> Result<ResourceArc<ElixirRuntime>, String> {
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
                core: Mutex::new(new_core),
            };

            Ok(ResourceArc::new(runtime))
        }
        Err(e) => Err(format!("Error creating runtime: {e:?}")),
    }
}
