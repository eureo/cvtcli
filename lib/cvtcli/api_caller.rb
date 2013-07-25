require 'rest-client'

module Cvtcli
  class ApiCaller
    include ::Cvtcli::Routes

    attr_accessor :max_connection_attempts
    attr_reader :endpoint, :options, :connection_attempts

    DEFAULT_RETRY_LIMIT = 1

    def initialize(endpoint, options={})
      @endpoint, @options = endpoint, options
      @connection_attempts = 0
      @max_connection_attempts = options[:max_connection_attempts] || DEFAULT_RETRY_LIMIT
    end

    def call(obj)
      method, url = send("#{endpoint}_endpoint", options[:url_options] || {})
      Cvtcli.debug("API CALL: #{method} #{url}")
      
      while connection_attempts < max_connection_attempts
        sleep_if_retrying

        response = make_call(method, url)
        valid_response_codes = (200..207).to_a
        if valid_response_codes.include?(response.code.to_i)
          if options[:success]
            Cvtcli.debug("CALLING SUCCESS HANDLER: #{options[:success]}")
            obj.send(options[:success], response)
          end
          success = true
          break
        end
      end

      if !success && options[:failure]
        obj.send(options[:failure], response)
      end
    end

    private

    def make_call(method, url)
      begin
        @connection_attempts += 1
        Cvtcli.debug("ATTEMPT #{@connection_attempts}")
        headers =  {
          "AUTHORIZATION" => "Token token=\"#{Cvtcli.configuration.token}\""
        }
        parameters = {
          url: url,
          method: method,
          headers: headers
        }
        parameters[:payload] = options[:payload] if method == :post or method == :put
        RestClient::Request.execute(parameters)
      rescue RestClient::ResourceNotFound,
        RestClient::NotModified,
        RestClient::InternalServerError,
        RestClient::BadGateway,
        RestClient::ServiceUnavailable,
        RestClient::UnprocessableEntity,
        RestClient::GatewayTimeout => error
        return error.response
      end

    end


    def sleep_if_retrying
      if @connection_attempts > 0
        time = @connection_attempts * 5
        Cvtcli.debug("Sleeping for #{time} before retrying")
        sleep time
      end
    end
  end
end
