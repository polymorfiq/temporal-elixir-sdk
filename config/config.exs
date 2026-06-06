import Config

if File.exists?("config/dev.exs") do
  import_config "dev.exs"
end
