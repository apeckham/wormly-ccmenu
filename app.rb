require 'rack/cache'
require 'sinatra'
require File.dirname(__FILE__) + '/wormly'

use Rack::Cache, verbose: true

get '/cctray.xml' do
  cache_control :public, :max_age => 120
  erb :cctray, locals: {my_hosts: Wormly.my_hosts}
end