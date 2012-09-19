module Crashdesk
  module Reporters
    class Logger

      def initialize(params = nil)
      end

      def run(crashlog)
        require 'pp'
        hash = crashlog.to_hash
        Crashdesk.log(pp(hash))
      end

    end
  end
end
