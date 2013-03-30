require 'data_list/builder'
require 'will_paginate/view_helpers'

module C140
  module DataList
    class List
      include ActionView::Helpers::CaptureHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::UrlHelper
      include WillPaginate::ViewHelpers
      include Rails.application.routes.url_helpers
      attr_accessor :headers, :header_widths, :object, :output_buffer, :html_options, :request

      def initialize(object, html_options, &block)
        @object, @headers, @header_widths, @output_buffer, @html_options = object, [], [], '', html_options
        html_options[:class] ||= 'data-list'
        process_data_list(&block)
      end

      private
      def process_data_list(&block)
        arr_content = []
        if not @object.kind_of? Array
          @output_buffer << not_available
          return
        end
        if @object.length == 0
          @output_buffer << no_record
          return
        end
        @object.each do |o|
          builder = C140::DataList::Builder.new(o, self)
          capture(builder, &block)
          arr_content << content_tag(:li, content_tag(:ul, builder.output_buffer.html_safe, :class=>'list-row', :id=>o.id), :id=>"list-row-#{o.id}")
        end
        arr_content.insert(0, content_tag(:li, processed_headers))
        @output_buffer << content_tag(:ol, arr_content.join.html_safe, html_options).html_safe
        @output_buffer.insert(0, processed_total_records)
        @output_buffer << processed_pagination
        nil
      end

      def not_available
        content_tag :div do
          "No data available."
        end
      end

      def no_record
        content_tag :div do
          "No record found."
        end
      end

      def processed_headers
        @headers       = @headers[0..(@headers.count/@object.length)-1]
        @header_widths = @header_widths[0..(@header_widths.count/@object.length)-1]
        temp           = []
        @headers.each_with_index { |h, i| temp << content_tag(:li, h.to_s.capitalize, :style=>"width:#{@header_widths[i]}px;") }
        content_tag(:ul, temp.join.html_safe, :class=>'list-headers')
      end

      def processed_total_records
        if @html_options[:entry_name].nil?
          content_tag(:div, page_entries_info(@object).html_safe, :class=>"total-records")
        else
          content_tag(:div, page_entries_info(@object, :entry_name=>@html_options[:resource_name]).html_safe, :class=>"total-records")
        end

      end

      def processed_pagination
        #content_tag(:div, will_paginate(@object, {}), :class=>"list-pagination")
        " "
      end
    end
  end
end
