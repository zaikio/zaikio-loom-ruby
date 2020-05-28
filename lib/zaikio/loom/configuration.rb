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
      attr_reader :environment, :host, :clients, :app_name
      attr_writer :logger

      def initialize
        @environment = :sandbox
        @clients = {}
        @app_name = nil
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def environment=(env)
        @environment = env.to_sym
        @host = host_for(environment)
      end

      def app_name=(app_name)
        @app_name = app_name.to_s
        @clients[@app_name] = ClientConfiguration.new(@app_name)
      end

      def password
        @clients[app_name].password
      end

      def password=(password)
        @clients[app_name].password = password
      end

      def add_client(name)
        @clients[name.to_s] = ClientConfiguration.new(name.to_s)
        yield(@clients[name.to_s])
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
