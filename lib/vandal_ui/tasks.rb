namespace :vandal do
  task install: [:environment] do
    graphiti_config_path = "#{Rails.root}/.graphiticfg.yml"
    unless File.exist?(graphiti_config_path)
      raise "Valid graphiti config file is required in the Rails root directory.\n" \
            'More information: https://www.graphiti.dev/guides/getting-started/installation#graphiticfg'
    end

    cfg = YAML.load_file(graphiti_config_path)
    namespace = cfg['namespace']

    vandal_path = VandalUi::Engine.routes.find_script_name({})
    schema_path = "#{vandal_path}/schema.json"

    source = File.join(File.dirname(__FILE__), 'static')
    destination = "#{Rails.root}/public/#{namespace}"
    FileUtils.rm_rf "#{destination}/vandal"
    FileUtils.mkdir_p destination
    FileUtils.copy_entry(source, "#{destination}/vandal")

    puts ENV['REMOTE_HOSTS']

    path = "#{destination}/vandal/index.html"
    file = File.read(path)
    if file.include?('__SCHEMA_PATH__') && file.include?('__REMOTE_HOSTS__')
      file.gsub('__REMOTE_HOSTS__', ENV.fetch('REMOTE_HOSTS'))
      file.gsub('__SCHEMA_PATH__', ENV.fetch('SCHEMA_PATH', schema_path))
    elsif file.include?('__SCHEMA_PATH__')
      file.gsub('__SCHEMA_PATH__', ENV.fetch('SCHEMA_PATH', schema_path))
    else
      file
    end

    puts file

    File.open(path, 'w') do |f|
      f.puts file
    end
  end
end
