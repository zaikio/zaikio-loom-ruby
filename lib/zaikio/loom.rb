require "zaikio/loom/app_configuration"
require "zaikio/loom/configuration"
require "zaikio/loom/event"
require "zaikio/loom/event_serializer"
require "zaikio/loom/railtie"
require "zaikio/loom/engine"
require "zaikio/loom/version"

module Zaikio
  module Loom
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def self.fire_event(name, **args)
      event = Event.new(name, **args)
      FireEventJob.perform_later(event)
    end
  end
end
