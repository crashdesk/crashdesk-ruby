module Crashdesk
  module Reporters
    class Test

      attr_reader :params, :crashlog

      def initialize(params = nil)
        @params = params
      end

      def run(crashlog)
        @crashlog = crashlog
        @crashlog.to_hash
      end

    end
  end
end
