# Vandal UI

This is a Rails engine for
[Graphiti](https://graphiti-api.github.io/graphiti/guides/) APIs. It has
two main functions:

* `rake vandal:install` will copy static files to `public/<api_namespace>`.
* Mounting the engine adds an endpoint for a dynamically-generated
  schema file:

```ruby
# config/routes.rb

scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
  # ... routes ...

  mount VandalUi::Engine, at: '/vandal'
end
```

If `ApplicationRecord.endpoint_namespace` is `/api/v1`, you'd get a
`/api/v1/vandal/schema.json` that would be referenced when loading the
UI.
