require 'spec_helper'

describe Cvtcli::Configuration do
  let(:configuration) { Cvtcli::Configuration.new }

  it "sets the host by default" do
    configuration.host.should == "cvtheques.com"
  end

  it "allows the host to be overwritten" do
    expect { configuration.host = 'test.host' }.to change(configuration, :host).to('test.host')
  end

  it "sets the port" do
    expect { configuration.port = 1234 }.to change(configuration, :port).to(1234)
  end

  it "sets the token" do
    expect { configuration.token = '123456789' }.to change(configuration, :token).to("123456789")
  end

end
