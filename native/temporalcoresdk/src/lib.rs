mod common;
mod core_client;
mod core_runtime;
mod core_worker;
mod core_workflows;
mod core_activites;
mod core_nexus;

mod atoms {
    rustler::atoms! {
        ok,
    }
}

rustler::init!("Elixir.Temporal.CoreSdk");
