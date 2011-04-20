require "jsonit/rails/template_handler"

module Jsonit
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "jsonit.register_handler" do |app|
        app.paths["app/views"].eager_load!
        ActiveSupport.on_load(:action_view) do
          ActionView::Template.register_template_handler "jsonit", Jsonit::Rails::TemplateHandler
        end
      end
    end
  end
end
