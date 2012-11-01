require 'nestful'
require 'active_model'
require 'rails'

module DIDealer
  def self.options
    @options
  end

  def self.configure options = {}
    @options = {
      url: "https://www.dealerignition.com/api/dealers",
      api_key: nil
    }
    @options.merge! options

    if Rails.env.development?
      @options[:url] = "http://localhost:3000/api/dealers"
    end
  end

  def self.api_headers
    { "API_KEY" => @options[:api_key] }
  end
end

require 'dealer/dealer'
