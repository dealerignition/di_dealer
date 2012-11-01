class Dealer
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  ATTRIBUTES = [:address_1, :address_2, :city, :id, :name, :phone, :state, :website, :zipcode, :active_catalogs, :active_promotions, :latitude, :longitude]
  ATTRIBUTES.each { |a| attr_accessor a }

  def self.find(id, brand = nil)
    Rails.cache.fetch :dealer => id, :brand => brand do
       dealer = JSON.parse(Nestful.get(
         DIDealer.options[:url] + "/#{id}.json" + (brand.nil? ? "" : "&brand=#{ brand }"),
         :headers => DIDealer.api_headers))
       Dealer.new(dealer)
    end
  end

  def initialize(dealer)
    ATTRIBUTES.each do |a|
      self.instance_variable_set "@#{a}", dealer[a.to_s]
    end

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
