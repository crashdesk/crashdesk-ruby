require 'spec_helper'

describe Crashdesk::Configuration do

  context "with defaults" do
    before do
      @config = Crashdesk.configure
    end

    it "point to crashdes.sk host" do
      @config[:host].should == 'beta.crashde.sk'
      @config.host.should == 'beta.crashde.sk'
    end

    it "port is 80" do
      @config[:port].should == 9292
      @config.port.should == 9292
    end

    it "protocol is HTTP" do
      @config[:protocol].should == 'http'
      @config.protocol.should == 'http'
    end
  end

  context "with modifications" do
    before do
      @config = Crashdesk.configure do |c|
        c.host = 'api.crashde.sk'
        c.port = 443
      end
    end

    it "point to crashdes.sk host" do
      @config[:host].should == 'api.crashde.sk'
      @config.host.should == 'api.crashde.sk'
    end

    it "port is 80" do
      @config[:port].should == 443
      @config.port.should == 443
    end
  end

end
