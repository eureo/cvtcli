module Cvtcli
  module Routes

    def create_endpoint(options)
      [:post, create_url(options)]
    end

    def create_url(options)
      url = http_scheme.build(base_options.merge(path: create_path))
      url.query = options[:query].map { |k,v| "#{k}=#{v}" }.join('&') if options[:query]
      url.to_s
    end

    def delete_endpoint(options)
      [:delete, delete_url(options)]
    end

    def delete_url(options)
      url = http_scheme.build(base_options.merge(path: delete_path))
      url.query = options[:query].map { |k,v| "#{k}=#{v}" }.join('&') if options[:query]
      url.to_s
    end

    def sync_endpoint(options)
      [:put, sync_url(options)]
    end

    def sync_url(options={})
      url = http_scheme.build(base_options.merge(path: sync_path))
      url.query = options[:query].map { |k,v| "#{k}=#{v}" }.join('&') if options[:query]
      url.to_s
    end

    protected

    def http_scheme
      URI::HTTP
    end

    def base_options
      options = { host: Cvtcli.configuration.host, port: Cvtcli.configuration.port }
      options
    end

    def sync_path
      path = "/api/v1/candidates/sync"
      path
    end

    def create_path
      path = "/api/v1/candidates"
      path
    end

    def delete_path
      path = "/api/v1/candidates/delete_byemail"
      path
    end

  end
end
