require 'spec_helper'

describe Pingu::RouterClient do

  it "takes an array of ip numbers"

  describe "makes a call to each ip address"  do
    before(:all) do
      @router_client = Pingu::RouterClient.new(['111.111.1.111', '222.222.2.222'])
    end

    it "makes a call to each IP" do
      @router_client.next_router.class.should be_a_kind_of(Nokogiri::Document)
    end

    it "it goes onto the next if the ip address returns a response"

    it "it sends a text message if the ip address does not return a response"

    it "will continue to call the unaccessable ip until it is reconnected"

    it "sends a text if reconnects with a previously uncontactable ip"
  end
end
