require 'spec_helper'
require 'di_dealer'

describe Dealer do
  before(:all) { DIDealer.configure({ api_key: "SUPER SECRET API" }) }

  context "when testing accessor elements" do
    subject { Dealer.new({ id: 1 }) }
    it { should respond_to(:address_1) }
    it { should respond_to(:address_2) }
    it { should respond_to(:city) }
    it { should respond_to(:id) }
    it { should respond_to(:name) }
    it { should respond_to(:phone) }
    it { should respond_to(:state) }
    it { should respond_to(:website) }
    it { should respond_to(:zipcode) }
    it { should respond_to(:active_catalogs) }
    it { should respond_to(:active_promotions) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
  end

  describe "#find" do
    context "when brand is not in the cache and it should hit api" do
      before do
        Rails.cache.clear()
        stub_request(:get, "http://localhost:3000/api/dealers/1.json").
          with(:headers => {'Accept'=>'*/*', 'Api-Key'=>'SUPER SECRET API', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '{"address_1":"700 East North St","address_2":"","city":"Greenville","id":1,"latitude":"34.85185","longitude":"-82.389555","name":"Demo Dealer","phone":"888-344-6483","state":"SC","website":"http://theflooringconnection.com","zipcode":"29601","logo_url":"http://s3.amazonaws.com/dealer_ignition_new/normal/1/flooring-logo.jpg?1346264159","active_promotions":[{"brand_id":"1","brand_name":"Karastan","promotion_id":1},{"brand_id":"1","brand_name":"Karastan","promotion_id":2},{"brand_id":"3","brand_name":"Masland","promotion_id":3},{"brand_id":"2","brand_name":"J-Mish","promotion_id":4},{"brand_id":"4","brand_name":"Fabrica","promotion_id":5},{"brand_id":"5","brand_name":"Dixie Home","promotion_id":6},{"brand_id":"1","brand_name":"Karastan","promotion_id":7},{"brand_id":"6","brand_name":"Jaipur","promotion_id":8},{"brand_id":"7","brand_name":"Nourison","promotion_id":9},{"brand_id":"3","brand_name":"Masland","promotion_id":10},{"brand_id":"8","brand_name":"Armstrong","promotion_id":11},{"brand_id":"9","brand_name":"Cambria","promotion_id":12},{"brand_id":"1","brand_name":"Karastan","promotion_id":13},{"brand_id":"1","brand_name":"Karastan","promotion_id":14},{"brand_id":"14","brand_name":"Decorative Carpets","promotion_id":15},{"brand_id":"13","brand_name":"Stanton","promotion_id":17},{"brand_id":"15","brand_name":"Shaw","promotion_id":18},{"brand_id":"15","brand_name":"Shaw","promotion_id":19},{"brand_id":"15","brand_name":"Shaw","promotion_id":20},{"brand_id":"12","brand_name":"Laticrete","promotion_id":21}],"active_catalogs":[1,2,4,8,6,5,13,11,9,15,7,16,12,3,10,14,17]}', :headers => {})
        @dealer = Dealer.find(1)
      end
      it { @dealer.address_1.should == "700 East North St" }
      it { @dealer.address_2.should == "" }
      it { @dealer.city.should == "Greenville" }
      it { @dealer.id.should == 1 }
      it { @dealer.name.should == "Demo Dealer" }
      it { @dealer.phone.should == "888-344-6483" }
      it { @dealer.state.should == "SC" }
      it { @dealer.website.should == "http://theflooringconnection.com" }
      it { @dealer.zipcode.should == "29601" }
      it { @dealer.active_catalogs.should == [1,2,4,8,6,5,13,11,9,15,7,16,12,3,10,14,17] }
      it { @dealer.active_promotions.should == [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21] }
      it { @dealer.latitude.should == "34.85185" }
      it { @dealer.longitude.should == "-82.389555" }
    end

    context "when brand is in the cache and it should not hit the api" do
      before do
        @dealer = Dealer.find(1)
      end
      it { @dealer.address_1.should == "700 East North St" }
      it { @dealer.address_2.should == "" }
      it { @dealer.city.should == "Greenville" }
      it { @dealer.id.should == 1 }
      it { @dealer.name.should == "Demo Dealer" }
      it { @dealer.phone.should == "888-344-6483" }
      it { @dealer.state.should == "SC" }
      it { @dealer.website.should == "http://theflooringconnection.com" }
      it { @dealer.zipcode.should == "29601" }
      it { @dealer.active_catalogs.should == [1,2,4,8,6,5,13,11,9,15,7,16,12,3,10,14,17] }
      it { @dealer.active_promotions.should == [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,17,18,19,20,21] }
      it { @dealer.latitude.should == "34.85185" }
      it { @dealer.longitude.should == "-82.389555" }
    end

    context "with a specific brand" do
      before do
        @dealer = Dealer.find(1, "cambria")
      end

      it { @dealer.active_promotions.should == [12] }
    end
  end

  describe "#all" do
    before do
      stub_request(:get, "http://localhost:3000/api/dealers.json").with(:headers => {'Accept'=>'*/*','Api-Key'=>'SUPER SECRET API','User-Agent'=>'Ruby'}).to_return(:status => 200, :body => '[{"id":1, "name":"Demo Dealer", "address_1":"700 East North St", "address_2":"", "city":"Greenville", "state":"SC", "zipcode":"29601", "phone":"888-344-6483", "website":"http://theflooringconnection.com", "active_catalogs":[1, 2, 4, 8, 6, 5, 13, 11, 9, 15, 7, 16, 12, 3, 10, 14, 17], "latitude":"34.85185", "longitude":"-82.389555"}]', :headers => {})
      @dealer = Dealer.all
    end
    it { @dealer[0].address_1.should == "700 East North St" }
    it { @dealer[0].address_2.should == "" }
    it { @dealer[0].city.should == "Greenville" }
    it { @dealer[0].id.should == 1 }
    it { @dealer[0].name.should == "Demo Dealer" }
    it { @dealer[0].phone.should == "888-344-6483" }
    it { @dealer[0].state.should == "SC" }
    it { @dealer[0].website.should == "http://theflooringconnection.com" }
    it { @dealer[0].zipcode.should == "29601" }
    it { @dealer[0].active_catalogs.should == [1,2,4,8,6,5,13,11,9,15,7,16,12,3,10,14,17] }
    it { @dealer[0].latitude.should == "34.85185" }
    it { @dealer[0].longitude.should == "-82.389555" }
  end

  describe "#model_name" do
    it { Dealer.model_name.should be_kind_of(ActiveModel::Name) }
  end

  describe ".persisted?" do
    before do
      @dealer = Dealer.new({ id: 1 })
    end
    it { @dealer.persisted?.should be_true }
  end
end
