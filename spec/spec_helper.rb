require 'cvtcli'
require 'fakeweb'

def with_configuration(options = {})
  Cvtcli.configuration = nil
  Cvtcli.configure do |configuration|
    options.each do |option, value|
      configuration.send("#{option}=", value)
    end
  end
  yield
end
