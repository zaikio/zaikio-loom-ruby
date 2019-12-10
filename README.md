# Zaikami Loom Ruby Gem

The Zaikami Loom Ruby Gem simplifies publishing events on the Zaikami Loom event system.

Applications can only publish events to Zaikami Loom which have been configured in the Zaikami Directory. With a developer account in the Zaikami Directory you will find the list of provided events in your App's configuration in the Directory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zaikami-loom', git: 'https://github.com/crispymtn/zai-loom-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zaikami-loom

## Usage

### Configuration

To configure the gem add an initializer to your application:

```ruby
# in config/initializers/zaikami-loom.rb
Zaikami::Loom.configure do |config|
  # Environment to which the gem should publish events to.
  # Possible values: :sandbox (default), :production
  config.environment = :sandbox

  # The name of your application like it is named in the directory of the
  # choosen enviroment.
  config.app_name = 'my_application'

  # Your application's event password for the choosen environment
  # Do not add this password into version control.
  config.password = ENV.fetch('ZAIKAMI_LOOM_PASSWORD')

  # The version of the event's payload format and structure
  config.version = '1.0'
end
```

### Usage

Firing events to Zaikami Loom:

```ruby
Zaikami::Loom.fire_event(:event_name, payload: { foo: 'bar', baz: [1, 2, 3] })
```

This example would publish an event to Zaikami Loom with a random UUID and the current timestamp.

If you need more control over the published event, for example:

  - to provide a specific unique UUID or timestamp in the past or
  - you want to override the version for this specific event or
  - you want to check the Loom's response to this request

then you can use the method:

```ruby
event = Zaikami::Loom::Event.new(:event_name,
                                  id: 'f5cecfce-eda7-4eae-a0b2-62da7d51e8a2',
                                  payload: { foo: 'bar', baz: [1, 2, 3] },
                                  timestamp: Time.current,
                                  version: '1.1.beta')

unless event.fire         # imaging the event_name does not exist
  event.status_code       # => 422
  event.response_body     # => '{ "errors": { "name": ["excludes a valid event name"] } }'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/crispymtn/zai-loom-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Zaikami Loom Ruby gem project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/crispymtn/zai-loom-ruby/blob/master/CODE_OF_CONDUCT.md).
