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

    assert_equal :test,              Zaikio::Loom.configuration.environment
    assert_equal "test_app",         Zaikio::Loom.configuration.app_name
    assert_equal "secret",           Zaikio::Loom.configuration.password
    assert_equal "1.2.3",            Zaikio::Loom.configuration.version
    assert_match "loom.zaikio.test", Zaikio::Loom.configuration.host
  end

  def test_that_helper_method_performs_fire_event_job
    event = OpenStruct.new()
    Zaikio::Loom::Event.expects(:new).returns(event)
    Zaikio::Loom::FireEventJob.expects(:perform_later).with(event)

    Zaikio::Loom.fire_event(:event_name, payload: { foo: "bar" })
  end
end
