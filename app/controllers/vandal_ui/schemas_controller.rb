class VandalUi::SchemasController < ActionController::API
  def show
    Rails.application.eager_load!
    render json: Graphiti::Schema.generate
  end
end
