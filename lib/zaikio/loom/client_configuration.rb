module Zaikio
  module Loom
    class ClientConfiguration
      attr_accessor :app_name, :password

      def initialize(app_name)
        @app_name = app_name
      end
    end
  end
end
