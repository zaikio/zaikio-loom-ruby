require "test_helper"

class Zaikio::Loom::FireEventJobTest < ActiveSupport::TestCase
  def setup
    Zaikio::Loom.configure do |config|
      config.environment = :test
      config.app_name = "test_app"
      config.password = "secret"
      config.version = "1.2.3"
    end
  end

  def job
    Zaikio::Loom::FireEventJob.new
  end

  def event
    @event ||= Zaikio::Loom::Event.new(
      :name, subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def test_fires_event
    event.expects(:fire)

    job.perform(event)
  end
end
