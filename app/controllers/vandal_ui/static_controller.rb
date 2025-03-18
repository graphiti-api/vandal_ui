class VandalUi::StaticController < ActionController::Base
  layout false

  def index
    vandal_path = VandalUi::Engine.routes.find_script_name({})
    @schema_path = "#{vandal_path}/schema.json"
  end
end
