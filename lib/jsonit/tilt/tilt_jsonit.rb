
module Tilt
  class JsonitTemplate < ::Tilt::Template
    default_mime_type = 'application/json'

    def self.engine_initialized?
      defined? ::Jsonit
    end

    def initialize_engine
      require_template_library 'jsonit'
    end

    def prepare; end

    def evaluate(scope, locals, &block)
      return super(scope, locals, &block) if data.respond_to?(:to_str)
      json = ::Jsonit::Builder.new
      data.call(json)
    end

    def precompiled_preamble(locals)
      "\n#{super};::Jsonit::Builder.new do |json|"
    end

    def precompiled_postamble(locals)
      "\nend.to_json"
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
  register 'jsonit', ::Tilt::JsonitTemplate
end
