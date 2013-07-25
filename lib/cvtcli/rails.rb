module Cvtcli
  module Rails
    def self.initialize
      if defined?(::Rails.logger)
        rails_logger = ::Rails.logger
      elsif defined?(RAILS_DEFAULT_LOGGER)
        rails_logger = RAILS_DEFAULT_LOGGER
      end

      Cvtcli.configure do |config|
        config.logger = rails_logger
      end
    end
  end
end
