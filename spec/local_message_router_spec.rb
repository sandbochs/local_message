require 'spec_helper'

describe LocalMessageRouter do
  
  let(:router) { LocalMessageRouter.new(5500) }

  before(:all) do
    router.send(:register, 'username', 1234, '127.0.0.1')
    router.send(:register, 'username2', 4321, '192.168.0.1')
  end

  context "#start" do
  end

  context "#handle" do
    before(:all) do
      @register_message = '@register username3 6000'
    end

    it "checks if a user is registered" do
      router.should_receive(:register?)
      router.send(:handle, @register_message, 1234, '127.0.0.1')
    end

    it "handles client registration" do
      router.send(:handle, @register_message, 1234, '127.0.0.1')
      router.registered_users['username3'].should_not be_nil
    end
  end

  context "#register?" do
    it "returns true if the message starts with @register" do
      router.send(:register?, '@register username 1234').should be_true
    end

    it "returns false if the message does not start with @register" do
      router.send(:register?, '@registration username 1234').should be_false
    end
  end

  context "#registered?" do
    it "returns true if the user is registered" do
      router.send(:registered?, 'username').should be_true
    end

    it "returns false if the user is not registered" do
      router.send(:registered?, 'username').should be_false
    end
  end

  it "registers a username" do
    router.send(:register, 'username3', 1234, '10.0.0.1')
    router.registered_users['username3'].should_not be_nil
  end

  it "returns the correct username" do
    router.send(:username_by_ip, '127.0.0.1').should eq 'username'
  end

  it "properly strips the username and port" do
    router.send(:strip_username_port, '@register username 1234').should eq ['username', 1234]
  end

  context "#has_recipient?" do
    it "returns true if the message is sent to a username" do
      router.send(:has_recipient?, '@username hello').should be_true
    end

    it "returns false if the message is sent to a username" do
      router.send(:has_recipient?, 'username hello').should be_false
    end
  end

  it "properly strips the username from a message" do
    router.send(:strip_recipient, '@username hello world').should eq 'username'
  end

  it "properly strips the message" do
    router.send(:strip_message, '@username hello world').should eq 'hello world'
  end

  context "#forward_message" do
    it "checks if the recipient is registered" do
      router.should_receive(:registered?)
      router.send(:forward_message, 'username', 'username2', 'hello world')
    end

    it "calls send_message" do
      router.should_receive(:send_message)
      router.send(:forward_message, 'username', 'username2', 'hello world')
    end
  end

  context "#send_message" do
    it "opens a new TCPSocket"
    it "writes to the socket"
    it "closes the socket"
  end
end