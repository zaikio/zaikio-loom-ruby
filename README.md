# Zaikio Loom ruby gem

The Zaikio Loom ruby gem simplifies publishing events on the [Zaikio Loom event system](https://docs.zaikio.com/guide/loom/).

Applications can only publish events to Loom which have been configured in the
Zaikio Hub, on the "Provided events" tab under your App configuration.

## Installation

Install the gem and add to the application's Gemfile by executing:

```
$ bundle add zaikio-loom
```

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install zaikio-loom

## Usage

To configure the gem, first add an initializer to your application:

```ruby
# config/initializers/zaikio_loom.rb

Zaikio::Loom.configure do |config|

  # Loom instance to receive the events. Only `:sandbox` and `:production` will actually emit
  # events, all other environments will merely log the output, this can be controlled by
  # setting `config.logger`.
  config.environment = Rails.env

  # The name of your application, matches the "technical identifier" in the Hub
  config.application 'my_application' do |app|

    # Your application's event password for the chosen environment
    # Do not commit this password to version control.
    app.password = ENV.fetch('ZAIKIO_LOOM_PASSWORD')
  end

  # The version of the event payload, format and structure
  config.version = '1.0'
end
```

You can use multiple clients at once, just add a `config.application(name, &block)` for
each one. Now, you can fire events at Zaikio Loom:

```ruby
Zaikio::Loom.fire_event(
  :event_name,
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  payload: { foo: 'bar', baz: [1, 2, 3] }
)
```

This example would publish an event (in the background) to Zaikio Loom with a random UUID
and the current timestamp. If you want to publish the event for a specific client, you
have to include it as part of the event name:

```rb
Zaikio::Loom.fire_event(
  'my_other_app.event_name',
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  payload: { foo: 'bar', baz: [1, 2, 3] }
)
```

If you need more control over the published event, for example:

  - to provide a specific unique UUID or timestamp in the past, or
  - you want to override the version for this specific event, or
  - you want to check Loom's response to this request

then you can use the underlying `Event` constructor and call `#fire` on it:

```ruby
event = Zaikio::Loom::Event.new(
  :event_name,
  subject: 'Org/3a242896-fa57-41ba-997e-8c212d7157f3',
  id: 'f5cecfce-eda7-4eae-a0b2-62da7d51e8a2',
  payload: { foo: 'bar', baz: [1, 2, 3] },
  timestamp: Time.current,
  version: '1.1.beta'
)

unless event.fire         # imagine the event_name does not exist
  event.status_code       # => 422
  event.response_body     # => '{ "errors": { "name": ["excludes a valid event name"] } }'
end
```

### Required arguments

This gem is able to add some defaults or fallback values to the requests against the Loom
API, for example:

  - the app name,
  - an unique `id`,
  - the `version` or
  - the current `timestamp`.

Nevertheless, the following arguments are required for every fired event and must follow
the conventions described in the
[Loom API Guide](https://docs.zaikio.com/guide/loom/posting-events.html#payload-requirements):

  - the name of the event
  - a `subject` that triggered the event

Furthermore, the payload can be omitted, but must be set as a hash if given.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake
spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a
new version, update the version number in `version.rb`, and then run `bundle exec rake
release`, which will create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/zaikio/zaikio-loom-ruby. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zaikio Loom Ruby gem project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/zaikio/zaikio-loom-ruby/blob/master/CODE_OF_CONDUCT.md).
