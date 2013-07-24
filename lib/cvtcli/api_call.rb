module Cvtcli
  module ApiCall
    def api_call(endpoint, options={})
      api_caller = Cvtcli::ApiCaller.new(endpoint, options)
      api_caller.call(self)
    end
  end
end
