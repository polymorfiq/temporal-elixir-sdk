use rustler::NifStruct;

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.Duration"]
pub struct SdkDuration {
    seconds: i64,
    nanos: i32,
}

impl From<prost_wkt_types::Duration> for SdkDuration {
    fn from(external: prost_wkt_types::Duration) -> Self {
        Self {
            seconds: external.seconds,
            nanos: external.nanos,
        }
    }
}

#[derive(NifStruct)]
#[module = "Temporal.CoreSdk.Data.Timestamp"]
pub struct SdkTimestamp {
    seconds: i64,
    nanos: i32,
}

impl From<prost_wkt_types::Timestamp> for SdkTimestamp {
    fn from(external: prost_wkt_types::Timestamp) -> Self {
        Self {
            seconds: external.seconds,
            nanos: external.nanos,
        }
    }
}
