module Cvtcli
  class Configuration

    attr_accessor :host
    attr_accessor :port
    attr_accessor :secure
    attr_accessor :token
    attr_accessor :logger

    def initialize
      defaults.each do |setting, value|
        send("#{setting}=", value)
      end
    end

    def defaults
      defaults = {
        host: 'cvtheques.com'
      }
      #defaults[:logger] = Logger.new(STDOUT)
    end

  end
end

