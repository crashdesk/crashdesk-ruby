require 'digest/md5'
require 'zlib'

module Crashdesk

  class Backtrace

    class Line
      # regexp taken from Airbrake
      INPUT_FORMAT = %r{^((?:[a-zA-Z]:)?[^:]+):(\d+)(?::in `([^']+)')?$}.freeze

      attr_reader :file, :number, :method

      def self.parse(unparsed_line)
        _, file, number, method = unparsed_line.match(INPUT_FORMAT).to_a
        new(file, number, method)
      end

      def initialize(file, number, method)
        self.file   = file
        self.number = number
        self.method = method
      end

      def to_s
        "#{file}:#{number}:in `#{method}'"
      end

      def ==(other)
        to_s == other.to_s
      end

      def inspect
        "<Line:#{to_s}>"
      end

      private
        attr_writer :file, :number, :method
    end

    attr_reader :lines

    def self.parse(backtrace, opts = {})
      code_lines = split_multiline_backtrace(backtrace)

      lines = unless code_lines.nil?
        code_lines.collect do |unparsed_line|
          Line.parse(unparsed_line)
        end
      else
        []
      end

      instance = new(lines)
    end

    def initialize(lines)
      self.lines = lines
    end

    def inspect
      "<Backtrace: " + lines.collect { |line| line.inspect }.join(", ") + ">"
    end

    def to_s
      lines.join("\n\s")
    end

    def to_a
      lines.map { |l| l.to_s }
    end

    def ==(other)
      if other.respond_to?(:lines)
        lines == other.lines
      else
        false
      end
    end

    def hash_id
      Digest::MD5.hexdigest(to_s)
    end

    def crc
      Zlib::crc32(to_s).to_s
    end

    private

      attr_writer :lines

      def self.split_multiline_backtrace(backtrace)
        if (a = Array(backtrace)).size == 1
          a.first.split(/\n\s*/)
        else
          backtrace
        end
      end

  end
end
