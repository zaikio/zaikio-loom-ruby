module Zaikami
  module Loom
    class Event
      attr_reader :status_code, :response_body

      def initialize(name, payload:, id: nil, link: nil, timestamp: nil, version: nil)
        @event_name = "#{configuration.app_name}.#{name}"
        @payload    = payload
        @id         = id || SecureRandom.uuid
        @timestamp  = timestamp
        @version    = version || configuration.app_name
      end

      def fire
        if configuration.host
          uri = URI("#{configuration.host}/api/v1/events")
          request = Net::HTTP::Post.new(uri)

          request.req.basic_auth = configuration.app_name, configuration.password
          request.body           = event_as_json
          request.content_type   = 'application/json'
          request.use_ssl        = uri.scheme == 'https'

          response = http.request(request)

          @status_code   = response.code
          @response_body = response.body

          response.is_a?(Net::HTTPSuccess)
        end
      end

      private

      def configuration
        Zaikami::Loom.configuration
      end

      def event_as_json
        timestamp = @timestamp || Time.now.getutc

        JSON.dump(
          event: { id: @id, timestamp: timestamp, name: @event_name, version: @version, payload: payload, link: link }
        )
      end
    end
  end
end
