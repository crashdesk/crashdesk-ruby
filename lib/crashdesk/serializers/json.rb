module Crashdesk
  module Serializer

    class Json

      def initialize(data)
        unless data.respond_to? :to_json
          require 'json'
          unless data.respond_to? :to_json
            raise StandardError.new("You need a json gem/library installed to send errors to as JSON (Object.to_json not defined).
                                    \nInstall json_pure, yajl-ruby, json-jruby, or the c-based json gem")
          end
        end

        @data = data
      end

      def process
        @data.to_json
      end

    end

  end
end
