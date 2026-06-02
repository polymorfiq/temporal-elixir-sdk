mod core_runtime;
mod core_client;
mod core_worker;

mod atoms {
    rustler::atoms! {
        ok,
    }
}

rustler::init!("Elixir.Temporal.CoreSdk");