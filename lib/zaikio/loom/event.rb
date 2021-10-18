require "net/http"
require "oj"
require "securerandom"

module Zaikio
  module Loom
    class Event
      attr_reader :id, :status_code, :response_body

      def initialize(name, subject:, id: nil, link: nil, payload: nil, receiver: nil, timestamp: nil, version: nil) # rubocop:disable Metrics/AbcSize, Metrics/ParameterLists
        @event_name = name.to_s.count(".").zero? ? "#{configuration.apps.values.first.app_name}.#{name}" : name.to_s
        @id         = id || SecureRandom.uuid
        @link       = link
        @payload    = payload
        @receiver   = receiver
        @subject    = subject
        @timestamp  = timestamp
        @version    = version || configuration.version

        return if app_password

        configuration.logger.error("Zaikio::Loom is disabled – event password is missing")
      end

      def fire # rubocop:disable Metrics/AbcSize
        log_event

        return false unless app_password && configuration.host

        uri = URI("#{configuration.host}/api/v1/events")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"

        response = http.request(build_request(uri))

        @status_code   = response.code.to_i
        @response_body = response.body

        unless response.is_a?(Net::HTTPSuccess)
          raise Zaikio::Loom::Error.new(
            "Sending event failed (#{@status_code}): #{@response_body}",
            body: @response_body,
            status_code: @status_code
          )
        end

        response.is_a?(Net::HTTPSuccess)
      end

      def to_h # rubocop:disable Metrics/MethodLength
        timestamp = @timestamp || Time.now.getutc

        {
          id:        @id,
          name:      @event_name,
          subject:   @subject,
          timestamp: timestamp.iso8601,
          receiver:  @receiver,
          version:   @version,
          payload:   @payload,
          link:      @link
        }.compact
      end

      private

      def app_name
        @event_name.split(".").first
      end

      def app_password
        configuration.apps[app_name].password
      end

      def build_request(uri)
        Net::HTTP::Post.new(uri, "User-Agent" => "zaikio-loom:#{Zaikio::Loom::VERSION}").tap do |request|
          request.basic_auth(app_name, app_password)
          request.body         = event_as_json
          request.content_type = "application/json"
        end
      end

      def configuration
        Zaikio::Loom.configuration
      end

      def event_as_json
        @event_as_json ||= Oj.dump({ event: to_h }, mode: :compat)
      end

      def log_event
        configuration.logger.info("Zaikio::Loom event\n#{event_as_json}")
      end
    end
  end
end
