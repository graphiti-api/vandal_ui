namespace :vandal do
  task install: [:environment] do
    graphiti_config_path = "#{Rails.root}/.graphiticfg.yml"
    unless File.exist?(graphiti_config_path)
      raise "Valid graphiti config file is required in the Rails root directory.\n" \
            'More information: https://www.graphiti.dev/guides/getting-started/installation#graphiticfg'
    end

    cfg = YAML.load_file(graphiti_config_path)
    namespace = cfg['namespace']
    use_custom_header = cfg['useCustomHeader']
    use_remote_server = cfg['useRemoteServer']

    vandal_path = VandalUi::Engine.routes.find_script_name({})
    schema_path = "#{vandal_path}/schema.json"

    source = File.join(File.dirname(__FILE__), 'static')
    destination = "#{Rails.root}/public/#{namespace}"
    FileUtils.rm_rf "#{destination}/vandal"
    FileUtils.mkdir_p destination
    FileUtils.copy_entry(source, "#{destination}/vandal")

    path = "#{destination}/vandal/index.html"
    lines = IO.readlines(path).map do |line|
      if line.include?('__SCHEMA_PATH__')
        line.gsub('__SCHEMA_PATH__', ENV.fetch('SCHEMA_PATH', schema_path))
      else
        line
      end
    end

    File.open(path, 'w') do |file|
      file.puts lines
    end


    lines = IO.readlines(path).map do |line|
      if line.include?('__REMOTE_HOSTS__')
        line.gsub('__REMOTE_HOSTS__', "'" + ENV.fetch('REMOTE_HOSTS', "[]") + "'")
      else
        line
      end
    end

    lines = IO.readlines(path).map do |line|
      if use_remote_server && use_custom_header
        line = line.gsub('__USE_CUSTOM_HEADER__', '"true"')
        line = line.gsub('__USE_REMOTE_HOSTS__', '"true"')
        line
      elsif use_remote_server
        line.gsub('__USE_REMOTE_HOSTS__', '"true"')
      elsif use_custom_header
        line.gsub('__USE_CUSTOM_HEADER__', '"true"')
      else
        line
      end
    end

    File.open(path, 'w') do |file|
      file.puts lines
    end
  end
end
