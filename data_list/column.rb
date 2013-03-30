module C140
  module DataList
    module Column
      def blank_column(options={}, &block)
        @parent_list.header_widths << 15
        @parent_list.headers << " "
        wrap_list_item('', instance_eval(&block), options)
        nil
      end

      def options_column(options={}, &link_block)
        @parent_list.headers << " "
        @parent_list.header_widths << options[:width]
        temp = if block_given?
                 content_tag(:dl, :class=>'options') do
                   res = content_tag(:dt) do
                     content_tag(:a, '&nbsp;'.html_safe, :href => '#')
                   end
                   res << content_tag(:dd) do
                     content_tag(:ul) do
                       instance_eval &link_block
                     end
                   end
                 end
               end
        wrap_list_item('', temp, options)
        nil
      end

      def link_item(title, url, options={})
        content_tag :li, link_to(title, url, options)
      end

      def column(attribute_name, options={})
        if options[:label]
          @parent_list.headers << options[:label]
        else
          @parent_list.headers << attribute_name
        end
        @parent_list.header_widths << options[:width]
        value = if options[:value_method]
                  temp = @object.send(attribute_name)
                  if temp.nil?
                    "-"
                  else
                    temp = temp.send(options[:value_method])
                    if temp.kind_of? Array
                      temp.blank? ? "-" : temp.first
                    else
                      temp
                    end
                  end
                else
                  @object.send(attribute_name)
                end

        value = if value.kind_of? Date or value.kind_of? Time or value.kind_of? DateTime
                  options[:format] ||= :default
                  I18n.localize(value, :format=>options[:format]).to_s
                else
                  value
                end
        case options[:as]
          when :link
            value = link_to(value, @object.send(attribute_name))
          when :root_link
            value = link_to(value, @object)
        end
        value = "-" if value.blank? or value.to_s.empty?
        wrap_list_item(attribute_name, value, valid_html_options(options))
        nil
      end

      private
      def valid_html_options(options)
        op = {}
        options.each_with_index do |(key, value), index|
          if key == :width or key == :class or key == :style
            op[key] = options[key]
          end
        end
        op
      end
    end
  end
end
