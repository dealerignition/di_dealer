class Dealer
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  ATTRIBUTES = [:address_1, :address_2, :city, :id, :name, :phone, :state, :website, :zipcode, :active_catalogs, :active_promotions, :latitude, :longitude, :logo_url]
  ATTRIBUTES.each { |a| attr_accessor a }

  def self.find(id, brand = nil)
    Rails.cache.fetch :dealer => id, :brand => brand do
      # Always cache the JSON, it never changes
      dealer = Rails.cache.fetch :dealer => id do
        JSON.parse(Nestful.get(
        DIDealer.options[:url] + "/#{id}.json",
        :headers => DIDealer.api_headers))
      end

      Dealer.new(dealer, brand)
    end
  end

  def initialize(dealer, brand=nil)
    if brand
      dealer["active_promotions"].keep_if do |promotion|
        promotion["brand_name"].parameterize == brand
      end
    end
    dealer["active_promotions"].collect! { |promotion| promotion["promotion_id"] } if dealer["active_promotions"]

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

  def to_liquid
    keys = {}
    [:name, :address_1, :address_2, :city, :state, :zipcode, :phone, :website, :logo_url].each do |key|
      keys[key.to_s] = self.send(key)
    end
    keys
  end

  def self.get_closest_dealers ip
    JSON.parse(Nestful.get(DIDealer.options[:url] + "/closest.json", :headers => DIDealer.api_headers)).collect { |dealer| Dealer.new(dealer) }
  end
end
