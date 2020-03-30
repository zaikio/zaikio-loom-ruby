module Zaikio
  module Loom
    class Engine < ::Rails::Engine
      isolate_namespace Zaikio::Loom
      engine_name "zaikio_loom"
      config.generators.api_only = true
    end
  end
end
