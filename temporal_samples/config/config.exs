import Config

config :logger, level: :debug

config :temporal, engine: TemporalEngineNif.Engine
config :temporal_engine, json_encoder: Jason

if File.exists?("config/#{config_env()}.local.exs") do
  import_config "#{config_env()}.local.exs"
end
