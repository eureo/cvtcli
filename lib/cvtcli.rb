require "cvtcli/version"
require "cvtcli/configuration"
require "cvtcli/routes"
require "cvtcli/api_caller"
require "cvtcli/api_call"
require "cvtcli/candidate"

module Cvtcli
  LOG_PREFIX = "** [Cvtcli] "

  class << self
    attr_accessor :configuration

    def debug(message)
      logger.debug(LOG_PREFIX + message) if logger
    end

    def logger
      self.configuration && self.configuration.logger
    end

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def sync
      return true
    end
  end

end
