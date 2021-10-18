require "test_helper"

class Zaikio::Loom::EventTest < Minitest::Test
  def setup
    @log, pipe = IO.pipe

    Zaikio::Loom.configure do |config|
      config.environment = :test
      config.logger = Logger.new(pipe)
      config.version = "1.2.3"

      config.application "test_app" do |app|
        app.password = "secret"
      end

      config.application "other_app" do |app|
        app.password = "pw"
      end
    end
  end

  def event
    @event ||= Zaikio::Loom::Event.new(
      "test_app.name", subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def event_other_app
    @event_other_app ||= Zaikio::Loom::Event.new(
      "other_app.name", subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def test_that_it_returns_true_on_success
    stub_request(:post, "http://loom.zaikio.test/api/v1/events")
      .with(
        body: "{\"event\":{\"id\":\"a50e4163-98b9-4179-94c1-d7a54f9b00b0\",\"name\":\"test_app.name\",\"subject\":\"Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e\",\"timestamp\":\"#{Time.new(2019, 12, 10, 12, 18, 44).iso8601}\",\"version\":\"1.2.3\",\"payload\":{}}}",
        headers: {
          "Authorization" => "Basic dGVzdF9hcHA6c2VjcmV0",
          "Content-Type" => "application/json",
          "Host" => "loom.zaikio.test",
          "User-Agent" => "zaikio-loom:#{Zaikio::Loom::VERSION}"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    assert event.fire
  end

  def test_that_it_returns_true_on_success_for_other_app
    stub_request(:post, "http://loom.zaikio.test/api/v1/events")
      .with(
        body: "{\"event\":{\"id\":\"a50e4163-98b9-4179-94c1-d7a54f9b00b0\",\"name\":\"other_app.name\",\"subject\":\"Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e\",\"timestamp\":\"#{Time.new(2019, 12, 10, 12, 18, 44).iso8601}\",\"version\":\"1.2.3\",\"payload\":{}}}",
        headers: {
          "Authorization" => "Basic b3RoZXJfYXBwOnB3",
          "Content-Type" => "application/json",
          "Host" => "loom.zaikio.test",
          "User-Agent" => "zaikio-loom:#{Zaikio::Loom::VERSION}"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    assert event_other_app.fire
  end

  def test_that_it_does_not_fail_in_unknown_environments
    Zaikio::Loom.configuration.environment = :staging

    refute event.fire

    assert @log.gets.include?('Zaikio::Loom event')
    assert @log.gets.include?(event.id)
  end

  def test_that_it_returns_error_message_on_failure
    stub_request(:post, "http://loom.zaikio.test/api/v1/events")
      .to_return(status: 422, body: "{\"errors\":{\"name\":[\"can't be blank\"]}}", headers: {})

    assert_raises Zaikio::Loom::Error, 'Sending event failed (422): {"errors":{"name":["can\'t be blank"]}}' do
      event.fire
    end
  end
end
