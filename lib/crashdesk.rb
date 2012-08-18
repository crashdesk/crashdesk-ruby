$:.unshift File.dirname(__FILE__)

require 'time'
require 'digest/md5'

require 'crashdesk/version'
require 'crashdesk/configuration'

require 'crashdesk/context_base'
require 'crashdesk/crashlog'
require 'crashdesk/backtrace'
require 'crashdesk/environment'
require 'crashdesk/reporters/remote'
require 'crashdesk/serializers/json'

module Crashdesk

  class << self
    LOG_PREFIX = "[Crashdesk] "

    attr_writer :configuration

    # Call this method to modify defaults for Crashdesk.
    #
    # @example
    #   Crashdesk.configure do |config|
    #     config.api_key = 'someapikey'
    #   end
    def configure(silent = false)
      yield(configuration) if block_given?
      configuration
    end

    # The configuration object.
    # @see Crashdesk.configure
    def configuration
      @configuration ||= Configuration.new
    end

    def log(message)
      configuration.logger.info(LOG_PREFIX + message) if configuration.logger
    end

    # Main method how to build crashlog from exception, context, and environment
    # @see Craslog.initialize
    def crashlog(exception, request, context, options = {})
      Crashlog.new(exception, request, context, options)
    end
  end

end
