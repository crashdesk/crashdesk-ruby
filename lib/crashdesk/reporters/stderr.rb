module Crashdesk
  module Reporters
    class Stderr

      def initialize(params = nil)
        $stderr.puts "Stderr initialized with: #{params}"
      end

      def run(crashlog)
        require 'pp'
        $stderr.puts "Stderr initialized with: #{pp(crashlog.to_hash)}"
      end

    end
  end
end
