require "test_helper"

class Zaikio::Loom::EventSerializerTest < Minitest::Test
  def setup
    Zaikio::Loom.configure do |config|
      config.environment = :test

      config.application "test_app" do |app|
        app.password = "secret"
      end

      config.application "other_app" do |app|
        app.password = "pw"
      end

      config.version = "1.2.3"
    end
  end

  def event
    @event ||= Zaikio::Loom::Event.new(
      :name, subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def other_event
    @other_event ||= Zaikio::Loom::Event.new(
      "other_app.name", subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def serializer
    Zaikio::Loom::EventSerializer
  end

  def test_that_it_serializes_correctly
    assert serializer.serialize?(event)
    assert_equal serializer.deserialize(serializer.serialize(event)).to_h, event.to_h
  end

  def test_that_it_serializes_other_event_correctly
    assert serializer.serialize?(event)
    assert_equal serializer.deserialize(serializer.serialize(other_event)).to_h, other_event.to_h
  end
end
