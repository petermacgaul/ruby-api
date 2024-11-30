# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'json'

require_relative 'db'

require_relative 'models/user'

require_relative 'routes/health'
require_relative 'routes/products'
require_relative 'routes/authorization'
require_relative 'routes/users'

require_relative 'helpers/jwt_helpers'

# MainApp is the main Sinatra application.
# It inherits from Sinatra::Base to gain access to Sinatra's DSL for defining routes.
class MainApp < Sinatra::Base
  configure do
    set :port, ENV['PORT'] || 4567
    set :bind, '0.0.0.0'
    set :public_folder, 'public'
  end

  use Rack::Deflater

  helpers JWTHelpers

  use HealthRouter
  use UsersRouter
  use AuthorizationRouter
  use ProductsRouter

  get '/' do
    'Welcome to the main app!'
  end

  get '/authors' do
    ttl = 86_400 # 24 * 60 * 60
    cache_control :public, max_age: ttl
    send_file File.join(settings.root, '../AUTHORS'), type: 'text/plain'
  end

  get '/docs' do
    redirect '/index.html'
  end
end
