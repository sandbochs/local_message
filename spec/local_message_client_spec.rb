require 'spec_helper'

describe LocalMessageClient do

  let(:client) { LocalMessageClient.new('localhost', '5500', 'username') }

  it "sends a register message to the server" do
    client.should_receive(:send_message)
    client.register
  end

  context "#send_message" do
    before(:each) do
      server = TCPServer.open('5500')
    end

    it "opens a TCPSocket to the server" do
      client.send_message("@username hello world")
    end
  end

  context "#listen" do
  end

end