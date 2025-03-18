module VandalUi
  class Engine < ::Rails::Engine
    config.app_middleware.use(
      Rack::Static,
      urls: ['/js', '/css', '/assets/img'],
      root: VandalUi::Engine.root.join('lib/vandal_ui/static')
    )
  end
end
