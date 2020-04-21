require "logger"

module Zaikio
  module Loom
    class Configuration
      HOSTS = {
        test:        "http://loom.zaikio.test",
        sandbox:     "https://loom.sandbox.zaikio.com",
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
        @host = HOSTS[environment]
      end
    end
  end
end
