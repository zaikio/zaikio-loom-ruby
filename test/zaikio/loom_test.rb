require "test_helper"

class Zaikio::LoomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zaikio::Loom::VERSION
  end

  def test_it_is_configurable
    Zaikio::Loom.configure do |config|
      config.environment = :test
      config.app_name = "test_app"
      config.password = "secret"
      config.version = "1.2.3"
    end

    assert_equal :test,               Zaikio::Loom.configuration.environment
    assert_equal "test_app",          Zaikio::Loom.configuration.app_name
    assert_equal "secret",            Zaikio::Loom.configuration.password
    assert_equal "1.2.3",             Zaikio::Loom.configuration.version
    assert_match "loom.zaikio.test", Zaikio::Loom.configuration.host
  end

  def test_that_helper_method_delegates_to_instance_method
    mock = Minitest::Mock.new
    mock.expect :call, mock, [:event_name, payload: { foo: "bar" }]
    mock.expect :fire, nil

    Zaikio::Loom::Event.stub(:new, mock) do
      Zaikio::Loom.fire_event(:event_name, payload: { foo: "bar" })
    end

    mock.verify
  end
end
