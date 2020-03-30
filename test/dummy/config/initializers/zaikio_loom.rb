Zaikio::Loom.configure do |config|
  # Environment to which the gem should publish events to.
  # Possible values: :sandbox (default), :production
  config.environment = :sandbox

  # The name of your application like it is named in the directory of the
  # choosen enviroment.
  config.app_name = 'my_application'

  # Your application's event password for the choosen environment
  # Do not add this password into version control.
  config.password = 'secret'

  # The version of the event's payload format and structure
  config.version = '1.0'
end
