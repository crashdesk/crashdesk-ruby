module Crashdesk
  module Reporters
    class Test

      attr_reader :params, :crashlog

      def initialize(params)
        @params = params
      end

      def run(crashlog)
        @crashlog = crashlog
      end

    end
  end
end
