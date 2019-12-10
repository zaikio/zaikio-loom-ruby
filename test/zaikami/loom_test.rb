require "test_helper"

class Zaikami::LoomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zaikami::Loom::VERSION
  end

  def test_it_is_configurable
    Zaikami::Loom.configure do |config|
      config.environment = :test
      config.app_name = "test_app"
      config.password = "secret"
      config.version = "1.2.3"
    end

    assert_equal :test,               Zaikami::Loom.configuration.environment
    assert_equal "test_app",          Zaikami::Loom.configuration.app_name
    assert_equal "secret",            Zaikami::Loom.configuration.password
    assert_equal "1.2.3",             Zaikami::Loom.configuration.version
    assert_match "loom.zaikami.test", Zaikami::Loom.configuration.host
  end

  def test_that_helper_method_delegates_to_instance_method
    mock = Minitest::Mock.new
    mock.expect :call, mock, [:event_name, payload: { foo: "bar" }]
    mock.expect :fire, nil

    Zaikami::Loom::Event.stub(:new, mock) do
      Zaikami::Loom.fire_event(:event_name, payload: { foo: "bar" })
    end

    mock.verify
  end
end
