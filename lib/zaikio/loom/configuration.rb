require "logger"

module Zaikio
  module Loom
    class Configuration
      HOSTS = {
        test:       "http://loom.zaikio.test",
        sandbox:    "https://loom.sandbox.zaikio.com",
        production: "https://loom.zaikio.com"
      }.freeze

      attr_accessor :version
      attr_reader :environment, :host, :apps, :queue
      attr_writer :logger

      def initialize
        @environment = :sandbox
        @apps = {}
      end

      def logger
        @logger ||= Logger.new($stdout)
      end

      def environment=(env)
        @environment = env.to_sym
        @host = HOSTS[environment]
      end

      def queue=(name)
        Zaikio::Loom::FireEventJob.queue_as(name)
      end

      def application(name)
        @apps[name.to_s] = AppConfiguration.new(name.to_s)
        yield(@apps[name.to_s])
      end
    end
  end
end
