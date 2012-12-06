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

  describe "#persisted?" do
    before do
      @dealer = Dealer.new({ id: 1 })
    end
    it { @dealer.persisted?.should be_true }
  end

  describe "#to_liquid" do
    subject { Dealer.find(1).to_liquid }

    it { should be_instance_of Hash }
    it { should include "address_1" }
    it { should include "address_2" }
    it { should include "city" }
    it { should include "state" }
    it { should include "zipcode" }
    it { should include "name" }
    it { should include "phone" }
    it { should include "logo_url" }
    it { should_not include "active_catalogs" }
    it { should_not include "active_promotions" }
  end

  describe ".get_closest_dealers" do
    before do
      stub_request(:get, "http://localhost:3000/api/dealers/closest.json").
        with(:headers => {'Accept'=>'*/*', 'Api-Key'=>'SUPER SECRET API', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '[{"address_1":"700 East North St","address_2":"","city":"Greenville","id":1,"latitude":"34.851803","longitude":"-82.39057699999999","name":"Demo Dealer","phone":"888-344-6483","state":"SC","website":"http://theflooringconnection.com","zipcode":"29601","logo_url":"http://s3.amazonaws.com/dealer_ignition_new/normal/1/flooring-logo.jpg?1346264159"},{"address_1":"459 Marion Ave","address_2":"","city":"Spartanburg","id":7,"latitude":"34.944963","longitude":"-81.9147706","name":"Hodge Carpets","phone":"864-573-9288","state":"SC","website":"http://www.hodgecarpets.com","zipcode":"29303","logo_url":"http://s3.amazonaws.com/dealer_ignition_new/normal/7/HODGECLR.gif?1349702638"},{"address_1":"2929-J Eskridge Rd","address_2":"","city":"Fairfax","id":2,"latitude":"38.870947","longitude":"-77.23236300000001","name":"Tafti & Co","phone":"202-701-4500","state":"VA","website":"http://www.taftico.com/","zipcode":"22031","logo_url":"/logos/normal/missing.png"},{"address_1":"6185 Baltimore Pike","address_2":"","city":"Littlestown","id":6,"latitude":"39.7343612","longitude":"-77.0763164","name":"Myers Floors & Interiors","phone":"717-359-5460","state":"PA","website":"http://www.myersfloors.net","zipcode":"17340","logo_url":"/logos/normal/missing.png"},{"address_1":"43223 12 Mile Road","address_2":"","city":"Novi","id":5,"latitude":"42.494978","longitude":"-83.473972","name":"Hagopian World of Rugs","phone":"248-449-7847","state":"MI","website":"http://www.originalhagopian.com","zipcode":"48377","logo_url":"/logos/normal/missing.png"},{"address_1":"401 2nd Street","address_2":"","city":"Coralville","id":8,"latitude":"41.671574","longitude":"-91.572237","name":"Randy\'s Carpets & Interiors","phone":"319-354-4344","state":"IA","website":"http://www.randyscarpets.com/","zipcode":"52241","logo_url":"http://s3.amazonaws.com/dealer_ignition_new/normal/8/CompanyWelcome.jpeg?1349728334"},{"address_1":"10301 Woodcrest Dr. NW","address_2":"","city":"Coon Rapids","id":4,"latitude":"45.157057","longitude":"-93.281418","name":"HOM Furniture","phone":"1-763-772-1560","state":"MN","website":"http://www.homfurniture.com/","zipcode":"55433","logo_url":"/logos/normal/missing.png"}]', :headers => {})
    end

    subject { Dealer.get_closest_dealers "75.136.156.45" }

    it { should be_instance_of Array }
    its(:size) { should <= 10 }
    its(:first) { should be_instance_of Dealer }
  end
end
