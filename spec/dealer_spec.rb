require 'spec_helper'
require 'dealer'

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
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
  end

  describe "#find" do
    context "when brand is not in the cache and it should hit api" do
      before do
        Rails.cache.clear()
        stub_request(:get, "http://localhost:3000/api/dealers/1.json").with(:headers => {'Accept'=>'*/*', 'Api-Key'=>'SUPER SECRET API', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => '{"id":1, "name":"Demo Dealer", "address_1":"700 East North St", "address_2":"", "city":"Greenville", "state":"SC", "zipcode":"29601", "phone":"888-344-6483", "website":"http://theflooringconnection.com", "active_catalogs":[1, 2, 4, 8, 6, 5, 13, 11, 9, 15, 7, 16, 12, 3, 10, 14, 17], "latitude":"34.85185", "longitude":"-82.389555"}', :headers => {})
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
      it { @dealer.latitude.should == "34.85185" }
      it { @dealer.longitude.should == "-82.389555" }
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
