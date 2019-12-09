module Zaikami
  module Loom
    module Host
      HOSTS = {
        development: 'http://loom.zaikami.test',
        test:        nil,
        staging:     'https://loom.staging.zaikami.cloud',
        sandbox:     'https://loom.sandbox.zaikami.cloud',
        production:  'https://loom.zaikami.cloud'
      }.freeze

      def self.for_environment(environment)
        HOST.fetch(environment.to_sym) do
          raise StandardError.new, "Invalid Zaikami::Loom environment '#{environment}'"
        end
      end
    end
  end
end
