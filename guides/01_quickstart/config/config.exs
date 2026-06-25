import Config

config :temporal, engine: TemporalEngineNif.Engine
config :temporal_engine, json_encoder: Jason
