module Zaikio
  module Loom
    class FireEventJob < ApplicationJob
      def perform(event)
        event.fire
      end
    end
  end
end
