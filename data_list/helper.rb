require 'data_list/list'

module C140
  module DataList
    module Helper
      def data_list_for(object, options={}, &block)
        list = C140::DataList::List.new(object, options, &block)
        list.output_buffer.html_safe
      end
    end
  end
end
