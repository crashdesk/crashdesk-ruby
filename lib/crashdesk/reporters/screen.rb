module Crashdesk
  module Reporter

    class Screen

      def initialize()
      end

      def run(data)
        data.to_json.to_s
      end

    end

  end
end
