module Crashdesk

  class Configuration

    # Basic connection settings
    attr_accessor :app_key

    # Proxy server
    attr_accessor :proxy_host, :proxy_port, :proxy_user, :proxy_pass

    # HTTP
    attr_accessor :host, :port

    # Where to log Crashdesk output?
    attr_accessor :logger

    # Framework is string representing framework
    # @example
    #   Crashdesk.configure do |config|
    #     config.app_key = 'YOUR APP KEY HERE'
    #     config.project_root = ::Rails.root
    #     config.logger = ::Rails.logger
    #   end
    #
    attr_accessor :environment_name, :project_root

    attr_accessor :reporters

    def initialize
      @host = 'beta.crashde.sk'
    end

    # Hash like access
    def [](option)
      send(option)
    end

    def port
      @port || default_port
    end

    def protocol
      'http'
    end

    def reporters
      reporters = [:remote]
      reporters << :logger if logger
      reporters
    end

    private

    def default_port
      9292
    end

  end

end
