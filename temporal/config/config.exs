import Config

if File.exists?("config/#{config_env()}.local.exs") do
  import_config "#{config_env()}.local.exs"
end
