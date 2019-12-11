require "logger"

module Zaikami
  module Loom
    class Configuration
      HOSTS = {
        development: "http://loom.zaikami.test",
        test:        "http://loom.zaikami.test",
        staging:     "https://loom.staging.zaikami.cloud",
        sandbox:     "https://loom.sandbox.zaikami.cloud",
        production:  "https://loom.zaikami.cloud"
      }.freeze

      attr_accessor :app_name, :password, :version
      attr_reader :environment, :host
      attr_writer :logger

      def initialize
        @environment = :sandbox
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def environment=(environment)
        @environment = environment.to_sym
        @host = host_for(environment)
      end

      private

      def host_for(environment)
        HOSTS.fetch(environment) do
          raise StandardError.new, "Invalid Zaikami::Loom environment '#{environment}'"
        end
      end
    end
  end
end
