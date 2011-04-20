require "jsonit/builder"
module Jsonit
  module Rails
    class TemplateHandler
    default_format = Mime::JSON
    
    class << self
        def call(template)
          "::Jsonit::Builder.new do |json|" +
          template.source +
          "end.to_json"
        end
      end
    end
  end
end
