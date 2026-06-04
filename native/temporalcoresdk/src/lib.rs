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

rustler::init!("Elixir.Temporal.CoreSdk");
