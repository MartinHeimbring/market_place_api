Rails.application.routes.draw do
  # Api definition
  namespace :api , defaults: { format: :json },
            constraints: { subdomain: 'api' }, path: '/'  do
            # generate a base_ui under a subdomain
    # I'll access the api at api.market_place_api.dev (using pow)

  end
end
