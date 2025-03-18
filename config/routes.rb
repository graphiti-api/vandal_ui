VandalUi::Engine.routes.draw do
  root to: 'vandal_ui/static#index'
  get '/schema', to: 'vandal_ui/schemas#show'
end
