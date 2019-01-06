module VandalUi
  class Railtie < ::Rails::Railtie
    rake_tasks do
      path = File.expand_path(__dir__)
      load "#{path}/tasks.rb"
    end
  end
end
