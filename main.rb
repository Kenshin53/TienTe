require 'currency'
require 'sinatra'


require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'sass'
require 'haml'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/currency.sqlite3")


# get '/style.css' do
#   sass :style
# end

get '/:bank_code' do |bankcode|
  
  bankcode.upcase!
  a_currency = Currency.first(:bank_code => bankcode, :order => [:updated_at.desc])
  if a_currency != nil
    last_update = a_currency.updated_at
    @currency_list = Currency.all(:updated_at.gte => last_update) 
    haml :index
  else 
    @error_message = "Couldn't find the bank input"
    haml  :index
  end
  
  
end