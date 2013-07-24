require 'spec_helper'

class TestRoute
  include Cvtcli::Routes
end

describe Cvtcli::Routes do
  let!(:test_route) { TestRoute.new }
  let(:config) { { host: 'test.host', port: 1234 } }

  describe "sync_endpoint" do
    it "returns :put and the sync url" do
      options = { foo: :bar }
      test_route.should_receive(:sync_url).with(options).and_return('my_sync_url')
      test_route.sync_endpoint(options).should == [:put, 'my_sync_url']
    end
  end

  describe "sync_url" do
    it "constructs the url from the configuration" do
      with_configuration(config) do
        test_route.sync_url.should == "http://test.host:1234/api/v1/candidates/sync"
      end
    end
    it "adds query parameters on to the url" do
      with_configuration(config) do
        url = test_route.sync_url(query: { updated_at: '2013-07-19', foo: :bar })
        url.should match(/\?.*updated_at=2013-07-19/)
        url.should match(/\?.*foo=bar/)
      end
    end
  end

end
