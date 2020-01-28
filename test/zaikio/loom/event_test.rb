require "test_helper"

class Zaikio::Loom::EventTest < Minitest::Test
  def setup
    Zaikio::Loom.configure do |config|
      config.environment = :test
      config.app_name = "test_app"
      config.password = "secret"
      config.version = "1.2.3"
    end
  end

  def event
    @event ||= Zaikio::Loom::Event.new(
      :name, subject: "Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e", id: "a50e4163-98b9-4179-94c1-d7a54f9b00b0", payload: {}, timestamp: Time.new(2019, 12, 10, 12, 18, 44)
    )
  end

  def test_that_it_returns_true_on_success
    stub_request(:post, "http://loom.zaikio.test/api/v1/events")
      .with(
        body: "{\"event\":{\"id\":\"a50e4163-98b9-4179-94c1-d7a54f9b00b0\",\"name\":\"test_app.name\",\"subject\":\"Per/bb23d602-d585-43e8-a9b6-3dda50c2d09e\",\"timestamp\":\"2019-12-10T12:18:44+01:00\",\"version\":\"1.2.3\",\"payload\":{}}}",
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

  def test_that_it_returns_error_message_on_failure
    stub_request(:post, "http://loom.zaikio.test/api/v1/events")
      .to_return(status: 422, body: "{\"errors\":{\"name\":[\"can't be blank\"]}}", headers: {})

    refute event.fire
    assert_equal 422, event.status_code
    assert_equal "{\"errors\":{\"name\":[\"can't be blank\"]}}", event.response_body
  end
end
