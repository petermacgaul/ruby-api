# frozen_string_literal: true

require 'sinatra/base'

# HealthRouter handles the health check route.
# It inherits from Sinatra::Base to gain access to Sinatra's DSL for defining routes.
class HealthRouter < Sinatra::Base
  get '/health' do
    'Ping!'
  end
end
