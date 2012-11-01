require 'spec_helper'
require 'di_dealer'

describe DIDealer do
  before { DIDealer.options = nil }

  it "raises error when configure has not been run" do
    expect { DIDealer.options }.to raise_error(DIDealer::NotConfiguredError)
  end

  describe "#configure" do
    before { DIDealer.configure({ api_key: "SUPER SECRET API" }) }

    context "when in development" do
      before(:all) { Rails.env = ActiveSupport::StringInquirer.new('development') }

      it "sets default url" do
        DIDealer.options[:url].should == "http://localhost:3000/api/dealers"
      end

      it "sets api_key" do
        DIDealer.options[:api_key].should == "SUPER SECRET API"
      end
    end

    context "when not in development" do
      before { Rails.env = ActiveSupport::StringInquirer.new('production') }

      it "sets default url" do
        DIDealer.configure
        DIDealer.options[:url].should == "https://www.dealerignition.com/api/dealers"
      end
    end
  end
end
