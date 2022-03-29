module Zaikio
  module Loom
    class Error < StandardError
      attr_reader :body, :status_code

      def initialize(message = nil, body:, status_code:)
        super(message)

        @body = body
        @status_code = status_code
      end
    end
  end
end
