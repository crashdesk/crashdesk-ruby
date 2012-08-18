module Crashdesk

  class ContextBase
    MAX_DATA_LENGTH = 2048

    def to_hash
      { 'context' => {} }
    end

    private

    def sanitize_unserializable_data(data, stack = [])
      return "[recursion halted]" if stack.any? { |item| item == data.object_id }

      if data.respond_to?(:to_hash)
        data.to_hash.inject({}) do |result, (key, value)|
          result.merge(key => sanitize_unserializable_data(value, stack + [data.object_id]))
        end
      elsif data.respond_to?(:to_ary)
        data.to_ary.collect do |value|
          sanitize_unserializable_data(value, stack + [data.object_id])
        end
      else
        data.to_s.slice(0, MAX_DATA_LENGTH)
      end
    end

    def extract_http_headers(env)
      headers = {}
      env.select{|k, v| k =~ /^HTTP_/}.each do |name, value|
        proper_name = name.sub(/^HTTP_/, '').split('_').map{|upper_case| upper_case.capitalize}.join('-')
        headers[proper_name] = value
      end
      unless headers['Cookie'].nil?
        headers['Cookie'] = headers['Cookie'].sub(/_session=\S+/, '_session=[FILTERED]')
      end
      headers
    end

    def extract_session(request)
      session_hash = {'session_id' => "", 'data' => {}}

      if request.respond_to?(:session)
        session = request.session
        session_hash['session_id'] = request.session_options ? request.session_options[:id] : nil
        session_hash['session_id'] ||= session.respond_to?(:session_id) ? session.session_id : session.instance_variable_get("@session_id")
        session_hash['data'] = session.respond_to?(:to_hash) ? session.to_hash : session.instance_variable_get("@data") || {}
        session_hash['session_id'] ||= session_hash['data'][:session_id]
        session_hash['data'].delete(:session_id)
      end

      sanitize_unserializable_data(session_hash)
    end

  end

end
