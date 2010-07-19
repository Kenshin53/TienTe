require 'rubygems'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'nokogiri'
require 'open-uri'

require 'currency'
require 'test/unit'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/currency.sqlite3")
DataMapper.auto_upgrade!

class VCBParser 
  XPath_Query = '//div[@id="exch-rates"]/div/table/tr[position()>1]'
  def initialize(path)
    @doc = Nokogiri::HTML(open(path))
  end
  
  def parse_doc
    @doc.xpath(XPath_Query).each do |row|
      currency = parse_a_row(row)
      if currency.save
        puts 'Save successful'
      else
        puts 'Save failed'
      end
    end
  end

  def get_a_html_node(xpath_query)
    @doc.xpath(xpath_query)
  end
  
  def parse_a_row(a_row)
     a_currency = Currency.new
     a_currency.bank_code      = "VCB"
     a_currency.currency_code  = a_row.children[0].content.downcase.lstrip.rstrip
     a_currency.buy_in_cash    = a_row.children[2].content.lstrip.rstrip.gsub(',','').to_f
     a_currency.sell_in_cash   = a_row.children[4].content.lstrip.rstrip.gsub(',','').to_f
     a_currency.transfer        = a_row.children[3].content.lstrip.rstrip.gsub(',','').to_f
     return a_currency
  end
end


class TestVCBParser < Test::Unit::TestCase
  def test_data_sample
    parser = VCBParser.new('data_sample/VCB.html')
    assert_not_nil(parser, 'Could not init the parser')
    
    usd_currency = Currency.new
    usd_currency.bank_code = "VCB"
    usd_currency.currency_code = "usd"
    usd_currency.buy_in_cash = 19080.00
    usd_currency.sell_in_cash = 19095.00
    usd_currency.transfer = 19080.00 
    
    gbp_currency = Currency.new
    gbp_currency.bank_code = "VCB"
    gbp_currency.currency_code = "gbp"
    gbp_currency.buy_in_cash = 28358.62
    gbp_currency.sell_in_cash = 28951.38
    gbp_currency.transfer = 28558.53
    get_gbp_query = '//div[@id="exch-rates"]/div/table/tr[7]'
    gbp_node = parser.get_a_html_node(get_gbp_query)
    result_currency = parser.parse_a_row(gbp_node)
    assert_equal(gbp_currency, result_currency, 'GBP cannot be read correctly')
    
    
    assert_not_nil(usd_currency, 'Cannot init usd_currency object')
    
    get_usd_query = '//div[@id="exch-rates"]/div/table/tr[last()]'
    usd_node = parser.get_a_html_node(get_usd_query)
    assert_not_nil(usd_node, 'Cannot get the node')
    result_currency = parser.parse_a_row(usd_node)
    
    assert_equal(usd_currency, result_currency, 'USD cannot be read correctly')
   
  end
  
  
end

VCB_URL = 'http://www.vietcombank.com.vn/ExchangeRates/'
VCBParser.new(VCB_URL).parse_doc


