module Crashdesk
  class ReportManager

    attr_reader :reporters

    def initialize(reporters)
      @reporters = reporters.map do |reporter|
        if reporter.respond_to? :run
          reporter
        else
          constantize(reporter).new
        end
      end
    end

    def process(crashlog)
      reporters.map do |reporter|
        reporter.run(crashlog)
      end
    end

    private

    def constantize(reporter_name, prefix = "::Crashdesk::Reporters::")
      klass = prefix + klass_name(reporter_name)
      names = klass.split('::')
      names.shift if names.empty? || names.first.empty?


      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end

    def klass_name(k)
      k.to_s.split('_').collect!{ |w| w.capitalize }.join
    end

  end
end
