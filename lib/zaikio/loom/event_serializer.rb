module Zaikio
  module Loom
    class EventSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize?(argument)
        argument.is_a? Event
      end

      def serialize(event)
        super(event.to_h.stringify_keys)
      end

      def deserialize(hash)
        name = hash.delete("name").split(".").last
        timestamp = DateTime.parse(hash.delete("timestamp"))
        hash.delete("_aj_serialized")
        Event.new(name, **hash.symbolize_keys.merge(timestamp: timestamp))
      end
    end
  end
end
