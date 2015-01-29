require 'sinatra'
require 'sinatra/activerecord'

get '/' do
  haml :index
end
