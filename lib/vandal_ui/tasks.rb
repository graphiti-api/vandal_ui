namespace :vandal do
  task :install do
    cfg = YAML.load_file("#{Rails.root}/.graphiticfg.yml")
    namespace = cfg['namespace']
    schema_path = "#{namespace}/schema.json"

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
  end
end
