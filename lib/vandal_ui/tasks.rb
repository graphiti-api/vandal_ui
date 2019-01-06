namespace :vandal do
  task :install do
    source = File.join(File.dirname(__FILE__), 'static')
    destination = "#{Rails.root}/public/api/v1"
    FileUtils.rm_rf "#{destination}/vandal"
    FileUtils.mkdir_p destination
    FileUtils.copy_entry(source, "#{destination}/vandal")

    # Document schema path and override
    # Commit graphiti incorporating api namespace to schema path. Document the old.
    # Maybe even do this in script?
    #
    # Vandal in isolation
    # Remove demo path from vandal
    # Ensure "open in new tab" works
    # Ensure curl works
    cfg = YAML.load_file("#{Rails.root}/.graphiticfg.yml")
    schema_path = "#{cfg['namespace']}/schema.json"
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
