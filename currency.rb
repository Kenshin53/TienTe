require 'rubygems'
require 'dm-core'



class Currency
  include DataMapper::Resource
  
  property :id,               Serial
  property :bank_code,        String ,  :required => true
  property :currency_code,    Text,     :required => true
  property :buy_in_cash,      Float
  property :transfer,         Float
  property :sell_in_cash,     Float
  property :updated_at,       DateTime
  
  #validating code !!!
  
  def to_s
    "Currency Type: #{@currency_code} -- Buy: #{@buy_in_cash} -- Sell: #{@sell_in_cash} -- Tranfer: #{@transfer} -- Updated: #{@updated_at}"
  end
end
