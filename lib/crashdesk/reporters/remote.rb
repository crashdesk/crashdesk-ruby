require 'net/http'
require 'net/https'

module Crashdesk
  module Reporters

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

      def run(crashlog)
        hash = crashlog.to_hash
        unless hash.respond_to? :to_json
          require 'json'
          unless hash.respond_to? :to_json
            raise StandardError.new("You need a json gem/library installed to send errors to as JSON (Object.to_json not defined).
                                    \nInstall json_pure, yajl-ruby, json-jruby, or the c-based json gem")
          end
        end
        data = hash.to_json

        http = setup_http_connection
        headers = HEADERS.merge('X-Crashdesk-ApiKey' => Crashdesk.configuration.api_key)

        response = begin
                    log "Sending crash report to #{url} with data: #{data}"
                    http.post(url.path, data, headers)
                  rescue *HTTP_ERRORS => e
                    log "Unable to connect the Creashdesk server. HTTP Error=#{e}", :error
                    nil
                  end

        case response
        when Net::HTTPSuccess then
          log "Success: #{response.class} #{response}"
        else
          log "Failure: #{response.class} #{response}"
        end
      rescue => e
        log "Error sending: #{e.class} - #{e.message}\nBacktrace:\n#{e.backtrace.join("\n\t")}", :error
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

      def log(message, severity = :info)
        Crashdesk.log(message, severity)
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

