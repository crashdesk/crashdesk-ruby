module Crashdesk
  module Reporters
    class Logger

      def initialize(params = nil)
      end

      def run(crashlog)
        hash = crashlog.to_hash
        Crashdesk.log(hash.to_s)
      end

    end
  end
end
