require 'net/http'
require 'net/https'

module Crashdesk
  module Reporter

    module QueryParams
      def self.encode(value, key = nil)
        case value
        when Hash  then value.map { |k,v| encode(v, append_key(key,k)) }.join('&')
        when Array then value.map { |v| encode(v, "#{key}[]") }.join('&')
        when nil   then ''
        else
          "#{key}=#{CGI.escape(value.to_s)}" 
        end
      end

      private
      def self.append_key(root_key, key)
        root_key.nil? ? key : "#{root_key}[#{key.to_s}]"
      end
    end

    class Remote
      NOTICES_URI = '/v1/crashes'.freeze
      HTTP_ERRORS = [Timeout::Error,
                    Errno::EINVAL,
                    Errno::ECONNRESET,
                    EOFError,
                    Net::HTTPBadResponse,
                    Net::HTTPHeaderSyntaxError,
                    Net::ProtocolError,
                    Errno::ECONNREFUSED].freeze
      HEADERS = {
        'Content-type' => 'application/json',
        'Accept'       => 'application/json'
      }

      def initialize(options = {})
        [ :proxy_host,
          :proxy_port,
          :proxy_user,
          :proxy_pass,
          :protocol,
          :host,
          :port,
          :secure,
          :use_system_ssl_cert_chain,
          :http_open_timeout,
          :http_read_timeout
        ].each do |option|
          instance_variable_set("@#{option}", options[option])
        end
      end

      def run(data)
        http = setup_http_connection
        headers = HEADERS.merge('X-Crashdesk-ApiKey' => Crashdesk.configuration.api_key)

        response = begin
                    http.post(url.path, data, headers)
                  rescue *HTTP_ERRORS => e
                    logger.error "Unable to connect the Creashdesk server. HTTP Error=#{e}"
                    nil
                  end

        case response
        when Net::HTTPSuccess then
          logger.info "Success: #{response.class} #{response}"
        else
          logger.info "Failure: #{response.class} #{response}"
        end
      rescue => e
        logger.error "Error sending: #{e.class} - #{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}"
        nil
      end

      attr_reader :proxy_host,
                  :proxy_port,
                  :proxy_user,
                  :proxy_pass,
                  :protocol,
                  :host,
                  :port,
                  :secure,
                  :use_system_ssl_cert_chain,
                  :http_open_timeout,
                  :http_read_timeout

      alias_method :secure?, :secure
      alias_method :use_system_ssl_cert_chain?, :use_system_ssl_cert_chain

      private

      def logger
        Crashdesk.logger
      end

      def url
        URI.parse("#{protocol}://#{host}:#{port}").merge(NOTICES_URI)
      end

      def protocol
        'http'
      end

      def host
        @host || 'crashde.sk'
      end

      def port
        @port || 80
      end

      def setup_http_connection
        http =
          Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_pass).
          new(url.host, url.port)

        http.read_timeout = http_read_timeout
        http.open_timeout = http_open_timeout

        if secure?
          http.use_ssl     = true
          http.ca_file      = Crashdesk.configuration.ca_bundle_path
          http.verify_mode  = OpenSSL::SSL::VERIFY_PEER
        else
          http.use_ssl     = false
        end

        http
      end
    end

  end
end

