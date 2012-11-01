require 'nestful'
require 'active_model'
require 'rails'

module DIDealer
  NotConfiguredError = Class.new(StandardError)

  def self.options
    if @options.nil?
      raise NotConfiguredError.new "Run DIDealer.configure in the Rails setup before attempting to load a dealer."
    end

    @options
  end

  def self.options= options
    @options = options
  end

  def self.configure options = {}
    @options = {
      url: "https://app.dealerignition.com/api/dealers",
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
