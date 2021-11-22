require "test_helper"

class Zaikio::LoomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zaikio::Loom::VERSION
  end

  def test_it_is_configurable
    Zaikio::Loom.configure do |config|
      config.environment = :test
      config.version = "1.2.3"

      config.application "test_app" do |app|
        app.password = "secret"
      end

      config.application "other_app" do |app|
        app.password = "pw"
      end
    end

    assert_equal :test,              Zaikio::Loom.configuration.environment
    assert_equal "test_app",         Zaikio::Loom.configuration.apps["test_app"].app_name
    assert_equal "secret",           Zaikio::Loom.configuration.apps["test_app"].password
    assert_equal "1.2.3",            Zaikio::Loom.configuration.version
    assert_match "loom.zaikio.test", Zaikio::Loom.configuration.host
    assert_equal "other_app",        Zaikio::Loom.configuration.apps["other_app"].app_name
    assert_equal "pw",               Zaikio::Loom.configuration.apps["other_app"].password
  end

  def test_that_helper_method_performs_fire_event_job
    event = OpenStruct.new()
    Zaikio::Loom::Event.expects(:new).returns(event)
    Zaikio::Loom::FireEventJob.expects(:perform_later).with(event)

    Zaikio::Loom.fire_event(:event_name, payload: { foo: "bar" })
  end

  def test_configure_queue
    job = Zaikio::Loom::FireEventJob.perform_later(nil)
    assert_equal "default", job.queue_name

    Zaikio::Loom.configure do |config|
      config.queue = :high_prio
    end

    job = Zaikio::Loom::FireEventJob.perform_later(nil)
    assert_equal "high_prio", job.queue_name

    Zaikio::Loom.configure do |config|
      config.queue = nil
    end
  end
end
