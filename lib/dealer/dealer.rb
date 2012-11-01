class Dealer
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :address_1, :address_2, :city, :id, :name, :phone, :state, :website, :zipcode, :active_catalogs, :latitude, :longitude

  def self.find(id)
    Rails.cache.fetch :dealer => id do
       dealer = JSON.parse(Nestful.get(DIDealer.options[:url] + "/#{id}.json", :headers => DIDealer.api_headers))
       Dealer.new(dealer)
    end
  end

  def initialize(dealer)
    @id = dealer["id"]
    @name = dealer["name"]
    @address_1 = dealer["address_1"]
    @address_2 = dealer["address_2"]
    @city = dealer["city"]
    @state = dealer["state"]
    @zipcode = dealer["zipcode"]
    @phone = dealer["phone"]
    @website = dealer["website"]
    @active_catalogs = dealer["active_catalogs"]
    @latitude = dealer["latitude"]
    @longitude = dealer["longitude"]
    self
  end

  def self.all
    JSON.parse(Nestful.get(DIDealer.options[:url] + ".json", :headers => DIDealer.api_headers)).collect { |dealer| Dealer.new(dealer) }
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Dealer")
  end

  def persisted?
    true
  end
end
