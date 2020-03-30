module Zaikio
  module Loom
    class EventSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize?(argument)
        argument.is_a? Event
      end

      def serialize(event)
        super(event.to_h)
      end

      def deserialize(hash)
        name = hash.delete('name')
        Event.new(name, hash)
      end
    end
  end
end
