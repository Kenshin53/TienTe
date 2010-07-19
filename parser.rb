class Parser 

  def initialize(path, xpath_query)
    @doc = Nokogiri::HTML(open(path))
    @xpath_query = xpath_query
  end
  
  def parse_doc
    @doc.xpath(@xpath_query).each do |row|
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
end