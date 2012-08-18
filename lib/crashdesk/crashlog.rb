module Crashdesk

  class Crashlog

    attr_accessor :options, :exception, :backtrace, :environment, :exception_class,
      :exception_message, :context, :occurred_at,
      :reporter

    def initialize(exception, request, context, options = {})
      self.options = options

      # Anatomy of Exception
      self.exception = exception
      self.backtrace = Crashdesk::Backtrace.parse(exception.backtrace || caller)
      self.exception_class = exception.class.name
      self.exception_message = exception.message

      # Environment
      self.environment = Crashdesk::Environment.new(
        :environment_name => options[:environment_name],
        :project_root => Crashdesk.configure.project_root)

      # Context
      self.context = context
      self.occurred_at = Time.now.utc.iso8601

      # How to report?
      self.reporter = options[:reporter] ||
        Crashdesk::Reporter::Remote.new(:host => 'localhost',
                                        :port => 4567) # Need to pass HTTP params
    end

    def to_hash
      {
        :api_key => Crashdesk.configuration.api_key,
        :hash_id => backtrace.hash_id,
        :crc => backtrace.crc,
        :occurred_at => occurred_at,

        :environment => environment.to_hash,

        :backtrace => backtrace.to_a,
        :exception_class => self.exception_class,
        :exception_message => self.exception_message,

        :context => context.to_hash
      }
    end

    def report
      json = Crashdesk::Serializer::Json.new(self.to_hash).process
      reporter.run(json)
    end

    def crc
      session_data.crc
    end

  end

end
