Zaikio::Loom.configure do |config|
  # Environment to which the gem should publish events to.
  # Possible values: :sandbox (default), :production
  config.environment = :sandbox

  # The name of your application like it is named in the directory of the
  # choosen enviroment.
  config.application 'my_application' do |app|
    # Your application's event password for the choosen environment
    # Do not add this password into version control.
    app.password = 'secret'
  end

  # The version of the event's payload format and structure
  config.version = '1.0'
end
