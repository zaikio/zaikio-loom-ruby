require "net/http"
require "oj"
require "securerandom"

module Zaikami
  module Loom
    class Event
      attr_reader :status_code, :response_body

      def initialize(name, subject:, id: nil, link: nil, payload: nil, receiver: nil, timestamp: nil, version: nil)
        @event_name = "#{configuration.app_name}.#{name}"
        @id         = id || SecureRandom.uuid
        @link       = link
        @payload    = payload
        @receiver   = receiver
        @subject    = subject
        @timestamp  = timestamp
        @version    = version || configuration.version

        return if configuration.password

        configuration.logger.error("Zaikami::Loom is disabled – event password is missing")
      end

      def fire
        return false unless configuration.password && configuration.host

        uri = URI("#{configuration.host}/api/v1/events")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"

        request = Net::HTTP::Post.new(uri, "User-Agent" => "zaikami-loom:#{Zaikami::Loom::VERSION}")
        request.basic_auth(configuration.app_name, configuration.password)
        request.body         = event_as_json
        request.content_type = "application/json"

        response = http.request(request)

        @status_code   = response.code.to_i
        @response_body = response.body

        response.is_a?(Net::HTTPSuccess)
      end

      private

      def configuration
        Zaikami::Loom.configuration
      end

      def event_as_json
        timestamp = @timestamp || Time.now.getutc

        Oj.dump(
          {
            event: {
              id: @id,
              name: @event_name,
              subject: @subject,
              timestamp: timestamp.iso8601,
              receiver: @receiver,
              version: @version,
              payload: @payload,
              link: @link
            }.compact
          },
          mode: :compat
        )
      end
    end
  end
end
