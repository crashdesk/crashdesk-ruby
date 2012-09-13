module Crashdesk
  module Reporters

    class Screen

      def initialize(params)
      end

      def run(data)
        data.to_json.to_s
      end

    end

  end
end
