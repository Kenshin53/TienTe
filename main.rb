require 'currency'
require 'sinatra'


require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'sass'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/currency.sqlite3")


get '/style.css' do
  sass :style
end

get '/' do
  @currency_list = Currency.all    
  haml :index
  
end