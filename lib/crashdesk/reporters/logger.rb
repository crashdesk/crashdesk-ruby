module Crashdesk
  module Reporters
    class Logger

      def run(crashlog)
        require 'pp'
        hash = crashlog.to_hash
        Crashdesk.log(pp(hash))
      end

    end
  end
end
