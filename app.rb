require 'rack/cache'
require 'sinatra'

use Rack::Cache, verbose: true

get '/cctray.xml' do
  cache_control :public, :max_age => 10
  erb :cctray
end