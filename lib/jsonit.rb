require "jsonit/builder"
module Jsonit
  require "json" unless Object.respond_to?(:to_json)
  require "jsonit/rails/railtie" if defined?(::Rails)
  require "jsonit/tilt/tilt_jsonit" if defined?(::Tilt)

  if defined?(::Sinatra)
    module ::Sinatra::Templates
      def jsonit(template, options={}, locals={})
        render :jsonit, template, options, locals
      end
    end
  end
end
