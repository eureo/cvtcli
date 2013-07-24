require 'spec_helper'

describe Cvtcli do
  describe "#sync" do
    it "return true" do
      expect(Cvtcli.sync).to be_true
    end
  end
end
