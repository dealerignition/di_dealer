require 'spec_helper'
require 'dealer'

describe DIDealer do
  describe "#configure" do
    context "when in development" do
      before {
        Rails.env = ActiveSupport::StringInquirer.new('development')
        DIDealer.configure({ api_key: "SUPER SECRET API" })
      }

      it "sets default url" do
        DIDealer.options[:url].should == "http://localhost:3000/api/dealers"
      end

      it "sets api_key" do
        DIDealer.options[:api_key].should == "SUPER SECRET API"
      end
    end

    context "when not in development" do
      before {
        Rails.env = ActiveSupport::StringInquirer.new('production')
        DIDealer.configure
      }

      it "sets default url" do
        DIDealer.options[:url].should == "https://www.dealerignition.com/api/dealers"
      end
    end
  end
end
