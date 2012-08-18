require 'socket'

module Crashdesk

  class Environment

    attr_reader :project_root, :environment_name, :framework_string

    def initialize(args)
      self.project_root = args[:project_root]
      self.environment_name = args[:environment_name]
    end

    def to_hash
      {
        :project_root => project_root,
        :environment_name => environment_name,
        :hostname => Socket.gethostname,
        :language => 'ruby',
        :language_version => RUBY_VERSION,
        :language_platform => RUBY_PLATFORM
      }
    end

    private

    attr_writer :project_root, :environment_name

  end

end
