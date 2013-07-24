require 'spec_helper'


describe Cvtcli::ApiCaller do

  describe "#new" do
    it "stores the endpoint and options" do
      api_caller = Cvtcli::ApiCaller.new(:myendpoint, foo: :bar)
      api_caller.endpoint.should == :myendpoint
      api_caller.options.should == { foo: :bar }
    end
  end

  describe "#call" do
    let(:api_caller) { with_configuration { Cvtcli::ApiCaller.new(:test) } }
    let(:url) { 'http://example.com/test' }
    it "gets the method and url from the endpoint" do
      api_caller.should_receive(:test_endpoint).with({}).and_return([:get, url])
      api_caller.call(self)
    end
    it "passes through any url options" do
      api_caller.should_receive(:test_endpoint).with({ query: { updated_at: '2013-07-19', foo: :bar }}).and_return([:get, url])
      api_caller.options[:url_options] = { query: { updated_at: '2013-07-19', foo: :bar } }
      RestClient::Request.stub(:execute).and_return(double('response', :code => 200))
      api_caller.call(self)
    end
    describe "a GET request" do
      it "make the call to the api" do
        api_caller.stub(:test_endpoint).and_return([:get, url])
        RestClient::Request.should_receive(:execute).with(hash_including(url: url, method: :get)).and_return(double('response', :code => 200))
        api_caller.call(self)
      end
    end
    describe "a POST request" do
      it "make the call using :payload option as payload" do
        api_caller.stub(:test_endpoint).and_return([:post, url])
        api_caller.options[:payload] = 'test data'
        RestClient::Request.should_receive(:execute).with(hash_including(:url => url, :payload => "test data", :method => :post)).and_return(double('response', :code => 200))
        api_caller.call(self)
      end
    end
  end

  describe "call failed" do
    let(:api_caller) { with_configuration { Cvtcli::ApiCaller.new(:test) } }
    let(:url) { 'url' }
    let(:object) { double('calling object') }
    before do
      FakeWeb.register_uri(:get, url, :body => '', :status => [500, 'Internal Server Error'])
      api_caller.stub(:test_endpoint).and_return([:get, url])
    end

    it "retries call, up to value of :max_connection_attempts option" do
      api_caller.max_connection_attempts = 2
      api_caller.call(object)
      api_caller.connection_attempts.should == 2
    end


    {
      304 => 'Not Modified',
      404 => 'Resource Not Found',
      500 => 'Internal Server Error',
      # Work out when this could happen
      # 501 => 'Not Implemented',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
      # Work out when this could happen
      # 505 => 'HTTP Version Not Supported',
      # Work out when this could happen
      # 506 => 'Variant Also Negotiates',
      # Work out when this could happen
      # 507 => 'Insufficient Storage', #WebDAV
      # Work out when this could happen
      # 509 => 'Bandwidth Limit Exceeded', #Apache
      # Work out when this could happen
      # 510 => 'Not Extended'
    }.each do |code, reason|
      it "fails when response is #{code} #{reason}" do
        FakeWeb.register_uri(:get, url, :body => '', :status => [code.to_s, reason])
        api_caller.options[:failure] = :fail
        object.should_receive(:fail)
        api_caller.call(object)
      end
    end
  end

end
