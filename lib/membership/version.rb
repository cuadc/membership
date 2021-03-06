module Membership
  module Version
    class << self
      def git_desc
        @git_desc ||= `git describe --tags`.chomp.freeze
      end

      def git_commit
        @git_commit ||= `git rev-parse --short HEAD`.chomp.freeze
      end
    end
  end
end
