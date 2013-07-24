require "cvtcli/api_call"

module Cvtcli
  class Candidate
    include Cvtcli::ApiCall

    attr_accessor :responses
    
    def initialize
      @responses = []
    end

    def sync(email, params)
      api_call :sync, url_options: { query: { "email"=> email }}, payload: params, failure: :handle_failure, success: :handle_success
    end

    def create(email, params)
      api_call :create, url_options: { query: { "email"=> email }}, payload: params, failure: :handle_failure, success: :handle_success
    end

    def delete(email)
      api_call :delete, url_options: { query: { "email" => email }}, failure: :handle_failure
    end

    def handle_failure(response)
      puts("CANDIDATE API CALL FAILED !!!!!!!!")
    end

    def handle_success(response)
      @responses << response
    end

    def last_response
      @responses.last
    end

  end
end
