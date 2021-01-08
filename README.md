# Zaikio Loom Ruby Gem

The Zaikio Loom Ruby Gem simplifies publishing events on the Zaikio Loom event system.

Applications can only publish events to Zaikio Loom which have been configured in the Zaikio Directory. With a developer account in the Zaikio Directory you will find the list of provided events in your App's configuration in the Directory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zaikio-loom'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zaikio-loom

## Usage

### Configuration

To configure the gem add an initializer to your application:

```ruby
# in config/initializers/zaikio_loom.rb
Zaikio::Loom.configure do |config|
  # Environment to which the gem should publish events to.
  # Possible values: :sandbox (default), :production
  config.environment = :sandbox

  # The name of your application like it is named in the directory of the
  # choosen enviroment.
  config.application 'my_application' do |app|
    # Your application's event password for the choosen environment
    # Do not add this password into version control.
    app.password = ENV.fetch('ZAIKIO_LOOM_PASSWORD')
  end

  # The version of the event's payload format and structure
  config.version = '1.0'
end
```

#### Multiple Clients

```ruby
# in config/initializers/zaikio_loom.rb
Zaikio::Loom.configure do |config|
  config.environment = :sandbox
  config.version = '1.0'

  config.application 'my_application' do |app|
    app.password = ENV.fetch('ZAIKIO_LOOM_PASSWORD')
  end

  config.application 'my_other_app' do |app|
    app.password = ENV.fetch('ZAIKIO_LOOM_OTHER_APP_PASSWORD')
  end
end
```

### Usage

Firing events to Zaikio Loom:

```ruby
Zaikio::Loom.fire_event(
  :event_name,
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  payload: { foo: 'bar', baz: [1, 2, 3] }
)
```

This example would publish an event (in the background) to Zaikio Loom with a random UUID and the current timestamp.

If you want to publish the event for a specific client, you have to add it as part of the event name:

```rb
Zaikio::Loom.fire_event(
  'my_other_app.event_name',
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  payload: { foo: 'bar', baz: [1, 2, 3] }
)
```

If you need more control over the published event, for example:

  - to provide a specific unique UUID or timestamp in the past or
  - you want to override the version for this specific event or
  - you want to check the Loom's response to this request

then you can use the method:

```ruby
event = Zaikio::Loom::Event.new(
  :event_name,
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  id: 'f5cecfce-eda7-4eae-a0b2-62da7d51e8a2',
  payload: { foo: 'bar', baz: [1, 2, 3] },
  timestamp: Time.current,
  version: '1.1.beta'
)

unless event.fire         # imaging the event_name does not exist
  event.status_code       # => 422
  event.response_body     # => '{ "errors": { "name": ["excludes a valid event name"] } }'
end
```

### Required arguments

This gem is able to add some defaults or fallback values to the requests against the Loom API, for example

  - the app name,
  - an unique `id`,
  - the `version` or
  - the current `timestamp`.

Nevertheless, the following arguments are required for every fired event and must follow the conventions described in the [Loom API Guide](https://docs.zaiku.com/guide/loom/posting-events.html#payload-requirements):

  - the name of the event
  - a `subject` that triggered the event

Furtheremore, the payload can be omitted, but must be a hash when present.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zaikio/zai-loom-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zaikio Loom Ruby gem project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/zaikio/zai-loom-ruby/blob/master/CODE_OF_CONDUCT.md).
