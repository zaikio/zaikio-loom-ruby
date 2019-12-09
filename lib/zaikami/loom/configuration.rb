module Zaikami
  module Loom
    class Configuration
      attr_accessor :app_name, :environment, :password, :version

      def initialize
        @environment = :sandbox
      end

      def host
        Host.for_environment(@environment)
      end
    end
  end
end
