use std::sync::Mutex;
use temporalio_sdk_core::{CoreRuntime, RuntimeOptions, TokioRuntimeBuilder};
use rustler::{Resource, ResourceArc};

pub struct ElixirRuntime {
    pub core: Mutex<CoreRuntime>,
}

#[rustler::resource_impl]
impl Resource for ElixirRuntime {}

#[rustler::nif]
fn new_runtime() -> Option<ResourceArc<ElixirRuntime>> {
    let opts = RuntimeOptions::default();

    let core = CoreRuntime::new(opts, TokioRuntimeBuilder::default());

    match core {
        Ok(new_core) => {
            println!("working with runtime!");
            let runtime = ElixirRuntime{
                core: Mutex::new(new_core)
            };

            Some(ResourceArc::new(runtime))
        },
        Err(e) => {
            println!("Error creating runtime: {e:?}");
            None
        },
    }
}

rustler::init!("Elixir.Temporal.CoreSdk");
