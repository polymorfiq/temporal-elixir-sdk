use rustler::{
    Atom, Binary, Decoder, Encoder, Env, Error, NifRecord, NifResult, OwnedBinary, Term,
};
use std::collections::HashMap;
use temporalio_sdk_common::data_converters::{
    PayloadConversionError, SerializationContext, TemporalDeserializable, TemporalSerializable,
};
use temporalio_sdk_common::protos::temporal::api::common::v1::payload::ExternalPayloadDetails;
use temporalio_sdk_common::protos::temporal::api::common::v1::Payload;

mod atoms {
    rustler::atoms! {
        payload,
        payloads_test,
    }
}

#[derive(Debug, Clone)]
pub struct SdkPayload {
    pub metadata: HashMap<String, Vec<u8>>,
    pub data: Vec<u8>,
    pub external_payloads: Vec<SdkExternalPayloadDetails>,
}

impl Decoder<'_> for SdkPayload {
    fn decode(term: Term) -> NifResult<SdkPayload> {
        if term.is_tuple() {
            let data: (
                Atom,
                HashMap<String, Binary>,
                Binary,
                Vec<SdkExternalPayloadDetails>,
            ) = term.decode()?;

            if data.0 == atoms::payload() {
                let payload = SdkPayload {
                    metadata: data
                        .1
                        .iter()
                        .map(|(k, v)| (k.to_string(), v.to_vec()))
                        .collect(),
                    data: data.2.as_slice().to_vec(),
                    external_payloads: data.3.as_slice().to_vec(),
                };

                Ok(payload)
            } else {
                Err(Error::BadArg)
            }
        } else {
            Err(Error::BadArg)
        }
    }
}

impl Encoder for SdkPayload {
    fn encode<'a>(&self, env: Env<'a>) -> Term<'a> {
        let metadata: HashMap<String, Term> = self
            .metadata
            .iter()
            .map(|(k, v)| {
                let mut bin = OwnedBinary::new(v.len()).expect("Could not allocate payload metadata buffer");
                bin.copy_from_slice(&v);

                (k.to_string(), bin.release(env).encode(env))
            })
            .collect();

        let mut data = OwnedBinary::new(self.data.len()).expect("Could not allocate payload data buffer");
        data.copy_from_slice(&self.data);

        (
            atoms::payload(),
            metadata,
            data.release(env).encode(env),
            self.external_payloads.clone(),
        )
            .encode(env)
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "external_payload_details"]
pub struct SdkExternalPayloadDetails {
    pub size_bytes: i64,
}

impl From<ExternalPayloadDetails> for SdkExternalPayloadDetails {
    fn from(external: ExternalPayloadDetails) -> Self {
        Self {
            size_bytes: external.size_bytes,
        }
    }
}

impl Into<ExternalPayloadDetails> for SdkExternalPayloadDetails {
    fn into(self) -> ExternalPayloadDetails {
        ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

impl Into<ExternalPayloadDetails> for &SdkExternalPayloadDetails {
    fn into(self) -> ExternalPayloadDetails {
        ExternalPayloadDetails {
            size_bytes: self.size_bytes,
        }
    }
}

impl From<Payload> for SdkPayload {
    fn from(external: Payload) -> Self {
        let mut data =
            OwnedBinary::new(external.data.len()).expect("failed to allocate payload data buffer");
        data.as_mut_slice()
            .copy_from_slice(external.data.as_slice());

        Self {
            metadata: external.metadata,
            data: external.data,
            external_payloads: external
                .external_payloads
                .iter()
                .map(|val| (*val).into())
                .collect(),
        }
    }
}

impl From<&Payload> for SdkPayload {
    fn from(external: &Payload) -> Self {
        let mut data =
            OwnedBinary::new(external.data.len()).expect("failed to allocate payload data buffer");
        data.as_mut_slice()
            .copy_from_slice(external.data.as_slice());

        Self {
            metadata: external.metadata.clone(),
            data: external.data.clone().into(),
            external_payloads: external
                .external_payloads
                .iter()
                .map(|val| (*val).into())
                .collect(),
        }
    }
}

impl Into<Payload> for SdkPayload {
    fn into(self) -> Payload {
        Payload {
            metadata: self.metadata.clone(),
            data: self.data,
            external_payloads: self
                .external_payloads
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

impl Into<Payload> for &SdkPayload {
    fn into(self) -> Payload {
        Payload {
            metadata: self.metadata.clone(),
            data: self.data.clone().into(),
            external_payloads: self
                .external_payloads
                .iter()
                .map(|val| val.clone().into())
                .collect(),
        }
    }
}

#[derive(Debug, NifRecord, Clone)]
#[tag = "workflow_arguments"]
pub struct SdkWorkflowArguments {
    pub args: Vec<SdkPayload>,
}

impl TemporalDeserializable for SdkWorkflowArguments {
    fn from_payloads(
        _ctx: &SerializationContext<'_>,
        payloads: Vec<Payload>,
    ) -> Result<Self, PayloadConversionError> {
        let mut args: Vec<SdkPayload> = vec![];
        for (_idx, payload) in payloads.iter().enumerate() {
            args.push(payload.clone().into());
        }

        Ok(Self { args })
    }
}

impl TemporalSerializable for SdkWorkflowArguments {
    fn to_payloads(
        &self,
        _ctx: &SerializationContext<'_>,
    ) -> Result<Vec<Payload>, PayloadConversionError> {
        let mut payloads = vec![];
        for (_idx, arg) in self.args.iter().enumerate() {
            payloads.push(arg.clone().into())
        }

        Ok(payloads)
    }
}
