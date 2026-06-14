import Config

config :logger, level: :debug

config :temporal, engine: TemporalEngineNif.Engine
