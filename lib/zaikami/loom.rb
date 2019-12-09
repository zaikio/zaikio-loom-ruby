require "zaikami/loom/configuration"
require "zaikami/loom/event"
require "zaikami/loom/version"

module Zaikami
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
      event.fire
    end
  end
end
