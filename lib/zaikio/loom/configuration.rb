require "logger"

module Zaikio
  module Loom
    class Configuration
      HOSTS = {
        development: "http://loom.zaikio.test",
        test:        "http://loom.zaikio.test",
        staging:     "https://loom.staging.zaikio.com ",
        sandbox:     "https://loom.sandbox.zaikio.com ",
        production:  "https://loom.zaikio.com"
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

      def environment=(env)
        @environment = env.to_sym
        @host = host_for(environment)
      end

      private

      def host_for(environment)
        HOSTS.fetch(environment) do
          raise StandardError.new, "Invalid Zaikio::Loom environment '#{environment}'"
        end
      end
    end
  end
end
