VandalUi::Engine.routes.draw do
  get '/schema', to: 'vandal_ui/schemas#show'
end
