require 'data_list/column'
require 'active_support/dependencies'

module C140
  module DataList
    class Builder
      include C140::DataList::Column
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::CaptureHelper
      include ActionView::Helpers::UrlHelper
      include Rails.application.routes.url_helpers
      
      attr_accessor :object, :parent_list, :output_buffer, :controller

      def initialize(object, parent_list)
        @object, @parent_list, @output_buffer = object, parent_list, ''

      end

      protected
      def wrap_list_item(name, value, options)
        @output_buffer << content_tag(:li, value, options).html_safe
      end

    end
  end
end
